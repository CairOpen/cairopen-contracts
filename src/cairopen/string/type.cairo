%lang starknet

# @dev A struct to represent strings
# @member len (felt): The length of the string
# @member data (felt*): The string as a char array
struct string:
    member len : felt
    member data : felt*
end
