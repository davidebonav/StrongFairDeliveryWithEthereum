# IFairDelivery documentation

======= contracts/IFairDelivery.sol:IFairDelivery =======

```json
{
    "author": "Davide Bonaventura",
    "details": "This interface exposes all the methods, events and errors that a Smart Contract who wants to implement the non-repudiation protocol must have.",
    "events": {
        "NonRepudiationOfOrigin(uint256,address,uint256)": {
            "details": "This event is emitted when an NRO evidence is emitted in the blockchain logs by the contract. By publishing the NRO the recipient confirms that he has send the ciphertext.",
            "params": {
                "label": "The label associated by the contract to the execution of the protocol carried out by the sender address.",
                "nro": "The NRO evidence.",
                "sender_address": "The address with which the sender execute the protocol."
            }
        },
        "NonRepudiationOfReceipt(uint256,address,uint256)": {
            "details": "This event is emitted when an NRR evidence is emitted in the blockchain logs by the contract. By publishing the NRR the recipient confirms that he has received the ciphertext correctly and wants to obtain the key.",
            "params": {
                "label": "The label associated by the contract to the execution of the protocol carried out by the sender address.",
                "nrr": "The NRR evidence.",
                "sender_address": "The address with which the sender execute the protocol."
            }
        },
        "SubmissionOfKey(uint256,address,uint256,uint256)": {
            "details": "This event is emitted when an CON_K evidence is emitted in the blockchain logs by the contract. This event allows the sender to publish the key. The key is published in plaintext. ",
            "params": {
                "con_k": "The CON_K evidence.",
                "key": "The key to decrypt the cryptotext.",
                "label": "The label associated by the contract to the execution of the protocol carried out by the sender address.",
                "sender_address": "The address with which the sender execute the protocol."
            }
        }
    },
    "kind": "dev",
    "methods": {
        "getNextLabel(address)": {
            "details": "Get the next label for a certain address. It allows any user to get the label that the contract will associate  with the next execution of a certain address.",
            "params": {
                "_addr": "The address from which to get the next label."
            },
            "returns": {
                "_0": "nextLabel The next label that will be associated to the next execution of the protocol of the _addr."
            }
        },
        "nonRepudiationOfOrigin(uint256,bytes32)": {
            "details": "This method allows the sender to publish the NRO evidence. The sender must pay for the contract in order to be able to execute the protocol.",
            "params": {
                "nonce_hash": "A hash that allows the contract to publish the next evidence only by the correct recipient. The input of the hash is a value that only the correct recipient know.",
                "nro": "The evidence to publish. "
            },
            "returns": {
                "_0": "label Returns the label associate with the protocol execution."
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
        "submissionOfKey(uint256,uint256,uint256)": {
            "details": "This method allows the sender to publish the key that decrypts the message.",
            "params": {
                "con_k": "The evidence to publish. ",
                "key": "Symmetric key with which the message can be decrypted.",
                "label": "The label associate with the protocol execution."
            }
        }
    },
    "title": "An Interface  for fair strong delivery.",
    "version": 1
}
```