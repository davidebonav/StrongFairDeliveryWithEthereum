# Destructible documentation

======= contracts/Destructible.sol:Destructible =======

```json
{
    "details": "Contract module which provides a mechanism to destroy the contract. This contract is Ownable.",
    "kind": "dev",
    "methods": {
        "destroy()": {
            "details": "Allows the owner to destroy the contract. All remaining Ether stored in the contract are sends to the owner."
        },
        "owner()": {
            "details": "Returns the address of the current owner. This method is public, it can be invoked by anyone to know who is the owner of the contract.",
            "returns": {
                "_0": "address Return the address of the current contract owner."
            }
        },
        "transferOwnership(address)": {
            "details": "Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.",
            "params": {
                "newOwner": "Address of the new owner."
            }
        }
    },
    "version": 1
}
```