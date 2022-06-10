%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.bitwise import bitwise_and
from starkware.cairo.common.alloc import alloc

from cairopen.math.array import concat_felt_arr
from cairopen.string.type import string
from cairopen.string.constants import LAST_CHAR_MASK, SHORT_STRING_MAX_VALUE, CHAR_SIZE

# append
func manipulation_append{range_check_ptr}(base : string, str : string) -> (str : string):
    let (concat_len, concat) = concat_felt_arr(base.len, base.data, str.len, str.data)
    return (string(concat_len, concat))
end

# append character
func manipulation_append_char{range_check_ptr}(base : string, char : felt) -> (str : string):
    assert base.data[base.len] = char

    return (string(base.len + 1, base.data))
end

# path join
func manipulation_path_join{range_check_ptr}(base : string, str : string) -> (path : string):
    if base.data[base.len - 1] == '/':
        let (path) = manipulation_append(base, str)
        return (path)
    end

    let (slash_base) = manipulation_append_char(base, '/')
    let (path) = manipulation_append(slash_base, str)
    return (path)
end

# extract last character from short string
func manipulation_extract_last_char_from_ss{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
    ss : felt
) -> (ss_rem : felt, char : felt):
    with_attr error_message("string : exceeding max short string value 2^248 - 1"):
        let (ss_masked) = bitwise_and(ss, SHORT_STRING_MAX_VALUE)
        assert ss - ss_masked = 0
    end

    let (char) = bitwise_and(ss, LAST_CHAR_MASK)
    let ss_rem = (ss - char) / CHAR_SIZE
    return (ss_rem, char)
end
