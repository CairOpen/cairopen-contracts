%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.squash_dict import squash_dict

func concat_arr{range_check_ptr}(
    arr1_len : felt, arr1 : felt*, arr2_len : felt, arr2 : felt*, size : felt
) -> (res_len : felt, res : felt*):
    alloc_locals
    let (local res : felt*) = alloc()
    memcpy(res, arr1, arr1_len * size)
    memcpy(res + arr1_len * size, arr2, arr2_len * size)
    return (arr1_len + arr2_len, res)
end

func concat_felt_arr{range_check_ptr}(
    arr1_len : felt, arr1 : felt*, arr2_len : felt, arr2 : felt*
) -> (res_len : felt, res : felt*):
    return concat_arr(arr1_len, arr1, arr2_len, arr2, 1)
end

func invert_arr{range_check_ptr}(arr_len : felt, arr : felt*, size : felt) -> (
    inv_arr_len : felt, inv_arr : felt*
):
    alloc_locals
    let (local inv_arr : felt*) = alloc()
    _loop_invert_arr(arr_len, arr, inv_arr, 0, size)
    return (arr_len, inv_arr)
end

func invert_felt_arr{range_check_ptr}(arr_len : felt, arr : felt*) -> (
    inv_arr_len : felt, inv_arr : felt*
):
    return invert_arr(arr_len, arr, 1)
end

func check_arr_unique{range_check_ptr}(arr_len : felt, arr : felt*):
    alloc_locals
    let (local dict_start : DictAccess*) = alloc()
    let (local squashed_dict : DictAccess*) = alloc()

    let (dict_end) = _build_dict(arr, arr_len, dict_start)

    with_attr error_message("Array: array is not unique"):
        squash_dict(dict_start, dict_end, squashed_dict)
    end

    return ()
end

#
# Internals
#

func _build_dict(arr : felt*, n_steps : felt, dict : DictAccess*) -> (dict : DictAccess*):
    if n_steps == 0:
        return (dict)
    end

    assert dict.key = [arr]
    assert dict.prev_value = 0
    assert dict.new_value = 1

    return _build_dict(arr + 1, n_steps - 1, dict + DictAccess.SIZE)
end

func _loop_invert_arr{range_check_ptr}(
    arr_len : felt, arr : felt*, inv_arr : felt*, index : felt, size : felt
):
    _sub_loop_invert_arr(arr_len, arr, inv_arr, size, index, size - 1)

    if arr_len == 1:
        return ()
    end

    return _loop_invert_arr(arr_len - 1, arr, inv_arr, index + 1, size)
end

func _sub_loop_invert_arr{range_check_ptr}(
    arr_len : felt,
    arr : felt*,
    inv_arr : felt*,
    size : felt,
    struct_index : felt,
    struct_offset : felt,
):
    tempvar in_id = (struct_index + 1) * size - 1 - struct_offset
    tempvar out_id = arr_len * size - 1 - struct_offset
    assert inv_arr[(struct_index + 1) * size - 1 - struct_offset] = arr[arr_len * size - 1 - struct_offset]

    if struct_offset == 0:
        return ()
    end

    return _sub_loop_invert_arr(arr_len, arr, inv_arr, size, struct_index, struct_offset - 1)
end
