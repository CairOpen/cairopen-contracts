%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.alloc import alloc

from cairopen.math.array import concat_felt_arr
from cairopen.string.string import String
from cairopen.string.constants import LAST_CHAR_MASK, SHORT_STRING_MAX_VALUE, CHAR_SIZE

#
# Appends two strings together
# ** Wrapper of cairopen.math.array.concat_felt_arr **
#
# Parameters:
#   base (String): The first string
#   str (String): The second string
#
# Returns:
#   str (String): The appended string
#
func String_append{range_check_ptr}(base : String, str : String) -> (res : String):
    let (concat_len, concat) = concat_felt_arr(base.len, base.data, str.len, str.data)
    return (String(concat_len, concat))
end

#
# Appends a **single** char as a short string to a string
#
# Parameters:
#   base (String): The first string
#   char (felt): The character to append
#
# Returns:
#   str (String): The appended string
#
func String_append_char{range_check_ptr}(base : String, char : felt) -> (res : String):
    assert base.data[base.len] = char

    return (String(base.len + 1, base.data))
end

#
# Joins to strings together and adding a '/' in between if needed
# e.g. path_join("sekai.gg", "assets") -> "sekai.gg/assets"
#
# Parameters:
#   base (String): The first string
#   str (String): The second string
#
# Returns:
#   str (String): The string
#
func String_path_join{range_check_ptr}(base : String, str : String) -> (res : String):
    if base.data[base.len - 1] == '/':
        return String_append(base, str)
    end

    let (slash_base) = String_append_char(base, '/')
    return String_append(slash_base, str)
end

#
# Extracts the last character from a short string and returns the characters before as a short string
# Manages felt up to 2**248 - 1 (instead of unsigned_div_rem which is limited by rc_bound)
# _On the down side it requires BitwiseBuiltin for the whole call chain_
#
# Parameters:
#   ss (felt): The shortstring
#
# Returns:
#   ss_rem (felt): All the characters before as a short string
#   char (felt): The last character
#
func String_extract_last_char_from_ss{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss : felt
) -> (ss_rem : felt, char : felt):
    with_attr error_message("String : exceeding max short string value 2^248 - 1"):
        let (ss_masked) = bitwise_and(ss, SHORT_STRING_MAX_VALUE)
        assert ss - ss_masked = 0
    end

    let (char) = bitwise_and(ss, LAST_CHAR_MASK)
    let ss_rem = (ss - char) / CHAR_SIZE
    return (ss_rem, char)
end
