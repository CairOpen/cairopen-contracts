%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_le

from cairopen.string.string import String
from cairopen.string.ASCII import StringCodec
from cairopen.string.libs.storage import strings_len, strings_data

//############
// Constants #
//############

@external
func test_char_size() {
    assert StringCodec.CHAR_SIZE = 2 ** 8;
    return ();
}

@external
func test_last_char_mask() {
    assert StringCodec.LAST_CHAR_MASK = 2 ** 8 - 1;  // 0b11111111
    return ();
}

@external
func test_numerical_offset() {
    assert StringCodec.NUMERICAL_OFFSET = 48;
    return ();
}

//##########
// Storage #
//##########

//
// write
//

@external
func test_write_string{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (str_data) = alloc();
    let str = String(57, str_data);
    assert str_data[0] = 'T';
    assert str_data[1] = 'h';
    assert str_data[2] = 'i';
    assert str_data[3] = 's';
    assert str_data[4] = ' ';
    assert str_data[5] = 'i';
    assert str_data[6] = 's';
    assert str_data[7] = ' ';
    assert str_data[8] = 'l';
    assert str_data[9] = 'e';
    assert str_data[10] = 's';
    assert str_data[11] = 's';
    assert str_data[12] = ' ';
    assert str_data[13] = 't';
    assert str_data[14] = 'h';
    assert str_data[15] = 'a';
    assert str_data[16] = 'n';
    assert str_data[17] = ' ';
    assert str_data[18] = '3';
    assert str_data[19] = '1';
    assert str_data[20] = ' ';
    assert str_data[21] = 'c';
    assert str_data[22] = 'h';
    assert str_data[23] = 'a';
    assert str_data[24] = 'r';
    assert str_data[25] = 's';
    assert str_data[26] = ',';
    assert str_data[27] = ' ';
    assert str_data[28] = 'b';
    assert str_data[29] = 'u';
    assert str_data[30] = 't';
    assert str_data[31] = ' ';
    assert str_data[32] = 't';
    assert str_data[33] = 'h';
    assert str_data[34] = 'e';
    assert str_data[35] = ' ';
    assert str_data[36] = 't';
    assert str_data[37] = 'o';
    assert str_data[38] = 't';
    assert str_data[39] = 'a';
    assert str_data[40] = 'l';
    assert str_data[41] = ' ';
    assert str_data[42] = 'i';
    assert str_data[43] = 's';
    assert str_data[44] = ' ';
    assert str_data[45] = 'm';
    assert str_data[46] = 'o';
    assert str_data[47] = 'r';
    assert str_data[48] = 'e';
    assert str_data[49] = ' ';
    assert str_data[50] = 't';
    assert str_data[51] = 'h';
    assert str_data[52] = 'a';
    assert str_data[53] = 'n';
    assert str_data[54] = ' ';
    assert str_data[55] = '3';
    assert str_data[56] = '1';

    StringCodec.write('test', str);

    let (stored_str_len) = strings_len.read('test');
    assert stored_str_len = 57;

    let (stored_str_0) = strings_data.read('test', 0);
    let (stored_str_1) = strings_data.read('test', 1);
    let (stored_str_2) = strings_data.read('test', 2);
    assert stored_str_0 = 'This is less than 31 chars, but';
    assert stored_str_1 = ' the total is more than 31';
    assert stored_str_2 = 0;

    return ();
}

