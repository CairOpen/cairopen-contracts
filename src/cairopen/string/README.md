# CairOpen Starknet Libs - String

A library to store & manipulate strings in Cairo on StarkNet.

## String

### String type: `string`

The type `string` is a struct used to simplify the use of strings in Cairo. Further mentions of the type `string` will infer a value of this type.

Members

- `len (felt)`: The length of the string
- `data (felt*)`: The string as a char array

Import

```cairo
from cairopen.string.type import string
```

Declaration

```cairo
struct string:
  member len : felt
  member data : felt*
end
```

Usage example

```
from starkware.cairo.common.alloc import alloc

from cairopen.string.type import string

func hello{range_check_ptr}() -> (str : string):
  let len = 5
  let (str_data) = alloc()
  assert str_data[0] = 'H'
  assert str_data[1] = 'e'
  assert str_data[2] = 'l'
  assert str_data[3] = 'l'
  assert str_data[4] = 'o'

  return (string(len, str_data))
end

# str.len = 5
# str.data = ['H', 'e', 'l', 'l', 'o']
#
# str = "Hello" (can be considered as is)
```

# Namespace `String`

Every string utility function is accessible under the `String` namespace. They can also be called directly from their definition contract (see each doc for details).

Import

```cairo
from cairopen.string.string import String
```

## Storage

### Read: `String.read`

Reads a string from storage based on its ID.

Arguments

- `str_id (felt)`: The ID of the string to read

Implicit arguments

- `syscal_ptr (felt*)`
- `bitwise_ptr (BitwiseBuiltin*)`
- `pedersen_ptr (HashBuiltin*)`
- `range_check_ptr (felt)`

Returns

- `str (string)`: The string

Import

```cairo
from cairopen.string.string import String
# then String.read

# or
from cairopen.string.storage import storage_read
```

Usage example

```cairo

```

### Write: `String.write`

Writes a string in storage, using an ID to identify it.

Arguments

- `str_id (felt)`: The ID of the string to write
- `str (string)`: The string

Implicit arguments

- `syscal_ptr (felt*)`
- `pedersen_ptr (HashBuiltin*)`
- `range_check_ptr (felt)`

Import

```cairo
from cairopen.string.string import String
# then String.write

# or
from cairopen.string.storage import storage_write
```

Usage example

```cairo

```

### Write from char array: `String.write_from_char_arr`

Writes a string as a char array in storage, using an ID to identify it.

Arguments

- `str_id (felt)`: The ID of the string to write
- `str_len (felt)`: The length of the string
- `str_data (felt*)`: The string

Implicit arguments

- `syscal_ptr (felt*)`
- `pedersen_ptr (HashBuiltin*)`
- `range_check_ptr (felt)`

Import

```cairo
from cairopen.string.string import String
# then String.write_from_char_arr

# or
from cairopen.string.storage import storage_write_from_char_arr
```

Usage example

```cairo

```

### Delete: `String.delete`

Deletes a string from storage, using an ID to identify it.

Arguments

- `str_id (felt)`: The ID of the string to delete

Implicit arguments

- `syscal_ptr (felt*)`
- `pedersen_ptr (HashBuiltin*)`
- `range_check_ptr (felt)`

Import

```cairo
from cairopen.string.string import String
# then String.delete

# or
from cairopen.string.storage import storage_delete
```

Usage example

```cairo

```

## Conversion

### Stringify number: `String.felt_to_string`

Converts a felt to an ASCII string

e.g. 12345 -> string("12345")

Arguments

- `elem (felt)`: The felt value to convert

Implicit arguments

- `range_check_ptr (felt)`

Returns

- `str (string)`: The string

Import

```cairo
from cairopen.string.string import String
# then String.felt_to_string

# or
from cairopen.string.conversion import conversion_felt_to_string
```

Usage example

```cairo

```

### Short string to string: `String.ss_to_string`

Converts a short string to a string

e.g. 'Hello' -> string("Hello")

Arguments

- `ss (felt)`: The short string to convert

Implicit arguments

- `bitwise_ptr (BitwiseBuiltin*)`
- `range_check_ptr (felt)`

Returns

- `str (string)`: The string

Import

```cairo
from cairopen.string.string import String
# then String.ss_to_string

# or
from cairopen.string.conversion import conversion_ss_to_string
```

Usage example

```cairo

```

### Short string array to string: `String.ss_arr_to_string`

Converts an array of short strings to a string

e.g. ['Hello', 'World'] -> string("HelloWorld")

Arguments

- `ss_arr_len (felt)`: The length of the short string array
- `ss_arr (felt*)`: The short string array

Implicit arguments

- `bitwise_ptr (BitwiseBuiltin*)`
- `range_check_ptr (felt)`

Returns

- `str (string)`: The string

Import

```cairo
from cairopen.string.string import String
# then String.ss_arr_to_string

# or
from cairopen.string.conversion import conversion_ss_arr_to_string
```

Usage example

```cairo

```

## Manipulation

### Concatenate strings: `String.concat`

Appends two strings together

e.g. string("Hello") + string("World") = string("HelloWorld")

Arguments

- `str1 (string)`: The first string
- `str2 (string)`: The second string

Implicit arguments

- `range_check_ptr (felt)`

Returns

- `str (string)`: The concatenated string

Import

```cairo
from cairopen.string.string import String
# then String.concat

# or
from cairopen.string.manipulation import manipulation_concat
```

Usage example

```cairo

```

### Append char to string: `String.append_char`

Appends a character (represented as a single character short string) to a string

e.g. string("Hello") + '!' = string("Hello!")

Arguments

- `base (string)`: The base string
- `char (felt)`: The character to append

Implicit arguments

- `range_check_ptr (felt)`

Returns

- `str (string)`: The appended string

Import

```cairo
from cairopen.string.string import String
# then String.append_char

# or
from cairopen.string.manipulation import manipulation_append_char
```

Usage example

```cairo

```

### Join paths: `String.path_join`

Joins two paths together, adding a '/' in between if not already present at the end of the first string

e.g. string("Hello") + string("World") = string("Hello/World")
e.g. string("Hello/") + string("World") = string("Hello/World")

Arguments

- `path1 (string)`: The first path
- `path2 (string)`: The second path

Implicit arguments

- `range_check_ptr (felt)`

Returns

- `path (string)`: The full path

Import

```cairo
from cairopen.string.string import String
# then String.path_join

# or
from cairopen.string.manipulation import manipulation_path_join
```

Usage example

```cairo

```

### Extract last char from short string: `String.extract_last_char_from_ss`

Extracts the last character from a short string and returns the characters before as a short string

Manages felt up to 2\*\*248 - 1 (instead of unsigned*div_rem which is limited by rc_bound). \_On the down side it requires BitwiseBuiltin for the whole call chain*

Arguments

- `ss (felt)`: The short string

Implicit arguments

- `bitwise_ptr (BitwiseBuiltin*)`
- `range_check_ptr (felt)`

Returns

- `ss_rem (felt)`: The remaining short string
- `char (felt)`: The character

Import

```cairo
from cairopen.string.string import String
# then String.extract_last_char_from_ss

# or
from cairopen.string.manipulation import manipulation_extract_last_char_from_ss
```

Usage example

```cairo

```

## Constants

### SHORT_STRING_MAX_LEN

### SHORT_STRING_MAX_VALUE

### CHAR_SIZE

### LAST_CHAR_MASK

### STRING_MAX_LEN
