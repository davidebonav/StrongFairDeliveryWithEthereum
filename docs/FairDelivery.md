# FairDelivery documentation

======= contracts/FairDelivery.sol:FairDelivery =======

```json
{
    "author": "Davide Bonaventura",
    "details": "This Smart Contract allows you to obtain non-repudiation property for all messages exchanged using any service for the exchange of messages (like email, whatsapp, telegram, paper, ...).",
    "kind": "dev",
    "methods": {
        "constructor": {
            "details": "This is the constructor of the contract. The constructor invoke the constructor of the contracts which it extends by passing the appropriate parameters.",
            "params": {
                "minFee": "The minimum fee to start a new instance of the protocol."
            }
        },
        "destroy()": {
            "details": "Allows the owner to destroy the contract. All remaining Ether stored in the contract are sends to the owner."
        },
        "nonRepudiationOfOrigin(uint256,bytes32)": {
            "details": "This method allows the sender to publish the NRO evidence. The sender must pay for the contract in order to be able to execute the protocol.",
            "params": {
                "nonce_hash": "A hash that allows the contract to publish the next evidence only by the correct recipient. The input of the hash is a value that only the correct recipient know.",
                "nro": "The evidence to publish. "
            },
            "returns": {
                "label": "Returns the label associate with the protocol execution."
            }
        },
        "nonRepudiationOfReceipt(uint256,address,uint256,uint256)": {
            "details": "This method allows the recipient to communicate that they have received the message and want to obtain the key to decrypt it. It allows the recipient to publish the NRR evidence.",
            "params": {
                "label": "The label associate with the protocol execution.",
                "nonce": "The value that allow the recipient to publish the evidence.",
                "nrr": "The evidence to publish. ",
                "sender_address": "The address used from the sender to publish the previous evidence."
            }
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
        "submissionOfKey(uint256,uint256,uint256)": {
            "details": "This method allows the sender to publish the key that decrypts the message.",
            "params": {
                "con_k": "The evidence to publish. ",
                "key": "Symmetric key with which the message can be decrypted.",
                "label": "The label associate with the protocol execution."
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
        "MAX_INT": {
            "details": "This constant contain the value of the solidity MAX_INT. "
        },
        "currentProtocolState": {
            "details": "This mapping allows you to know the state of any protocol execution performed from any address. This mapping is private."
        },
        "getNextLabel": {
            "details": "Get the next label for a certain address. It allows any user to get the label that the contract will associate  with the next execution of a certain address.",
            "params": {
                "_addr": "The address from which to get the next label."
            },
            "return": "nextLabel The next label that will be associated to the next execution of the protocol of the _addr.",
            "returns": {
                "_0": "nextLabel The next label that will be associated to the next execution of the protocol of the _addr."
            }
        }
    },
    "title": "A Smart Contract for fair strong delivery",
    "version": 1
}
```