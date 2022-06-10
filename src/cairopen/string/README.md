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

```cairo
from starkware.cairo.common.alloc import alloc

from cairopen.string.type import string

func example{range_check_ptr}() -> (str : string):
  let str_len = 5
  let (str_data) = alloc()
  assert str_data[0] = 'H'
  assert str_data[1] = 'e'
  assert str_data[2] = 'l'
  assert str_data[3] = 'l'
  assert str_data[4] = 'o'

  return (string(str_len, str_data))
end

# str = "Hello"
#
# In reality:
#   str.len = 5
#   str.data = ['H', 'e', 'l', 'l', 'o']
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
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from cairopen.string.type import String

func example{
  syscall_ptr : felt*,
  bitwise_ptr : BitwiseBuiltin*,
  pedersen_ptr : HashBuiltin*,
  range_check_ptr,
}() -> (str : string):
  let (str) = String.read('my_string')
  return (str)
end
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
from starkware.cairo.common.cairo_builtins import HashBuiltin

from cairopen.string.type import String

func example{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
  let str_len = 5
  let (str_data) = alloc()
  assert str_data[0] = 'H'
  assert str_data[1] = 'e'
  assert str_data[2] = 'l'
  assert str_data[3] = 'l'
  assert str_data[4] = 'o'

  let str = string(str_len, str_data)
  String.write('my_string', str)

  return ()
end
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
from starkware.cairo.common.cairo_builtins import HashBuiltin

from cairopen.string.type import String

func example{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
  let str_len = 5
  let (str_data) = alloc()
  assert str_data[0] = 'H'
  assert str_data[1] = 'e'
  assert str_data[2] = 'l'
  assert str_data[3] = 'l'
  assert str_data[4] = 'o'

  String.write_from_char_arr('my_string', len, str_data)

  return ()
end
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
from starkware.cairo.common.cairo_builtins import HashBuiltin

from cairopen.string.type import String

func example{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}():
  String.delete('my_string')

  return ()
end
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
from cairopen.string.type import String

func example{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}() -> (str : string):
  let _felt = 12345

  let (str) = String.felt_to_str(_felt)

  return (str)
end

# str = "12345"
#
# In reality:
#   str.len = 5
#   str.data = ['1', '2', '3', '4', '5']
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
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from cairopen.string.type import String

func example{syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr}() -> (str : string):
  let ss = 'Hello'

  let (str) = String.ss_to_string(ss)

  return (str)
end

# str = "Hello"
#
# In reality:
#   str.len = 5
#   str.data = ['H', 'e', 'l', 'l', 'o']
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
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.alloc import alloc

from cairopen.string.type import String

func example{syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr}() -> (str : string):
  let ss_arr_len = 2
  let (ss_arr) = alloc()
  assert ss_arr[0] = 'Hello'
  assert ss_arr[1] = 'World'

  let (str) = String.ss_arr_to_string(ss_arr_len, ss_arr)

  return (str)
end

# str = "HelloWorld"
#
# In reality:
#   str.len = 10
#   str.data = ['H', 'e', 'l', 'l', 'o', 'W', 'o', 'r', 'l', 'd']
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
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from cairopen.string.type import String

func example{syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr}() -> (str : string):
  let (str1) = String.ss_to_string('Hello')
  let (str2) = String.ss_to_string('World')

  let (str) = String.concat(str1, str2)

  return (str)
end

# str = "HelloWorld"
#
# In reality:
#   str.len = 10
#   str.data = ['H', 'e', 'l', 'l', 'o', 'W', 'o', 'r', 'l', 'd']
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
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from cairopen.string.type import String

func example{syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr}() -> (str : string):
  let (base) = String.ss_to_string('Hello')
  let char = '!'

  let (str) = String.append_char(base, char)

  return (str)
end

# str = "Hello!"
#
# In reality:
#   str.len = 6
#   str.data = ['H', 'e', 'l', 'l', 'o', '!']
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
from cairopen.string.type import String

func example{syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr}() -> (path : string):
  let (path1) = String.ss_to_string('https://cairopen.org')
  let (path2) = String.ss_to_string('docs')

  let (path) = String.path_join(path1, path2)

  return (path)
end

# path = "https://cairopen.org/docs"
#
# In reality:
#   path.len = 23
#   path.data = ['h', 't', 't', 'p', 's', ':', '/', '/', 'c', 'a', 'i', 'r', 'o', 'p', 'e', 'n', '.', 'o', 'r', 'g', '/', 'd', 'o', 'c', 's']
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
from starkware.cairo.common.cairo_builtins import BitwiseBuiltin

from cairopen.string.type import String

func example{syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr}() -> (ss_rem : felt, char : felt):
  let (ss) = 'Hello!'

  let (ss_rem, char) = String.extract_last_char_from_ss(ss)

  return (ss_rem, char)
end

# ss_rem = "Hello"
# char = '!'
```

## Constants

### SHORT_STRING_MAX_LEN

### SHORT_STRING_MAX_VALUE

### CHAR_SIZE

### LAST_CHAR_MASK

### STRING_MAX_LEN
