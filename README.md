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

## Usage

To use the librairy in contracts then

```cairo
# contracts/MyContract.cairo

%lang starknet

from cairopen.string.store import String_set, String_get, String_delete
```

## Local setup

We strongly suggest using a python virtual environment such as `virtualenv`

To create the envirnoment, run

```bash
pip install virtualenv
```

```bash
python -m virtualenv .venv
```

```bash
source .venv/bin/activate
```

Then install the libraries using

```bash
pip install -r requirements.txt
```

### Mac Cairo installation

The GMP lib is required to install `cairo-lang`. You can install it with

```bash
brew install gmp
```

Brew details [here](https://brew.sh/).

#### M1 issues

If you run into a `gmp.h` issue while trying to install `cairo-lang` on an M1 Mac, make sure you have the latest `pip version` with

```bash
pip install --upgrade pip
```

Then try running

```
CFLAGS=-I`brew --prefix gmp`/include LDFLAGS=-L`brew --prefix gmp`/lib pip install ecdsa fastecdsa sympy
```

### Makefile scripts

Unit tests: `make unittest`

Integration tests: `make test`

Build packages: `make build`
