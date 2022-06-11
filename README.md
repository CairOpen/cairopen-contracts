# CairOpen Contracts

A set of libraries to help using Cairo on StarkNet.

Examples for use in other Cairo contracts are provided in [examples](examples).

## Contents

- [Installation](#installation)
- [Usage](#usage)
- [Libraries](#libraries)
  - [String](#string)
  - [Math](#math)
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

- [Type `string`](src/cairopen/string/README.md#type-string)
- [Namespace `String`](src/cairopen/string/README.md#namespace-string)
- [Storage](src/cairopen/string/README.md#storage)
  - [`String.read`](src/cairopen/string/README.md#stringread)
  - [`String.write`](src/cairopen/string/README.md#stringwrite)
  - [`String.write_from_char_arr`](src/cairopen/string/README.md#stringwrite_from_char_arr)
  - [`String.delete`](src/cairopen/string/README.md#stringdelete)
- [Conversion](src/cairopen/string/README.md#conversion)
  - [`String.felt_to_string`](src/cairopen/string/README.md#stringfelt_to_string)
  - [`String.ss_to_string`](src/cairopen/string/README.md#stringss_to_string)
  - [`String.ss_arr_to_string`](src/cairopen/string/README.md#stringss_arr_to_string)
- [Manipulation](src/cairopen/string/README.md#manipulation)
  - [`String.concat`](src/cairopen/string/README.md#stringconcat)
  - [`String.append_char`](src/cairopen/string/README.md#stringappend_char)
  - [`String.path_join`](src/cairopen/string/README.md#stringpath_join)
  - [`String.extract_last_char_from_ss`](src/cairopen/string/README.md#stringextract_last_char_from_ss)
- [Constants](src/cairopen/string/README.md#constants)
  - [SHORT_STRING_MAX_LEN](src/cairopen/string/README.md#short_string_max_len)
  - [SHORT_STRING_MAX_VALUE](src/cairopen/string/README.md#short_string_max_value)
  - [CHAR_SIZE](src/cairopen/string/README.md#char_size)
  - [LAST_CHAR_MASK](src/cairopen/string/README.md#last_char_mask)
  - [STRING_MAX_LEN](src/cairopen/string/README.md#string_max_len)

### Math

Mathematical utilities in Cairo. [Docs](src/cairopen/math/)

- [Array](src/cairopen/math/README.md#array)
  - [`concat_arr`](src/cairopen/math/README.md#concat_arr)
  - [`concat_felt_arr`](src/cairopen/math/README.md#concat_felt_arr)
  - [`invert_arr`](src/cairopen/math/README.md#invert_arr)
  - [`invert_felt_arr`](src/cairopen/math/README.md#invert_felt_arr)
  - [`assert_felt_arr_unique`](src/cairopen/math/README.md#assert_felt_arr_unique)

## Local setup

This project is built using [Protostar](https://docs.swmansion.com/protostar/)

### Makefile scripts

Tests: `make test`
