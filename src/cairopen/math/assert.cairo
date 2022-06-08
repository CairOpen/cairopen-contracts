%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.squash_dict import squash_dict

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