@external
func test_write_from_char_arr{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (str_data) = alloc();
    assert str_data[0] = 'T';
    assert str_data[1] = 'h';
    assert str_data[2] = 'i';
    assert str_data[3] = 's';
    assert str_data[4] = ' ';
    assert str_data[5] = 'i';
    assert str_data[6] = 's';
    assert str_data[7] = ' ';
    assert str_data[8] = 'l';
    assert str_data[9] = 'e';
    assert str_data[10] = 's';
    assert str_data[11] = 's';
    assert str_data[12] = ' ';
    assert str_data[13] = 't';
    assert str_data[14] = 'h';
    assert str_data[15] = 'a';
    assert str_data[16] = 'n';
    assert str_data[17] = ' ';
    assert str_data[18] = '3';
    assert str_data[19] = '1';
    assert str_data[20] = ' ';
    assert str_data[21] = 'c';
    assert str_data[22] = 'h';
    assert str_data[23] = 'a';
    assert str_data[24] = 'r';
    assert str_data[25] = 's';
    assert str_data[26] = ',';
    assert str_data[27] = ' ';
    assert str_data[28] = 'b';
    assert str_data[29] = 'u';
    assert str_data[30] = 't';
    assert str_data[31] = ' ';
    assert str_data[32] = 't';
    assert str_data[33] = 'h';
    assert str_data[34] = 'e';
    assert str_data[35] = ' ';
    assert str_data[36] = 't';
    assert str_data[37] = 'o';
    assert str_data[38] = 't';
    assert str_data[39] = 'a';
    assert str_data[40] = 'l';
    assert str_data[41] = ' ';
    assert str_data[42] = 'i';
    assert str_data[43] = 's';
    assert str_data[44] = ' ';
    assert str_data[45] = 'm';
    assert str_data[46] = 'o';
    assert str_data[47] = 'r';
    assert str_data[48] = 'e';
    assert str_data[49] = ' ';
    assert str_data[50] = 't';
    assert str_data[51] = 'h';
    assert str_data[52] = 'a';
    assert str_data[53] = 'n';
    assert str_data[54] = ' ';
    assert str_data[55] = '3';
    assert str_data[56] = '1';

    StringCodec.write_from_char_arr('test', 57, str_data);

    let (stored_str_len) = strings_len.read('test');
    assert stored_str_len = 57;

    let (stored_str_0) = strings_data.read('test', 0);
    let (stored_str_1) = strings_data.read('test', 1);
    let (stored_str_2) = strings_data.read('test', 2);
    assert stored_str_0 = 'This is less than 31 chars, but';
    assert stored_str_1 = ' the total is more than 31';
    assert stored_str_2 = 0;

    return ();
}

//
// read
//

@external
func test_read_string{
    syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, bitwise_ptr: BitwiseBuiltin*, range_check_ptr
}() {
    strings_len.write('test', 57);
    strings_data.write('test', 0, 'This is less than 31 chars, but');
    strings_data.write('test', 1, ' the total is more than 31');

    let (str) = StringCodec.read('test');
    assert str.len = 57;
    assert str.data[0] = 'T';
    assert str.data[1] = 'h';
    assert str.data[2] = 'i';
    assert str.data[3] = 's';
    assert str.data[4] = ' ';
    assert str.data[5] = 'i';
    assert str.data[6] = 's';
    assert str.data[7] = ' ';
    assert str.data[8] = 'l';
    assert str.data[9] = 'e';
    assert str.data[10] = 's';
    assert str.data[11] = 's';
    assert str.data[12] = ' ';
    assert str.data[13] = 't';
    assert str.data[14] = 'h';
    assert str.data[15] = 'a';
    assert str.data[16] = 'n';
    assert str.data[17] = ' ';
    assert str.data[18] = '3';
    assert str.data[19] = '1';
    assert str.data[20] = ' ';
    assert str.data[21] = 'c';
    assert str.data[22] = 'h';
    assert str.data[23] = 'a';
    assert str.data[24] = 'r';
    assert str.data[25] = 's';
    assert str.data[26] = ',';
    assert str.data[27] = ' ';
    assert str.data[28] = 'b';
    assert str.data[29] = 'u';
    assert str.data[30] = 't';
    assert str.data[31] = ' ';
    assert str.data[32] = 't';
    assert str.data[33] = 'h';
    assert str.data[34] = 'e';
    assert str.data[35] = ' ';
    assert str.data[36] = 't';
    assert str.data[37] = 'o';
    assert str.data[38] = 't';
    assert str.data[39] = 'a';
    assert str.data[40] = 'l';
    assert str.data[41] = ' ';
    assert str.data[42] = 'i';
    assert str.data[43] = 's';
    assert str.data[44] = ' ';
    assert str.data[45] = 'm';
    assert str.data[46] = 'o';
    assert str.data[47] = 'r';
    assert str.data[48] = 'e';
    assert str.data[49] = ' ';
    assert str.data[50] = 't';
    assert str.data[51] = 'h';
    assert str.data[52] = 'a';
    assert str.data[53] = 'n';
    assert str.data[54] = ' ';
    assert str.data[55] = '3';
    assert str.data[56] = '1';

    return ();
}

//#############
// Conversion #
//#############

//
// felt_to_string
//

@external
func test_felt_to_string{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    let _felt = 12345;

    let (str) = StringCodec.felt_to_string(_felt);

    assert str.len = 5;
    assert str.data[0] = '1';
    assert str.data[1] = '2';
    assert str.data[2] = '3';
    assert str.data[3] = '4';
    assert str.data[4] = '5';
    return ();
}

//
// ss_to_string
//

