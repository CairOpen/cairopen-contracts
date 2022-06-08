%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from cairopen.string.string import String
from cairopen.string.conversion import (
    String_felt_to_string,
    String_ss_to_string,
    String_ss_arr_to_string,
)

#
# String_felt_to_string
#

@external
func test_felt_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let _felt = 12345

    let (str) = String_felt_to_string(_felt)

    assert str.len = 5
    assert str.data[0] = '1'
    assert str.data[1] = '2'
    assert str.data[2] = '3'
    assert str.data[3] = '4'
    assert str.data[4] = '5'
    return ()
end

#
# String_ss_to_string
#

@external
func test_ss_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let ss = 'Hello'

    let (str) = String_ss_to_string(ss)

    assert str.len = 5
    assert str.data[0] = 'H'
    assert str.data[1] = 'e'
    assert str.data[2] = 'l'
    assert str.data[3] = 'l'
    assert str.data[4] = 'o'
    return ()
end

#
# String_ss_to_string
#

# @external
# func test_ss_arr_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
#     let SS_ARR_SIZE = 3
#     let (ss_arr) = alloc()
#     assert ss_arr[0] = 'Hello'
#     assert ss_arr[1] = ', world'
#     assert ss_arr[2] = '!'

# let (str) = String_ss_arr_to_string(SS_ARR_SIZE, ss_arr)

# assert str.len = 13
#     assert str.data[0] = 'H'
#     assert str.data[1] = 'e'
#     assert str.data[2] = 'l'
#     assert str.data[3] = 'l'
#     assert str.data[4] = 'o'
#     assert str.data[5] = ','
#     assert str.data[6] = ' '
#     assert str.data[7] = 'w'
#     assert str.data[8] = 'o'
#     assert str.data[9] = 'r'
#     assert str.data[10] = 'l'
#     assert str.data[11] = 'd'
#     assert str.data[12] = '!'
#     return ()
# end
