# CairOpen Starknet Libs

A set of libraries to help using Cairo on StarkNet.

Examples for use in other Cairo contracts are provided in [examples](examples).

## Contents

- [Installation](#installation)
- [Libraries](#libraries)
  - [String](#string)
  - [Math](#math)
- [Usage](#usage)
- [Local setup](#local-setup)

## Installation

### Protostar

```bash
protostar install CairOpen/cairo-contracts
```

### Python

To install the library run

```bash
pip install cairopen-cairo
```

## Libraries

### String

String utilities to store and manipulation strings in Cairo. [Docs](src/cairopen/string/)

- [String](src/cairopen/string/README.md#string)
  - [String type](src/cairopen/string/README.md#string-type-string)
- [Storage](src/cairopen/string/README.md#storage)
  - [Write](src/cairopen/string/README.md#write-string_write)
  - [Write from char array](src/cairopen/string/README.md#write-from-char-array-string_write_from_char_arr)
  - [Read](src/cairopen/string/README.md#read-string_read)
  - [Delete](src/cairopen/string/README.md#delete-string_delete)
- [Conversion](src/cairopen/string/README.md#conversion)
  - [Stringify number](src/cairopen/string/README.md#stringify-number-string_felt_to_string)
  - [Short string to string](src/cairopen/string/README.md#short-string-to-string-string_ss_to_string)
  - [Short string array to string](src/cairopen/string/README.md#short-string-array-to-string-string_ss_arr_to_string)
- [Manipulation](src/cairopen/string/README.md#manipulation)
  - [Append strings](src/cairopen/string/README.md#append-strings-string_append)
  - [Append char to string](src/cairopen/string/README.md#append-char-to-string-string_append_char)
  - [Join paths](src/cairopen/string/README.md#join-paths-string_path_join)
  - [Extract last char from short string](src/cairopen/string/README.md#extract-last-char-from-short-string-string_extract_last_char_from_ss)
- [Constants](src/cairopen/string/README.md#constants)
  - [SHORT_STRING_MAX_LEN](src/cairopen/string/README.md#short_string_max_len)
  - [SHORT_STRING_MAX_VALUE](src/cairopen/string/README.md#short_string_max_value)
  - [CHAR_SIZE](src/cairopen/string/README.md#char_size)
  - [LAST_CHAR_MASK](src/cairopen/string/README.md#last_char_mask)
  - [STRING_MAX_LEN](src/cairopen/string/README.md#string_max_len)

### Math

Mathematical utilities in Cairo. [Docs](src/cairopen/math/)

- [Array](src/cairopen/math/README.md#array)
  - [concat_arr](src/cairopen/math/README.md#concatenation-concat_arr)
  - [concat_felt_arr](src/cairopen/math/README.md#felt-only-concatenation-concat_felt_arr)
  - [invert_arr](src/cairopen/math/README.md#inversion-invert_arr)
  - [invert_felt_arr](src/cairopen/math/README.md#felt-only-inversion-invert_felt_arr)
  - [assert_felt_arr_unique](src/cairopen/math/README.md#uniqueness-assert_felt_arr_unique)

## Usage

To use the librairy in contracts then

```cairo
# contracts/MyContract.cairo

%lang starknet

from cairopen.string.storage import String_set, String_get, String_delete
```

## Local setup

This project is built using [Protostar](https://docs.swmansion.com/protostar/)

### Makefile scripts

Tests: `make test`
