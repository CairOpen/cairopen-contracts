%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import unsigned_div_rem, assert_le
from starkware.cairo.common.math_cmp import is_le

from cairopen.math.array import concat_felt_arr, invert_felt_arr
from cairopen.string.type import string
from cairopen.string.manipulation import manipulation_extract_last_char_from_ss
from cairopen.string.constants import CHAR_SIZE, STRING_MAX_LEN

# felt to string
func conversion_felt_to_string{range_check_ptr}(elem : felt) -> (str : string):
    alloc_locals
    let (local str_seed : felt*) = alloc()
    let (str_len) = _loop_felt_to_inverted_string(elem, str_seed, 0)

    let (_, str) = invert_felt_arr(str_len, str_seed)
    return (string(str_len, str))
end

func _loop_felt_to_inverted_string{range_check_ptr}(
    elem : felt, str_seed : felt*, index : felt
) -> (str_len : felt):
    alloc_locals
    with_attr error_message("felt_to_string: exceeding max string length 2^15"):
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

    return _loop_felt_to_inverted_string(rem_elem, str_seed, index + 1)
end

# short string to string
func conversion_ss_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(ss : felt) -> (
    str : string
):
    alloc_locals
    let (local str_seed : felt*) = alloc()
    let (str_len) = _loop_ss_to_inverted_string(ss, str_seed, 0)

    let (_, str) = invert_felt_arr(str_len, str_seed)
    return (string(str_len, str))
end

func _loop_ss_to_inverted_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss : felt, str_seed : felt*, index : felt
) -> (str_len : felt):
    alloc_locals

    let (ss_rem, char) = manipulation_extract_last_char_from_ss(ss)
    assert str_seed[index] = char

    if char == ss:
        return (index + 1)
    end

    let (is_lower) = is_le(ss, ss_rem)
    if is_lower != 0:
        return (index + 1)
    end

    return _loop_ss_to_inverted_string(ss_rem, str_seed, index + 1)
end

# short string to string
func conversion_ss_arr_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss_arr_len : felt, ss_arr : felt*
) -> (str : string):
    let (str_seed) = alloc()
    let (str_len, str) = _loop_ss_arr_to_string(ss_arr_len, ss_arr, 0, 0, str_seed)
    return (string(str_len, str))
end

func _loop_ss_arr_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss_arr_len : felt, ss_arr : felt*, ss_index : felt, prev_str_len : felt, prev_str : felt*
) -> (str_len : felt, str : felt*):
    alloc_locals

    let (local ss_str_seed : felt*) = alloc()
    let (ss_str_len) = _loop_ss_to_inverted_string(ss_arr[ss_index], ss_str_seed, 0)
    let (_, str_str) = invert_felt_arr(ss_str_len, ss_str_seed)

    let (str_len, str) = concat_felt_arr(prev_str_len, prev_str, ss_str_len, str_str)
    if ss_index == ss_arr_len - 1:
        return (str_len, str)
    end

    return _loop_ss_arr_to_string(ss_arr_len, ss_arr, ss_index + 1, str_len, str)
end