@external
func test_ss_to_string{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    let ss = 'Hello';

    let (str) = StringCodec.ss_to_string(ss);

    assert str.len = 5;
    assert str.data[0] = 'H';
    assert str.data[1] = 'e';
    assert str.data[2] = 'l';
    assert str.data[3] = 'l';
    assert str.data[4] = 'o';
    return ();
}

//
// ss_arr_to_string
//

@external
func test_ss_arr_to_string{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    let SS_ARR_SIZE = 3;
    let (ss_arr) = alloc();
    assert ss_arr[0] = 'Hello';
    assert ss_arr[1] = ', world';
    assert ss_arr[2] = '!';

    let (str) = StringCodec.ss_arr_to_string(SS_ARR_SIZE, ss_arr);

    assert str.len = 13;
    assert str.data[0] = 'H';
    assert str.data[1] = 'e';
    assert str.data[2] = 'l';
    assert str.data[3] = 'l';
    assert str.data[4] = 'o';
    assert str.data[5] = ',';
    assert str.data[6] = ' ';
    assert str.data[7] = 'w';
    assert str.data[8] = 'o';
    assert str.data[9] = 'r';
    assert str.data[10] = 'l';
    assert str.data[11] = 'd';
    assert str.data[12] = '!';
    return ();
}

@external
func test_ss_arr_oversized_to_string{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    let SS_ARR_SIZE = 2;
    let (ss_arr) = alloc();
    assert ss_arr[0] = 'This is less than 31 chars';
    assert ss_arr[1] = 'But the total is more than 31';

    let (str) = StringCodec.ss_arr_to_string(SS_ARR_SIZE, ss_arr);

    assert str.len = 55;
    assert str.data[0] = 'T';
    assert str.data[1] = 'h';
    assert str.data[2] = 'i';
    assert str.data[3] = 's';
    assert str.data[4] = ' ';
    assert str.data[5] = 'i';
    assert str.data[6] = 's';
    assert str.data[7] = ' ';
    assert str.data[8] = 'l';
    assert str.data[9] = 'e';
    assert str.data[10] = 's';
    assert str.data[11] = 's';
    assert str.data[12] = ' ';
    assert str.data[13] = 't';
    assert str.data[14] = 'h';
    assert str.data[15] = 'a';
    assert str.data[16] = 'n';
    assert str.data[17] = ' ';
    assert str.data[18] = '3';
    assert str.data[19] = '1';
    assert str.data[20] = ' ';
    assert str.data[21] = 'c';
    assert str.data[22] = 'h';
    assert str.data[23] = 'a';
    assert str.data[24] = 'r';
    assert str.data[25] = 's';
    assert str.data[26] = 'B';
    assert str.data[27] = 'u';
    assert str.data[28] = 't';
    assert str.data[29] = ' ';
    assert str.data[30] = 't';
    assert str.data[31] = 'h';
    assert str.data[32] = 'e';
    assert str.data[33] = ' ';
    assert str.data[34] = 't';
    assert str.data[35] = 'o';
    assert str.data[36] = 't';
    assert str.data[37] = 'a';
    assert str.data[38] = 'l';
    assert str.data[39] = ' ';
    assert str.data[40] = 'i';
    assert str.data[41] = 's';
    assert str.data[42] = ' ';
    assert str.data[43] = 'm';
    assert str.data[44] = 'o';
    assert str.data[45] = 'r';
    assert str.data[46] = 'e';
    assert str.data[47] = ' ';
    assert str.data[48] = 't';
    assert str.data[49] = 'h';
    assert str.data[50] = 'a';
    assert str.data[51] = 'n';
    assert str.data[52] = ' ';
    assert str.data[53] = '3';
    assert str.data[54] = '1';
    return ();
}

//
// extract_last_char_from_ss
//

@external
func test_extract_last_char{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    let ss = 'Hello';

    let (ss_rem, char) = StringCodec.extract_last_char_from_ss(ss);

    assert ss_rem = 'Hell';
    assert char = 'o';
    return ();
}

@external
func test_extract_last_char_ss_too_long{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}() {
    let ss = 2 ** 248;

    %{ expect_revert(error_message="extract_last_char_from_ss: exceeding max short string value 2^248 - 1") %}
    let (ss_rem, char) = StringCodec.extract_last_char_from_ss(ss);
    return ();
}

//
// assert_char_encoding
//

@external
func test_assert_char_encoding{range_check_ptr}() {
    let char = 'H';
    StringCodec.assert_char_encoding(char);
    return ();
}

@external
func test_assert_char_encoding_fail{range_check_ptr}() {
    let char = 'Hi';
    %{ expect_revert(error_message="assert_char_encoding: char is not a single character") %}
    StringCodec.assert_char_encoding(char);
    return ();
}
