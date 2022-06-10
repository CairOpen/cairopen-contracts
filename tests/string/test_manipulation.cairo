%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from cairopen.string.string import String
from cairopen.string.type import string

#
# path_join
#

@external
func test_path_join_with_end_slash{range_check_ptr}():
    let (base_data) = alloc()
    let base = string(5, base_data)
    assert base_data[0] = 'p'
    assert base_data[1] = 'a'
    assert base_data[2] = 't'
    assert base_data[3] = 'h'
    assert base_data[4] = '/'

    let (str_data) = alloc()
    let str = string(3, str_data)
    assert str_data[0] = 'd'
    assert str_data[1] = 'i'
    assert str_data[2] = 'r'

    let (join) = String.path_join(base, str)
    assert join.len = 8
    assert join.data[0] = 'p'
    assert join.data[1] = 'a'
    assert join.data[2] = 't'
    assert join.data[3] = 'h'
    assert join.data[4] = '/'
    assert join.data[5] = 'd'
    assert join.data[6] = 'i'
    assert join.data[7] = 'r'

    return ()
end

@external
func test_path_join_without_end_slash{range_check_ptr}():
    let (base_data) = alloc()
    let base = string(4, base_data)
    assert base_data[0] = 'p'
    assert base_data[1] = 'a'
    assert base_data[2] = 't'
    assert base_data[3] = 'h'

    let (str_data) = alloc()
    let str = string(3, str_data)
    assert str_data[0] = 'd'
    assert str_data[1] = 'i'
    assert str_data[2] = 'r'

    let (join) = String.path_join(base, str)
    assert join.len = 8
    assert join.data[0] = 'p'
    assert join.data[1] = 'a'
    assert join.data[2] = 't'
    assert join.data[3] = 'h'
    assert join.data[4] = '/'
    assert join.data[5] = 'd'
    assert join.data[6] = 'i'
    assert join.data[7] = 'r'

    return ()
end

#
# append
#

@external
func test_append{range_check_ptr}():
    let (base_data) = alloc()
    let base = string(6, base_data)
    assert base_data[0] = 'h'
    assert base_data[1] = 'e'
    assert base_data[2] = 'l'
    assert base_data[3] = 'l'
    assert base_data[4] = 'o'
    assert base_data[5] = ','

    let (str_data) = alloc()
    let str = string(6, str_data)
    assert str_data[0] = ' '
    assert str_data[1] = 'w'
    assert str_data[2] = 'o'
    assert str_data[3] = 'r'
    assert str_data[4] = 'l'
    assert str_data[5] = 'd'

    let (append) = String.append(base, str)
    assert append.len = 12
    assert append.data[0] = 'h'
    assert append.data[1] = 'e'
    assert append.data[2] = 'l'
    assert append.data[3] = 'l'
    assert append.data[4] = 'o'
    assert append.data[5] = ','
    assert append.data[6] = ' '
    assert append.data[7] = 'w'
    assert append.data[8] = 'o'
    assert append.data[9] = 'r'
    assert append.data[10] = 'l'
    assert append.data[11] = 'd'

    return ()
end

@external
func test_append_char{range_check_ptr}():
    let (base_data) = alloc()
    let base = string(5, base_data)
    assert base_data[0] = 'h'
    assert base_data[1] = 'e'
    assert base_data[2] = 'l'
    assert base_data[3] = 'l'
    assert base_data[4] = 'o'

    let (append) = String.append_char(base, '!')
    assert append.len = 6
    assert append.data[0] = 'h'
    assert append.data[1] = 'e'
    assert append.data[2] = 'l'
    assert append.data[3] = 'l'
    assert append.data[4] = 'o'
    assert append.data[5] = '!'

    return ()
end

#
# extract_last_char_from_ss
#

@external
func test_extract_last_char{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let ss = 'Hello'

    let (ss_rem, char) = String.extract_last_char_from_ss(ss)

    assert ss_rem = 'Hell'
    assert char = 'o'
    return ()
end

@external
func test_extract_last_char_ss_too_long{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}():
    let ss = 2 ** 248

    %{ expect_revert(error_message="string : exceeding max short string value 2^248 - 1") %}
    let (ss_rem, char) = String.extract_last_char_from_ss(ss)
    return ()
end
