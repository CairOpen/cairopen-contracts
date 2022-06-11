%lang starknet

# @dev The maximum character length of a short string
const SHORT_STRING_MAX_LEN = 31

# @dev The maximum value for a short string of 31 characters (= 0b11...11 = 0xff...ff)
const SHORT_STRING_MAX_VALUE = 2 ** 248 - 1

# @dev Each character is encoded in ASCII so 8 bits
const CHAR_SIZE = 256

# @dev Mask to retreive the last character (= 0b00...0011111111 = 0x00...00ff)
const LAST_CHAR_MASK = CHAR_SIZE - 1

# @dev The maximum index for felt* in one direction given str[i] for i in [-2**15, 2**15)
const STRING_MAX_LEN = 2 ** 15
