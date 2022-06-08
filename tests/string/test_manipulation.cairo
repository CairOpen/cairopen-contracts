%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from cairopen.string.string import String
from cairopen.string.manipulation import String_extract_last_char_from_ss

#
# String_extract_last_char_from_ss
#

@external
func test_extract_last_char{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let ss = 'Hello'

    let (ss_rem, char) = String_extract_last_char_from_ss(ss)

    assert ss_rem = 'Hell'
    assert char = 'o'
    return ()
end

@external
func test_extract_last_char_ss_too_long{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let ss = 2 ** 250  # TODO check that with 2**248 when assert_248_bit is implemented

    %{ expect_revert(error_message="String : exceeding max short string value 2^248 - 1") %}
    let (ss_rem, char) = String_extract_last_char_from_ss(ss)
    return ()
end
