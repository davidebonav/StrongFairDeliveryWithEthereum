# Ownable documentation
======= contracts/Ownable.sol:Ownable =======
```json
{
    "details": "Contract module which provides a basic access control mechanism, where there is an account (an owner) that can be granted exclusive access to specific functions. By default, the owner account will be the one that deploys the contract. This can later be changed with {transferOwnership}. This module is used through inheritance. It will make available the modifier `onlyOwner`, which can be applied to your functions to restrict their use to the owner.",
    "events": {
        "OwnershipTransferred(address,address)": {
            "details": "This event is emitted when the contract owner transfers ownership to another address.",
            "params": {
                "newOwner": "Address of the new owner.",
                "previousOwner": "Address of the previous owner."
            }
        }
    },
    "kind": "dev",
    "methods": {
        "constructor": {
            "details": "Initializes the contract setting the deployer as the initial owner."
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