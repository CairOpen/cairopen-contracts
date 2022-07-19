%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.dict_access import DictAccess
from starkware.cairo.common.math import assert_le, sqrt, assert_in_range
from starkware.cairo.common.memcpy import memcpy
from starkware.cairo.common.squash_dict import squash_dict
from starkware.cairo.common.usort import usort
from starkware.cairo.common.math_cmp import is_le


# @dev Concatenates two arrays together
# @implicit range_check_ptr (felt)
# @param arr1_len (felt): The first array's length
# @param arr1 (felt* | struct*): The first array (can be a struct or a felt)
# @param arr2_len (felt): The second array's length
# @param arr2 (felt* | struct*): The second array (can be a struct or a felt)
# @param size (felt): The size of the struct
# @return concat_len (felt): The length of the concatenated array
# @return concat (felt*): The concatenated array (as a felt*, recast it for a struct*)
func concat_arr{range_check_ptr}(
    arr1_len : felt, arr1 : felt*, arr2_len : felt, arr2 : felt*, size : felt
) -> (concat_len : felt, concat : felt*):
    alloc_locals
    with_attr error_message("concat_arr: size must be greather or equal to 1"):
        assert_le(1, size)
    end
    let (local res : felt*) = alloc()
    memcpy(res, arr1, arr1_len * size)
    memcpy(res + arr1_len * size, arr2, arr2_len * size)
    return (arr1_len + arr2_len, res)
end

# @dev Concatenates two **felt** arrays together
# @implicit range_check_ptr (felt)
# @param arr1_len (felt): The first array's length
# @param arr1 (felt*): The first array
# @param arr2_len (felt): The second array's length
# @param arr2 (felt*): The second array
# @return concat_len (felt): The length of the concatenated array
# @return concat (felt*): The concatenated array
func concat_felt_arr{range_check_ptr}(
    arr1_len : felt, arr1 : felt*, arr2_len : felt, arr2 : felt*
) -> (concat_len : felt, concat : felt*):
    return concat_arr(arr1_len, arr1, arr2_len, arr2, 1)
end

# @dev Inverts an array
# @implicit range_check_ptr (felt)
# @param arr_len (felt): The array's length
# @param arr (felt*): The array (can be a struct or a felt)
# @param size (felt): The struct size
# @return inv_arr_len (felt): The inverted array's length
# @return inv_arr (felt*): The inverted array
func invert_arr{range_check_ptr}(arr_len : felt, arr : felt*, size : felt) -> (
    inv_arr_len : felt, inv_arr : felt*
):
    alloc_locals
    with_attr error_message("invert_arr: size must be greather or equal to 1"):
        assert_le(1, size)
    end
    let (local inv_arr : felt*) = alloc()
    _loop_invert_arr(arr_len, arr, inv_arr, 0, size)
    return (arr_len, inv_arr)
end

# @dev Inverts a **felt** array
# @implicit range_check_ptr (felt)
# @param arr_len (felt): The array's length
# @param arr (felt*): The array (can be a struct or a felt)
# @param size (felt): The struct size
# @return inv_arr_len (felt): The inverted array's length
# @return inv_arr (felt*): The inverted array
func invert_felt_arr{range_check_ptr}(arr_len : felt, arr : felt*) -> (
    inv_arr_len : felt, inv_arr : felt*
):
    return invert_arr(arr_len, arr, 1)
end

#
# Asserts
#

# @dev Asserts whether a **felt** array has no duplicate value
# @dev reverts if there is a duplicate value
# @implicit range_check_ptr (felt)
# @param arr_len (felt): The array's length
# @param arr (felt*): The array
func assert_felt_arr_unique{range_check_ptr}(arr_len : felt, arr : felt*):
    alloc_locals
    let (local dict_start : DictAccess*) = alloc()
    let (local squashed_dict : DictAccess*) = alloc()

    let (dict_end) = _build_dict(arr, arr_len, dict_start)

    with_attr error_message("assert_felt_arr_unique: array is not unique"):
        squash_dict(dict_start, dict_end, squashed_dict)
    end

    return ()
end

