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

### Math

Mathematical utilities in Cairo. [Docs](src/cairopen/math/)

- [concat_arr](src/cairopen/math/README.md#concatenation-concat_arr)
- [concat_felt_arr](src/cairopen/math/README.md#felt-only-concatenation-concat_felt_arr)
- [invert_arr](src/cairopen/math/README.md#inversion-invert_arr)
- [invert_felt_arr](src/cairopen/math/README.md#felt-only-inversion-invert_arr)
- [check_arr_unique](src/cairopen/math/README.md#uniqueness-check_arr_unique)

## Usage

To use the librairy in contracts then

```cairo
# contracts/MyContract.cairo

%lang starknet

from cairopen.string.store import String_set, String_get, String_delete
```

## Local setup

This project is built using [Protostar](https://docs.swmansion.com/protostar/)

### Makefile scripts

Tests: `make test`
