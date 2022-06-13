## Simple Summary

A standard `struct` representing strings for consistent usage between contracts & standardization of string interfacing with Dapps.

## Abstract

The use of strings longer than 31 characters is required for many applications, mostly NFTs, as storing URIs and/or IPFS hashes most often require long strings. Of course, appending several short strings (31 character strings) would allow for longer strings but on-chain usage becomes extremely difficult and inefficient.

This proposal aims at standardizing the `string` struct in the same way `uint256` has been redefined.

In memory (while using the contracts), strings are represented as character arrays. In storage, they are stored as short strings to optimise memory cell space.

## Specification

The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD NOT”, “RECOMMENDED”, “MAY”,

and “OPTIONAL” in this document are to be interpreted as described in RFC-2119.

### `string` struct

This struct is designed to store strings in memory while executing contracts. It stores the string's length (`string.len`) as well as a `felt` pointer representing the string's content as a single-character array (`string.data`) e.g. "Hello" would be represented as `string.len = 5` and `string.data = [0x48, 0x65, 0x6c, 0x6c, 0x6f]` or `string.data = ['H', 'e', 'l', 'l', 'o']`.

```cairo
struct string:
  member len : felt
  member data : felt*
end
```

### String storage

Most projects will need to be able to store and edit several strings. Using a single storage variable for each string would be impossible, hence using a key-string storage system would be a better choice, where each string is stored and accessed using a unique `string_id`.

Using character arrays in memory makes it easy to use strings but storing them as such is highly inefficient. To store strings, they SHOULD be stored as an array of short strings.

Two storage variables are then needed:

- `string_ss_len(string_id : felt) -> (ss_len : felt)`: The number of short strings used for the whole string.
- `strings_data(string_id : felt, index : felt) -> (ss : felt)`: Each part of the string, indexed from 0 to `ss_len`-1.

### In-contract string usage

Every function using strings as arguments MUST expect a `string` struct.

Every function returning a string for use in-contract MUST return a `string` struct.

### External contract interaction

As short strings are encoding strings in ASCII, it is RECOMMENDED to use ASCII encoding for strings. And specify the encoding used otherwise.

Sending and receiving strings from contracts in Dapps will follow the same principle as the `string` struct.

Strings MUST be returned as arrays of single characters and functions MUST expect arrays of single characters.

### String usage

Here are short examples of interacting with strings in Dapps:

Return a string from a contract:

```cairo
%lang starknet

from starkware.cairo.common.alloc import alloc

@view
func send_hello{syscall_ptr : felt*}() -> (str_len : felt, str : felt*):
  let str_len = 5
  let (str) = alloc()
  assert str[0] = 'H'
  assert str[1] = 'e'
  assert str[2] = 'l'
  assert str[3] = 'l'
  assert str[4] = 'o'

  return (str_len, str)
end
```

```python
from cairopen.utils import felt_arr_to_str

async def receive():
  execution_info = await string_contract.send_hello().call()
  hello = execution_info.result.str

  print(len(hello))
  print(hello)
  print(felt_arr_to_str(hello))

# Prints:
# 5
# [ 72, 101, 108, 108, 111 ] or [ 0x48, 0x65, 0x6c, 0x6c, 0x6f ]
# Hello
```

Send a string to a contract and write it in storage:

```python
from cairopen.utils import str_to_felt_arr

async def send_hello():
  hello = str_to_felt_arr("Hello")
  print(len(hello))
  print(hello)

  await string_contract.receive(str_to_felt_arr("Hello")).invoke()

# Prints:
# 5
# [ 72, 101, 108, 108, 111 ] or [ 0x48, 0x65, 0x6c, 0x6c, 0x6f ]
```

```cairo
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin

from cairopen.string.string import String
from cairopen.string.type import string

@external
func write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(str_len : felt, str : felt*):
  let _str = string(str_len, str)

  String.write('hello', _str) # To use the string later on, use String.read('hello')

  return ()
end
```

Read a string from storage:

```cairo
%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin, BitwiseBuiltin

from cairopen.string.string import String

@view
func read{
    syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, bitwise_ptr : BitwiseBuiltin*, range_check_ptr
}() -> (str_len : felt, str : felt*):
  let (str) = String.read('hello')
  return (str.len, str.data)
end
```

```python
from cairopen.utils import felt_arr_to_str

async def read():
  execution_info = await string_contract.read().call()
  hello = execution_info.result.str

  print(len(hello))
  print(hello)
  print(felt_arr_to_str(hello))

# Prints:
# 5
# [ 72, 101, 108, 108, 111 ] or [ 0x48, 0x65, 0x6c, 0x6c, 0x6f ]
# Hello
```

We developped and documented a full Cairo library for string storage and usage, available for review here: https://github.com/CairOpen/cairopen-contracts/tree/main/src/cairopen/string
