# Payable documentation

======= contracts/Payable.sol:Payable =======
```json
{
    "details": "Contract module which provides a mechanism to make some methods of the contract payable. This contract is Ownable.",
    "events": {
        "Received(address,uint256)": {
            "details": "This event Notifies that the contract has received some currency. The value is in wei.",
            "params": {
                "from": "Address that have send the currency.",
                "value": "The amount of currency received."
            }
        }
    },
    "kind": "dev",
    "methods": {
        "constructor": {
            "details": "This is the constructor of the contract. Initializes the contract setting the minimum fee of the payable methods."
        },
        "owner()": {
            "details": "Returns the address of the current owner. This method is public, it can be invoked by anyone to know who is the owner of the contract.",
            "returns": {
                "_0": "address Return the address of the current contract owner."
            }
        },
        "payTo(address,uint256,bool)": {
            "details": "Allows the contract owner to pay a certain amount to a certain address. Only the owner of the contract can call this method. The balance must be less than the amount to be paid.",
            "params": {
                "amount": "The amount to be paid.",
                "flag": "This parameter must be set to true for the payment to be executed. If set to false the payment is cancelled.",
                "to": "The address to which to pay the amount"
            }
        },
        "payToOwner(uint256)": {
            "details": "Allows the contract to pay a certain amount to the owner. This metod call the payTo method with the to param equals to the owner. Therefore, only the owner of the contract can call this method. The method is external, cannot be invoked internally in the contract.",
            "params": {
                "amount": "The amount to be paid."
            }
        },
        "setMinimumFee(uint256)": {
            "details": "Allows to change the minimum fee required by the payable methods. Only the owner of the contract can call this method.",
            "params": {
                "newFee": "The new minimum fee."
            }
        },
        "transferOwnership(address)": {
            "details": "Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.",
            "params": {
                "newOwner": "Address of the new owner."
            }
        }
    },
    "stateVariables": {
        "minimumFee": {
            "details": "Return the value of the minimum fee. The value is returned in wei.",
            "return": "minimumFee Return the minimum fee",
            "returns": {
                "_0": "minimumFee Return the minimum fee"
            }
        }
    },
    "version": 1
}
```