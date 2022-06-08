# CairOpen Starknet Libs - Math

A library to manage arrays.

## Array

### Concatenation: `concat_arr`

Concatenates two arrays together

Arguments

- `arr1_len : felt` : The first array's length
- `arr1 : (felt | struct)*` : The first array
- `arr2_len : felt` : The second array's length
- `arr2 : (felt | struct)*` : The second array
- `size : felt` : The size of the struct

Returns

- `res_len : felt` : The concatenated array's length ( `arr1_len + arr2_len` )
- `res : felt*` : The concatenated array (for structures see Usage example)

Import

```cairo
from cairopen.math.array import concat_arr
```

Declaration

```cairo
func concat_arr{range_check_ptr}(
  arr1_len : felt, arr1 : felt*, arr2_len : felt, arr2 : felt*, size : felt
) -> (res_len : felt, res : felt*):
end
```

Usage example

```cairo
struct Structure:
    member m1 : felt
    member m2 : felt
end

func example{range_check_ptr}() -> (res_len : felt, res : Structure*):
  alloc_locals

  const arr1_len = 2
  let (local arr1 : Structure*) = alloc()
  assert arr1[0] = Structure(m1=1, m2=2)
  assert arr1[1] = Structure(m1=3, m2=4)

  const arr2_len = 2
  let (local arr2 : Structure*) = alloc()
  assert arr2[0] = Structure(m1=5, m2=6)
  assert arr2[1] = Structure(m1=7, m2=8)

  let (res_len, felt_arr) = concat_arr(arr1_len, arr1, arr2_len, arr2, Structure.SIZE)
  let res = cast(felt_arr, Structure*) # Important for struct usage

  return (res_len, res)
end

# res_len = 4
# res = [
#   Structure(m1=1, m2=2),
#   Structure(m1=3, m2=4),
#   Structure(m1=5, m2=6),
#   Structure(m1=7, m2=8),
# ]
```

Required implicit arguments: `range_check_ptr`

### Felt-only concatenation: `concat_felt_arr`

Concatenates two **felt** arrays together (same as `concat_arr` but with the implicit size of 1)

Arguments

- `arr1_len : felt` : The first array's length
- `arr1 : (felt | struct)*` : The first array
- `arr2_len : felt` : The second array's length
- `arr2 : (felt | struct)*` : The second array

Returns

- `res_len : felt` : The concatenated array's length ( `arr1_len + arr2_len` )
- `res : felt*` : The concatenated array

Import

```cairo
from cairopen.math.array import concat_felt_arr
```

Declaration

```cairo
func concat_felt_arr{range_check_ptr}(
  arr1_len : felt, arr1 : felt*, arr2_len : felt, arr2 : felt*
) -> (res_len : felt, res : felt*):
end
```

Usage example

```cairo
func example{range_check_ptr}() -> (res_len : felt, res : felt*):
  alloc_locals

  const arr1_len = 2
  let (local arr1 : felt*) = alloc()
  assert arr1[0] = 1
  assert arr1[1] = 2

  const arr2_len = 2
  let (local arr2 : felt*) = alloc()
  assert arr2[0] = 3
  assert arr2[1] = 4

  let (res_len, felt_arr) = concat_arr(arr1_len, arr1, arr2_len, arr2)
  return (res_len, res)
end

# res_len = 4
# res = [1, 2, 3, 4]
```

Required implicit arguments: `range_check_ptr`

### Invertion: `invert_arr`

Inverts an array.

Import

```cairo
from cairopen.math.array import invert_arr
```

Declaration

```cairo
func invert_arr{range_check_ptr}(arr_len, arr) -> (res_len, res):
end
```

Usage

```cairo
func example{range_check_ptr}() -> (res_len : felt, res : felt*):
  arr_size = 3
  let (arr : felt*) = alloc()
  arr[0] = 1
  arr[1] = 2
  arr[2] = 3

  let (res_len, res) = invert_arr(arr_size, arr)
  return (res_len, res)
end

# res_len = 3
# res = [3, 2, 1]
```

Required implicit arguments: `range_check_ptr`

### Uniqueness: `check_arr_unique`

Checks if an array is only composed of unique elements.

⚠️ This function reverts if the array is not unique ⚠️

Import

```cairo
from cairopen.math.array import check_arr_unique
```

Declaration

```cairo
func check_arr_unique{range_check_ptr}(arr_len, arr):
end
```

Usage

```cairo
func example{range_check_ptr}():
  arr1_size = 3
  let (arr1 : felt*) = alloc()
  arr1[0] = 1
  arr1[1] = 2
  arr1[2] = 3
  check_arr_unique(arr1_size, arr1) # Success

  arr2_size = 3
  let (arr1 : felt*) = alloc()
  arr2[0] = 1
  arr2[1] = 2
  arr2[2] = 2
  check_arr_unique(arr2_size, arr2) # Reverts

  return ()
end
```

Required implicit arguments: `range_check_ptr`
