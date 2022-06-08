%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem, assert_le
from starkware.cairo.common.math_cmp import is_le

from cairopen.math.array import concat_felt_arr, invert_felt_arr
from cairopen.string.string import String
from cairopen.string.constants import CHAR_SIZE, STRING_MAX_LEN

#
# Converts a felt to its utf-8 string value
# e.g. 12345 -> 0x3132333435 -> (5, [49, 50, 51, 52, 53]) -> String("12345")
#
# Parameters:
#   elem (felt): The felt value to convert
#
# Returns:
#   str (String): The string
#
func String_felt_to_string{range_check_ptr}(elem : felt) -> (str : String):
    alloc_locals
    let (local str_seed : felt*) = alloc()
    let (str_len) = _felt_to_inverted_string_loop(elem, str_seed, 0)

    let (_, str) = invert_felt_arr(str_len, str_seed)
    return (String(str_len, str))
end

func _felt_to_inverted_string_loop{range_check_ptr}(
    elem : felt, str_seed : felt*, index : felt
) -> (str_len : felt):
    alloc_locals
    with_attr error_message("String : exceeding max string length 2^15"):
        assert_le(index, STRING_MAX_LEN)
    end

    let (rem_elem, unit) = unsigned_div_rem(elem, 10)
    assert str_seed[index] = unit + '0'  # add '0' (= 48) to a number in range [0, 9] for utf-8 character code
    if rem_elem == 0:
        return (index + 1)
    end

    let (is_lower) = is_le(elem, rem_elem)
    if is_lower != 0:
        return (index + 1)
    end

    return _felt_to_inverted_string_loop(rem_elem, str_seed, index + 1)
end

#
# Converts a short string into a String
# e.g. 'Hello' -> String("Hello")
#
# Parameters:
#   ss (felt): The short string to convert
#
# Returns:
#   str (String): The string
#
func String_ss_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(ss : felt) -> (
    str : String
):
    alloc_locals
    let (local str_seed : felt*) = alloc()
    let (str_len) = _ss_to_inverted_string_loop(ss, str_seed, 0)

    let (_, str) = invert_felt_arr(str_len, str_seed)
    return (String(str_len, str))
end

func _ss_to_inverted_string_loop{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss : felt, str_seed : felt*, index : felt
) -> (str_len : felt):
    alloc_locals

    let (ss_rem, char) = unsigned_div_rem(ss, CHAR_SIZE)
    assert str_seed[index] = char

    if char == ss:
        return (index + 1)
    end

    let (is_lower) = is_le(ss, ss_rem)
    if is_lower != 0:
        return (index + 1)
    end

    return _ss_to_inverted_string_loop(ss_rem, str_seed, index + 1)
end

#
# Converts an array of short strings into a single String
# e.g. ['Hel', 'lo'] -> String("Hello")
#
# Parameters:
#   ss_arr_len (felt): The length of the array
#   ss_arr (felt*): The array of short strings to convert
#
# Returns:
#   str (String): The string
#
func String_ss_arr_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss_arr_len : felt, ss_arr : felt*
) -> (str : String):
    let (str_seed) = alloc()
    let (str_len, str) = _ss_arr_to_string_loop(ss_arr_len, ss_arr, 0, str_seed)
    return (String(str_len, str))
end

func _ss_arr_to_string_loop{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss_arr_len : felt, ss_arr : felt*, prev_str_len : felt, prev_str : felt*
) -> (str_len : felt, str : felt*):
    alloc_locals

    let (local ss_str_seed : felt*) = alloc()
    let (ss_str_len) = _ss_to_inverted_string_loop(ss_arr[ss_arr_len - 1], ss_str_seed, 0)

    let (str_len, str) = concat_felt_arr(ss_str_len, ss_str_seed, prev_str_len, prev_str)
    if ss_arr_len == 1:
        return (str_len, str)
    end

    return _ss_arr_to_string_loop(ss_arr_len - 1, ss_arr, str_len, str)
end
