%lang starknet

from starkware.cairo.common.cairo_builtins import BitwiseBuiltin, HashBuiltin

from cairopen.string.store import String_get, String_set
from cairopen.string.string import String

#
# Getters
#

@view
func read{
    syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(stringId : felt) -> (str_len : felt, str : felt*):
    let (str) = String_get(stringId)
    return (str.len, str.data)
end

#
# Externals
#

@external
func write{
    syscall_ptr : felt*, bitwise_ptr : BitwiseBuiltin*, pedersen_ptr : HashBuiltin*, range_check_ptr
}(stringId : felt, str_len : felt, str : felt*):
    String_set(stringId, String(str_len, str))
    return ()
end
