%lang starknet

from starkware.cairo.common.alloc import alloc

from cairopen.math.array import (
    concat_arr,
    concat_felt_arr,
    invert_arr,
    invert_felt_arr,
    assert_felt_arr_unique,
)

struct Structure {
    m1: felt,
    m2: felt,
    m3: felt,
    m4: felt,
}

//
// concat_arr
//

@external
func test_concat_arr{range_check_ptr}() {
    alloc_locals;

    const arr1_len = 2;
    let (local arr1: Structure*) = alloc();
    assert arr1[0] = Structure(m1=1, m2=2, m3=3, m4=4);
    assert arr1[1] = Structure(m1=3, m2=4, m3=5, m4=6);

    const arr2_len = 2;
    let (local arr2: Structure*) = alloc();
    assert arr2[0] = Structure(m1=5, m2=6, m3=7, m4=8);
    assert arr2[1] = Structure(m1=7, m2=8, m3=9, m4=10);

    let (arr_len, felt_arr) = concat_arr(arr1_len, arr1, arr2_len, arr2, Structure.SIZE);
    let arr = cast(felt_arr, Structure*);

    assert arr_len = arr1_len + arr2_len;
    assert arr[0] = Structure(m1=1, m2=2, m3=3, m4=4);
    assert arr[1] = Structure(m1=3, m2=4, m3=5, m4=6);
    assert arr[2] = Structure(m1=5, m2=6, m3=7, m4=8);
    assert arr[3] = Structure(m1=7, m2=8, m3=9, m4=10);

    return ();
}

@external
func test_concat_arr_invalid_size{range_check_ptr}() {
    alloc_locals;

    const arr1_len = 2;
    let (local arr1: Structure*) = alloc();
    assert arr1[0] = Structure(m1=1, m2=2, m3=3, m4=4);
    assert arr1[1] = Structure(m1=3, m2=4, m3=5, m4=6);

    const arr2_len = 2;
    let (local arr2: Structure*) = alloc();
    assert arr2[0] = Structure(m1=5, m2=6, m3=7, m4=8);
    assert arr2[1] = Structure(m1=7, m2=8, m3=9, m4=10);

    %{ expect_revert("TRANSACTION_FAILED", "concat_arr: size must be greather or equal to 1") %}
    let (arr_len, felt_arr) = concat_arr(arr1_len, arr1, arr2_len, arr2, -1);

    return ();
}

@external
func test_concat_felt_arr{range_check_ptr}() {
    alloc_locals;

    const arr1_len = 3;
    let (local arr1: felt*) = alloc();
    assert arr1[0] = 1;
    assert arr1[1] = 2;
    assert arr1[2] = 3;

    const arr2_len = 3;
    let (local arr2: felt*) = alloc();
    assert arr2[0] = 4;
    assert arr2[1] = 5;
    assert arr2[2] = 6;

    let (arr_len, arr) = concat_felt_arr(arr1_len, arr1, arr2_len, arr2);
    assert arr_len = arr1_len + arr2_len;
    assert arr[0] = 1;
    assert arr[1] = 2;
    assert arr[2] = 3;
    assert arr[3] = 4;
    assert arr[4] = 5;
    assert arr[5] = 6;

    return ();
}

//
// invert_arr
//

@external
func test_invert_arr{range_check_ptr}() {
    alloc_locals;

    const arr_len = 4;
    let (local arr: Structure*) = alloc();
    assert arr[0] = Structure(m1=1, m2=2, m3=3, m4=4);
    assert arr[1] = Structure(m1=3, m2=4, m3=5, m4=6);
    assert arr[2] = Structure(m1=5, m2=6, m3=7, m4=8);
    assert arr[3] = Structure(m1=7, m2=8, m3=9, m4=10);

    let (inv_arr_len, felt_arr) = invert_arr(arr_len, arr, Structure.SIZE);
    let inv_arr = cast(felt_arr, Structure*);

    assert arr_len = inv_arr_len;
    assert inv_arr[0].m1 = 7;
    assert inv_arr[0].m2 = 8;
    assert inv_arr[0].m3 = 9;
    assert inv_arr[0].m4 = 10;
    assert inv_arr[1].m1 = 5;
    assert inv_arr[1].m2 = 6;
    assert inv_arr[1].m3 = 7;
    assert inv_arr[1].m4 = 8;
    assert inv_arr[2].m1 = 3;
    assert inv_arr[2].m2 = 4;
    assert inv_arr[2].m3 = 5;
    assert inv_arr[2].m4 = 6;
    assert inv_arr[3].m1 = 1;
    assert inv_arr[3].m2 = 2;
    assert inv_arr[3].m3 = 3;
    assert inv_arr[3].m4 = 4;

    return ();
}

@external
func test_invert_arr_invalid_size{range_check_ptr}() {
    alloc_locals;

    const arr_len = 4;
    let (local arr: Structure*) = alloc();
    assert arr[0] = Structure(m1=1, m2=2, m3=3, m4=4);
    assert arr[1] = Structure(m1=3, m2=4, m3=5, m4=6);
    assert arr[2] = Structure(m1=5, m2=6, m3=7, m4=8);
    assert arr[3] = Structure(m1=7, m2=8, m3=9, m4=10);

    %{ expect_revert("TRANSACTION_FAILED", "invert_arr: size must be greather or equal to 1") %}
    let (inv_arr_len, felt_arr) = invert_arr(arr_len, arr, 0);
    return ();
}

@external
func test_invert_felt_arr{range_check_ptr}() {
    alloc_locals;

    const arr_len = 4;
    let (local arr: felt*) = alloc();
    assert arr[0] = 1;
    assert arr[1] = 2;
    assert arr[2] = 3;
    assert arr[3] = 4;

    let (inv_arr_len, inv_arr) = invert_felt_arr(arr_len, arr);

    assert arr_len = inv_arr_len;
    assert inv_arr[0] = 4;
    assert inv_arr[1] = 3;
    assert inv_arr[2] = 2;
    assert inv_arr[3] = 1;

    return ();
}

//
// assert_felt_arr_unique
//

@external
func test_assert_felt_arr_unique{range_check_ptr}() {
    alloc_locals;

    const ARRAY_SIZE = 3;
    let (local array: felt*) = alloc();
    assert array[0] = 1;
    assert array[1] = 2;
    assert array[2] = 3;

    assert_felt_arr_unique(ARRAY_SIZE, array);

    return ();
}

@external
func test_assert_felt_arr_unique_fail{range_check_ptr}() {
    alloc_locals;

    const ARRAY_SIZE = 3;
    let (local array: felt*) = alloc();
    assert array[0] = 1;
    assert array[1] = 2;
    assert array[2] = 2;

    %{ expect_revert(error_message="assert_felt_arr_unique: array is not unique") %}
    assert_felt_arr_unique(ARRAY_SIZE, array);

    return ();
}
