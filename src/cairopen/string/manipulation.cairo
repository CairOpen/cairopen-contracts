%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.math import unsigned_div_rem, assert_le, assert_250_bit

from cairopen.math.array import concat_arr
from cairopen.string.string import String
from cairopen.string.constants import CHAR_SIZE, LAST_CHAR_MASK

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

    assert base.data[base.len] = '/'  # append the '/' to the first string
    base.len = base.len + 1
    return String_append(base, str)
end

#
# Appends two strings together
# ** Wrapper of Array.concat_arr **
#
# Parameters:
#   base (String): The first string
#   str (String): The second string
#
# Returns:
#   str (String): The appended string
#
func String_append{range_check_ptr}(base : String, str : String) -> (res : String):
    let (concat_len, concat) = concat_arr(base.len, base.data, str.len, str.data)
    return (String(concat_len, concat))
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
        # TODO update when assert_248_bit is implemented
        # We should assert 248 bit here but for now it's "enough" for starters
        # assert_le is limited by RANGE_CHECK_BOUND
        assert_250_bit(ss)
    end

    let (ss_rem, char) = unsigned_div_rem(ss, CHAR_SIZE)
    return (ss_rem, char)
end