# Compute the sum of the element in an array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - felt with the sum of each element of the array.
func sum(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return(0)
    end
    let (output) = sum(input_len - 1, input + 1) 
    return(output + [input])
end

# Compute the arithmetic mean along the array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - arithmetic mean.
func mean(input_len : felt, input : felt*) -> (output : felt):
    let (s) = sum(input_len, input)
    return(s / input_len)
end

# Compute the scalar multiplication of an array.
# Args:
#   input_len - length of the felt array.
#   scalar - felt that multiplies the array.
#   input - felt array.
# Returns:
#   output - scalar product felt.
func scalar_product(input_len : felt, scalar : felt, input : felt*) -> (output : felt):    
    if input_len == 0:
        return(0)
    end
    let (d) = scalar_product(input_len - 1, scalar, input + 1)
    return (scalar * [input] + d) 
end

# Compute the median along the array.
# Args:
#   input_len - length of the felt array.
#   vs - felt array.
# Returns:
#   output - median.
func median(input_len : felt, input : felt*) -> (med : felt):
    tempvar is_even : felt
    %{
        ids.is_even = 1 if (ids.input_len % 2 == 0) else 0
    %}
    if is_even == 1:
        return(input[input_len / 2])
    else:
        tempvar a = input[((input_len - 1) / 2) - 1]
        tempvar b = input[((input_len + 1) / 2) - 1]
        return((a + b) / 2)
    end
end

# Compute the dot product of two arrays.
# Args:
#   input_len - length of the felt arrays. If they do not have the same length an error will appear.
#   input1 - first felt array.
#   input2 - second felt array.
# Returns:
#   output - dot product felt.
func dot(input_len : felt, input1 : felt*, input2 : felt*) -> (output : felt):    
    if input_len == 1:
        return(0)
    end
    let (d) = dot(input_len - 1, input1 + 1, input2 + 1)
    return ([input1] * [input2] + d) 
end

# Obtain the minimum value in an array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - minimum value.
func min(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return (input[0])
    end
    let (input_len_prev) = min(input_len - 1, input)
    let min_prev = input[input_len - 1]
    tempvar output : felt
    %{
        ids.output = min(ids.input_len_prev, ids.min_prev)
    %}
    return(output)
end

# @dev Obtain the maximum value in an array.
# @param input_len (felt): length of the felt array
# @param input (felt*): felt array
# @return output (felt): Maximum value
func max(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return (input[0])
    end
    let (input_len_prev) = max(input_len - 1, input)
    let max_prev = input[input_len - 1]
    tempvar output : felt
    %{
        ids.output = max(ids.input_len_prev, ids.max_prev)
    %}
    return(output)
end


# Compute the sum of the element in an array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - felt with the sum of each element of the array.
func summation(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return(0)
    end
    let (output) = sum(input_len - 1, input + 1) 
    return(output + [input])
end

# Compute the arithmetic mean along the array.
# Args:
#   input_len - length of the felt array.
#   input - felt array.
# Returns:
#   output - arithmetic mean.
func mean(input_len : felt, input : felt*) -> (output : felt):
    let (s) = sum(input_len, input)
    return(s / input_len)
end

# Compute the scalar multiplication of an array.
# Args:
#   input_len - length of the felt array.
#   scalar - felt that multiplies the array.
#   input - felt array.
# Returns:
#   output - scalar product felt.
func scalar_product(input_len : felt, scalar : felt, input : felt*) -> (output : felt):    
    if input_len == 0:
        return(0)
    end
    let (d) = scalar_product(input_len - 1, scalar, input + 1)
    return (scalar * [input] + d) 
end

# Compute the median along the array.
# Args:
#   input_len - length of the felt array.
#   vs - felt array.
# Returns:
#   output - median.
func median(input_len : felt, input : felt*) -> (med : felt):
    tempvar is_even : felt
    %{
        ids.is_even = 1 if (ids.input_len % 2 == 0) else 0
    %}
    if is_even == 1:
        return(input[input_len / 2])
    else:
        tempvar a = input[((input_len - 1) / 2) - 1]
        tempvar b = input[((input_len + 1) / 2) - 1]
        return((a + b) / 2)
    end
end

# @dev Compute the dot product of two arrays
# @param input_len (felt): length of the felt arrays. If they do not have the same length an error will appear.
# @param input1 (felt*): first felt array.
# @param input2 (felt*): second felt array.
# @return output (felt): dot product felt.
func dot(input_len : felt, input1 : felt*, input2 : felt*) -> (output : felt):    
    if input_len == 0:
        return(0)
    end
    let (d) = dot(input_len - 1, input1 + 1, input2 + 1)
    return ([input1] * [input2] + d) 
end

# @dev Obtain the minimum value in an array.
# @param input_len (felt): length of the felt array
# @param input (felt*): felt array.
# @return output (felt): minimum value.
func min(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return (input[0])
    end
    let (input_len_prev) = min(input_len - 1, input)
    let min_prev = input[input_len - 1]
    tempvar output : felt
    %{
        ids.output = min(ids.input_len_prev, ids.min_prev)
    %}
    return(output)
end

# @dev Obtain the maximum value in an array.
# @param input_len (felt): length of the felt array
# @param input (felt*): felt array where new values will be stored
# @return output (felt): maximum value.
func max(input_len : felt, input : felt*) -> (output : felt):
    if input_len == 0:
        return (input[0])
    end
    let (input_len_prev) = max(input_len - 1, input)
    let max_prev = input[input_len - 1]
    tempvar output : felt
    %{
        ids.output = max(ids.input_len_prev, ids.max_prev)
    %}
    return(output)
end

# @dev Copies values from one array to another, broadcasting as necessary.
func copyto(input_len : felt, input : felt*, new_array : felt*) -> ():
    if input_len == 0:
        return()
    end
    assert[new_array] = input[0]
    return copyto(input_len - 1, input + 1, new_array + 1)
end

# @dev Return the indices of the bins to which each value in input array belongs.
func digitize{range_check_ptr : felt}(input_len : felt, input : felt*, new_array : felt*, bins_len : felt, bins : felt*) -> ():
    if input_len == 0:
        return()
    end
    let (bin) = _value_into_bins(bins_len, bins, input[0]) 
    assert[new_array] = bin
    return digitize(input_len - 1, input + 1, new_array + 1, bins_len , bins)
end

# @dev Count number of occurrences of each value in array of non-negative ints.
# @param input_len (felt): length of the felt array
# @param input (felt*): felt array
# @param new_array (felt*): felt array where new values will be stored
func bincount(input_len : felt, input : felt*, new_array : felt*) -> ():
    _bincount(input_len, input_len, input, new_array, 0)
    return()
end

# @dev Indicates if an array contains a certain felt
# @param input_len (felt): length of the felt array
# @param value (felt): felt array
# @param input (felt*): felt array where new values will be stored
# @return output (felt): 1 if the felt is contained, 0 if not.
func contain_count(value : felt, input_len : felt, input : felt*) -> (result : felt):
    alloc_locals
    if input_len == 0:
        return(0)
    end
    local t
    if value == input[0]:
        t = 1
    else:
        t = 0
    end
    let (local total) = contain_count(value, input_len - 1, input + 1)
    return (t + total)
end

# @dev Indicates if an array contains a certain felt
# @implicit range_check_ptr (felt)
# @param input_len (felt): length of the felt array
# @param value (felt): felt array
# @param input (felt*): felt array where new values will be stored
# @return output (felt): 1 if the felt is contained, 0 if not.
func contains(value : felt, input_len : felt, input : felt*) -> (result : felt):
    if input_len == 0:
        return(0)
    end

    if value == input[0]:
        return (1)
    else:
        return contains(value, input_len - 1, input + 1) 
    end
end

# @dev Helper function, calculates the deviations of each data point from the mean, and square the result of each.
# @implicit range_check_ptr (felt)
# @param input_len (felt): length of the felt array
# @param input (felt*): felt array
# @param output (felt*): felt array where new values will be stored
# @param step (felt): must be 0 when first called 
# @param mu (felt): felt representing the mean
func helper_var(input_len : felt, input : felt*, output : felt*, step : felt, mu : felt):
    
    if input_len == step: 
        return ()
    end

    tempvar val : felt 
    val = [input]

    tempvar dif : felt
    dif = val - mu

    assert [output] =  dif*dif
    helper_var(input_len, input + 1, output + 1, step + 1, mu)
    return()
end

# @dev Compute the variance along the specified array.
# @param input_len (felt): length of the felt array.
# @param input (felt*): felt array.
# @return var (felt): variance.
func var(input_len : felt, input : felt*) -> (output : felt):
    alloc_locals

    let (mu) = mean(input_len, input)
    let (local inter : felt*) = alloc()

    helper_var(input_len=input_len, input=input, output=inter, step=0, mu=mu)

    let (var) = mean(input_len, inter)

    return(output=var)
end 

# @dev Compute the standard deviation along the specified array.
# @implicit range_check_ptr (felt)
# @param input_len (felt): length of the felt array.
# @param input (felt*): felt array.
# @return sd (felt): floor value of the standard deviation.
func std{range_check_ptr}(input_len : felt, input : felt*) -> (output : felt):
    
    let (v) = var(input_len, input)
    let (sd) = sqrt(v)

    return(sd)
end

# @dev Returns the q-th percentile of the array elements
# @implicit range_check_ptr (felt)
# @param input_len (felt): length of the felt array.
# @param input (felt*): sorted felt array.
# @param q (felt): felt between 1 and 100
# @return output (felt): felt value of the q percetile
func percentile{range_check_ptr}(input_len : felt, input : felt*, q : felt) -> (output : felt):

    assert_in_range(q,1,101)

    tempvar index : felt
    tempvar isInt : felt

    if q == 100:
        return(input[input_len - 1])
    end
    %{
        i = (ids.q/100) * ids.input_len

        ids.isInt = 1 if i%1 == 0 else 0
        ids.index =  round(i)
    %}
    if isInt == 0:
        return(input[index - 1])
    end

    let x1 = input[index - 1]
    let x2 = input[index]

    let r = x2 + x1

    return(r/2)
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

func _bincount(i :felt, input_len : felt, input : felt*, new_array : felt*, idx : felt) -> ():
    if i == 0:
        return()
    end
    let (count) = contain_count(idx, input_len, input)
    assert[new_array] = count
    return _bincount(i - 1, input_len, input, new_array + 1, idx + 1)
end

func _value_into_bins{range_check_ptr : felt}(bins_len : felt, bins : felt*, value : felt) -> (bins : felt):
    if bins_len == 0:
        return(0)
    end
    # review the value + 1, es for the condition is_le
    let (is_minor) = is_le(value + 1, [bins + bins_len - 1])
    if is_minor == 1:
        return _value_into_bins(bins_len - 1, bins, value)
    else:
        return (bins_len)
    end
end