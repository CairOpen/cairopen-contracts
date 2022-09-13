%lang starknet

from starkware.cairo.common.alloc import alloc

from cairopen.string.string import String
from cairopen.string.utils import StringUtil

//
// path_join
//

@external
func test_path_join_with_end_slash{range_check_ptr}() {
    let (base_data) = alloc();
    let base = String(5, base_data);
    assert base_data[0] = 'p';
    assert base_data[1] = 'a';
    assert base_data[2] = 't';
    assert base_data[3] = 'h';
    assert base_data[4] = '/';

    let (str_data) = alloc();
    let str = String(3, str_data);
    assert str_data[0] = 'd';
    assert str_data[1] = 'i';
    assert str_data[2] = 'r';

    let (join) = StringUtil.path_join(base, str);
    assert join.len = 8;
    assert join.data[0] = 'p';
    assert join.data[1] = 'a';
    assert join.data[2] = 't';
    assert join.data[3] = 'h';
    assert join.data[4] = '/';
    assert join.data[5] = 'd';
    assert join.data[6] = 'i';
    assert join.data[7] = 'r';

    return ();
}

@external
func test_path_join_without_end_slash{range_check_ptr}() {
    let (base_data) = alloc();
    let base = String(4, base_data);
    assert base_data[0] = 'p';
    assert base_data[1] = 'a';
    assert base_data[2] = 't';
    assert base_data[3] = 'h';

    let (str_data) = alloc();
    let str = String(3, str_data);
    assert str_data[0] = 'd';
    assert str_data[1] = 'i';
    assert str_data[2] = 'r';

    let (join) = StringUtil.path_join(base, str);
    assert join.len = 8;
    assert join.data[0] = 'p';
    assert join.data[1] = 'a';
    assert join.data[2] = 't';
    assert join.data[3] = 'h';
    assert join.data[4] = '/';
    assert join.data[5] = 'd';
    assert join.data[6] = 'i';
    assert join.data[7] = 'r';

    return ();
}

//
// concat
//

@external
func test_concat{range_check_ptr}() {
    let (base_data) = alloc();
    let base = String(6, base_data);
    assert base_data[0] = 'h';
    assert base_data[1] = 'e';
    assert base_data[2] = 'l';
    assert base_data[3] = 'l';
    assert base_data[4] = 'o';
    assert base_data[5] = ',';

    let (str_data) = alloc();
    let str = String(6, str_data);
    assert str_data[0] = ' ';
    assert str_data[1] = 'w';
    assert str_data[2] = 'o';
    assert str_data[3] = 'r';
    assert str_data[4] = 'l';
    assert str_data[5] = 'd';

    let (concat) = StringUtil.concat(base, str);
    assert concat.len = 12;
    assert concat.data[0] = 'h';
    assert concat.data[1] = 'e';
    assert concat.data[2] = 'l';
    assert concat.data[3] = 'l';
    assert concat.data[4] = 'o';
    assert concat.data[5] = ',';
    assert concat.data[6] = ' ';
    assert concat.data[7] = 'w';
    assert concat.data[8] = 'o';
    assert concat.data[9] = 'r';
    assert concat.data[10] = 'l';
    assert concat.data[11] = 'd';

    return ();
}

//
// append_char
//

@external
func test_append_char{range_check_ptr}() {
    let (base_data) = alloc();
    let base = String(5, base_data);
    assert base_data[0] = 'h';
    assert base_data[1] = 'e';
    assert base_data[2] = 'l';
    assert base_data[3] = 'l';
    assert base_data[4] = 'o';

    let (append) = StringUtil.append_char(base, '!');
    assert append.len = 6;
    assert append.data[0] = 'h';
    assert append.data[1] = 'e';
    assert append.data[2] = 'l';
    assert append.data[3] = 'l';
    assert append.data[4] = 'o';
    assert append.data[5] = '!';

    return ();
}
