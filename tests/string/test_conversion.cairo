%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_le

from cairopen.string.string import String
from cairopen.string.constants import SHORT_STRING_MAX_LEN
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
# String_ss_arr_to_string
#

@external
func test_ss_arr_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let SS_ARR_SIZE = 3
    let (ss_arr) = alloc()
    assert ss_arr[0] = 'Hello'
    assert ss_arr[1] = ', world'
    assert ss_arr[2] = '!'

    let (str) = String_ss_arr_to_string(SS_ARR_SIZE, ss_arr)

    assert str.len = 13
    assert str.data[0] = 'H'
    assert str.data[1] = 'e'
    assert str.data[2] = 'l'
    assert str.data[3] = 'l'
    assert str.data[4] = 'o'
    assert str.data[5] = ','
    assert str.data[6] = ' '
    assert str.data[7] = 'w'
    assert str.data[8] = 'o'
    assert str.data[9] = 'r'
    assert str.data[10] = 'l'
    assert str.data[11] = 'd'
    assert str.data[12] = '!'
    return ()
end

@external
func test_ss_arr_oversized_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let SS_ARR_SIZE = 2
    let (ss_arr) = alloc()
    assert ss_arr[0] = 'This is less than 31 chars'
    assert ss_arr[1] = 'But the total is more than 31'

    let (str) = String_ss_arr_to_string(SS_ARR_SIZE, ss_arr)

    assert str.len = 55
    assert str.data[0] = 'T'
    assert str.data[1] = 'h'
    assert str.data[2] = 'i'
    assert str.data[3] = 's'
    assert str.data[4] = ' '
    assert str.data[5] = 'i'
    assert str.data[6] = 's'
    assert str.data[7] = ' '
    assert str.data[8] = 'l'
    assert str.data[9] = 'e'
    assert str.data[10] = 's'
    assert str.data[11] = 's'
    assert str.data[12] = ' '
    assert str.data[13] = 't'
    assert str.data[14] = 'h'
    assert str.data[15] = 'a'
    assert str.data[16] = 'n'
    assert str.data[17] = ' '
    assert str.data[18] = '3'
    assert str.data[19] = '1'
    assert str.data[20] = ' '
    assert str.data[21] = 'c'
    assert str.data[22] = 'h'
    assert str.data[23] = 'a'
    assert str.data[24] = 'r'
    assert str.data[25] = 's'
    assert str.data[26] = 'B'
    assert str.data[27] = 'u'
    assert str.data[28] = 't'
    assert str.data[29] = ' '
    assert str.data[30] = 't'
    assert str.data[31] = 'h'
    assert str.data[32] = 'e'
    assert str.data[33] = ' '
    assert str.data[34] = 't'
    assert str.data[35] = 'o'
    assert str.data[36] = 't'
    assert str.data[37] = 'a'
    assert str.data[38] = 'l'
    assert str.data[39] = ' '
    assert str.data[40] = 'i'
    assert str.data[41] = 's'
    assert str.data[42] = ' '
    assert str.data[43] = 'm'
    assert str.data[44] = 'o'
    assert str.data[45] = 'r'
    assert str.data[46] = 'e'
    assert str.data[47] = ' '
    assert str.data[48] = 't'
    assert str.data[49] = 'h'
    assert str.data[50] = 'a'
    assert str.data[51] = 'n'
    assert str.data[52] = ' '
    assert str.data[53] = '3'
    assert str.data[54] = '1'
    return ()
end
