# CairOpen Contracts

A set of libraries to help using Cairo on StarkNet.

Examples for use in other Cairo contracts are provided in [examples](examples).

## Contents

- [Installation](#installation)
- [Usage](#usage)
- [Libraries](#libraries)
  - [String](#string)
  - [Math](#math)
  - [Binary](#binary)
  - [Hash](#hash)
- [Local setup](#local-setup)

## Installation

### Protostar

```bash
protostar install CairOpen/cairo-contracts
```

### Python

```diff
! Coming soon
```

## Usage

To use the librairy in contracts then

```cairo
# contracts/MyContract.cairo

%lang starknet

from cairopen.string.string import String
from cairopen.string.type import string
```

## Libraries

### String

String utilities to store and manipulation strings in Cairo. [Docs](src/cairopen/string/)

- [Type `String`](src/cairopen/string/README.md#type-string)
- [](src/cairopen/string/README.md#codecs)
- [Codecs & Namespace `StringCodec`](src/cairopen/string/README.md#codecs-&-namespace-stringcodec)
  - [Storage](src/cairopen/string/README.md#storage)
    - [`StringCodec.read`](src/cairopen/string/README.md#stringcodecread)
    - [`StringCodec.write`](src/cairopen/string/README.md#stringcodecwrite)
    - [`StringCodec.write_from_char_arr`](src/cairopen/string/README.md#stringcodecwrite_from_char_arr)
    - [`StringCodec.delete`](src/cairopen/string/README.md#stringcodecdelete)
  - [Conversion](src/cairopen/string/README.md#conversion)
    - [`StringCodec.felt_to_string`](src/cairopen/string/README.md#stringcodecfelt_to_string)
    - [`StringCodec.ss_to_string`](src/cairopen/string/README.md#stringcodecss_to_string)
    - [`StringCodec.ss_arr_to_string`](src/cairopen/string/README.md#stringcodecss_arr_to_string)
    - [`StringCodec.extract_last_char_from_ss`](src/cairopen/string/README.md#stringcodecextract_last_char_from_ss)
    - [`StringCodec.assert_char_encoding`](src/cairopen/string/README.md#stringcodecassert_char_encoding)
  - [Codec constants](src/cairopen/string/README.md#codec-constants)
    - [`StringCodec.CHAR_SIZE`](src/cairopen/string/README.md#stringcodecchar_size)
    - [`StringCodec.LAST_CHAR_MASK`](src/cairopen/string/README.md#stringcodeclast_char_mask)
    - [`StringCodec.NUMERICAL_OFFSET`](src/cairopen/string/README.md#stringcodecnumerical_offset)
- [Namespace `StringUtil`](src/cairopen/string/README.md#namespace-stringutil)
  - [Manipulation](src/cairopen/string/README.md#manipulation)
    - [`StringUtil.concat`](src/cairopen/string/README.md#stringutilconcat)
    - [`StringUtil.append_char`](src/cairopen/string/README.md#stringutilappend_char)
    - [`StringUtil.path_join`](src/cairopen/string/README.md#stringutilpath_join)
- [Common constants](src/cairopen/string/README.md#common-constants)
  - [`SHORT_STRING_MAX_LEN`](src/cairopen/string/README.md#short_string_max_len)
  - [`SHORT_STRING_MAX_VALUE`](src/cairopen/string/README.md#short_string_max_value)
  - [`STRING_MAX_LEN`](src/cairopen/string/README.md#string_max_len)

### Math

Mathematical utilities in Cairo. [Docs](src/cairopen/math/)

- [Array](src/cairopen/math/README.md#array)
  - [`concat_arr`](src/cairopen/math/README.md#concat_arr)
  - [`concat_felt_arr`](src/cairopen/math/README.md#concat_felt_arr)
  - [`invert_arr`](src/cairopen/math/README.md#invert_arr)
  - [`invert_felt_arr`](src/cairopen/math/README.md#invert_felt_arr)
  - [`assert_felt_arr_unique`](src/cairopen/math/README.md#assert_felt_arr_unique)


### Binary

Binary utilities in Cairo. [Docs](src/cairopen/binary/)

- [Bits](src/cairopen/binary/README.md#Bits)
  - [`Bits.extract`](src/cairopen/binary/README.md#Bits.extract)
  - [`Bits.merge`](src/cairopen/binary/README.md#Bits.merge)
  - [`Bits.rightshift`](src/cairopen/binary/README.md#Bits.rightshift)
  - [`Bits.leftshift`](src/cairopen/binary/README.md#Bits.leftshift)
  - [`Bits.rightrotate`](src/cairopen/binary/README.md#Bits.rightrotate)
  - [`Bits.negate`](src/cairopen/binary/README.md#Bits.negate)


### Hash

Hashing utilities in Cairo. [Docs](src/cairopen/hash/)

- [hash](src/cairopen/hash/README.md)
  - [`sha256`](src/cairopen/hash/README.md#sha256)


## Local setup

This project is built using [Protostar](https://docs.swmansion.com/protostar/)

### Makefile scripts

Tests: `make test`
