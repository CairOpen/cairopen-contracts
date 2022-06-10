%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from cairopen.string.type import string
from cairopen.string.conversion import (
    conversion_felt_to_string,
    conversion_ss_to_string,
    conversion_ss_arr_to_string,
)
from cairopen.string.manipulation import (
    manipulation_append,
    manipulation_append_char,
    manipulation_path_join,
    manipulation_extract_last_char_from_ss,
)
from cairopen.string.storage import (
    storage_read,
    storage_write,
    storage_write_from_char_arr,
    storage_delete,
)

namespace String:
    #
    # Conversion
    #

    # @dev Converts a felt to its utf-8 string value
    # @implicit range_check_ptr (felt)
    # @param elem (felt): The felt value to convert
    # @return str (string): The string
    func felt_to_string{range_check_ptr}(elem : felt) -> (str : string):
        return conversion_felt_to_string(elem)
    end

    # @dev Converts a short string into a string
    # @implicit bitwise_ptr (BitwiseBuiltin*)
    # @implicit range_check_ptr (felt)
    # @param ss (felt): The short string to convert
    # @return str (string): The string
    func ss_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(ss : felt) -> (str : string):
        return conversion_ss_to_string(ss)
    end

    # @dev Converts an array of short strings into a single string
    # @implicit bitwise_ptr (BitwiseBuiltin*)
    # @implicit range_check_ptr (felt)
    # @param ss_arr_len (felt): The length of the array
    # @param ss_arr (felt*): The array of short strings to convert
    # @return str (string): The string
    func ss_arr_to_string{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(
        ss_arr_len : felt, ss_arr : felt*
    ) -> (str : string):
        return conversion_ss_arr_to_string(ss_arr_len, ss_arr)
    end

    #
    # Manipulation
    #

    # @dev Appends two strings together
    # @implicit range_check_ptr (felt)
    # @param base (string): The base string
    # @param str (string): The end string
    # @return str (string): The appended string
    func append{range_check_ptr}(base : string, str : string) -> (str : string):
        return manipulation_append(base, str)
    end

    # @dev Appends a **single** char as a short string to a string
    # @implicit range_check_ptr (felt)
    # @param base (string): The base string
    # @param char (felt): The character to append
    # @return str (string): The appended string
    func append_char{range_check_ptr}(base : string, char : felt) -> (str : string):
        return manipulation_append_char(base, char)
    end

    # @dev Joins to strings together and adding a '/' in between if needed
    # @implicit range_check_ptr (felt)
    # @param base (string): The path start
    # @param str (string): The path end
    # @return path (string): The full path
    func path_join{range_check_ptr}(base : string, str : string) -> (path : string):
        return manipulation_path_join(base, str)
    end

    # @dev Extracts the last character from a short string and returns the characters before as a short string
    # @dev Manages felt up to 2**248 - 1 (instead of unsigned_div_rem which is limited by rc_bound)
    # @dev _On the down side it requires BitwiseBuiltin for the whole call chain_
    # @implicit bitwise_ptr (BitwiseBuiltin*)
    # @implicit range_check_ptr (felt)
    # @param ss (felt): The short string
    # @return ss_rem (felt): All the characters before as a short string
    # @return char (felt): The last character
    func extract_last_char_from_ss{bitwise_ptr : BitwiseBuiltin*, range_check_ptr}(ss : felt) -> (
        ss_rem : felt, char : felt
    ):
        return manipulation_extract_last_char_from_ss(ss)
    end

    #
    # Storage
    #

    # @dev Reads a string from storage based on its ID
    # @implicit syscall_ptr (felt*)
    # @implicit bitwise_ptr (BitwiseBuiltin*)
    # @implicit pedersen_ptr (HashBuiltin*)
    # @implicit range_check_ptr (felt)
    # @param str_id (felt): The ID of the string to return
    # @return str (string): The string
    func read{
        syscall_ptr : felt*,
        bitwise_ptr : BitwiseBuiltin*,
        pedersen_ptr : HashBuiltin*,
        range_check_ptr,
    }(str_id : felt) -> (str : string):
        return storage_read(str_id)
    end

    # @dev Writes a string in storage based on its ID
    # @implicit syscall_ptr (felt*)
    # @implicit pedersen_ptr (HashBuiltin*)
    # @implicit range_check_ptr (felt)
    # @param str_id (felt): The ID of the string to store
    # @param str (string): The string
    func write{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        str_id : felt, str : string
    ):
        return storage_write(str_id, str)
    end

    # @dev Writes a string from a char array in storage based on its ID
    # @implicit syscall_ptr (felt*)
    # @implicit pedersen_ptr (HashBuiltin*)
    # @implicit range_check_ptr (felt)
    # @param str_id (felt): The ID of the string to store
    # @param str_len (felt): The length of the string
    # @param str_data (felt*): The string itself (in char array format)
    func write_from_char_arr{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(
        str_id : felt, str_len : felt, str_data : felt*
    ):
        return storage_write_from_char_arr(str_id, str_len, str_data)
    end

    # @dev Deletes a string in storage based on its ID
    # @implicit syscall_ptr (felt*)
    # @implicit pedersen_ptr (HashBuiltin*)
    # @implicit range_check_ptr (felt)
    # @param str_id (felt): The ID of the string to delete
    func delete{syscall_ptr : felt*, pedersen_ptr : HashBuiltin*, range_check_ptr}(str_id : felt):
        return storage_delete(str_id)
    end
end
