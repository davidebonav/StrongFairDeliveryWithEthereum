// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/**
 * @title An Interface  for fair strong delivery.
 * @author Davide Bonaventura
 * @notice This interface exposes all the methods, events and errors that a Smart Contract who wants to implement the non-repudiation protocol must have.
 */
interface IFairDelivery {
    // -- TYPES --
    type Nonce is uint256;
    type Signature is uint256;
    type SymmetricKey is uint256;
    type Ciphertext is uint256;

    // -- ENUMS --
    /** 
     * @notice Allowed state for any protocol instance.
     * @dev This enum contains all states allowed by the contract for any execution of the protocol.
     */
    enum MessageState {
        NULL_STATE,
        NRO,
        NRR,
        CON_K
    }

    // -- ERRORS --
    error NotEnoughLabels(address addr, string description);
    error InvalidMessageState(
        MessageState expectedState,
        MessageState currentState,
        string description
    );
    error UnauthorizedAddress(bytes32 expected, bytes32 current);
    error NotValidAddress();

    // -- EVENTS --
    /**
     * @notice Pubblication of the NRO sign by the sender.
     * @dev Publication of the non-repudiation of origin (NRO) sign by the sender.
     * @param label The label associated by the contract to the execution of the protocol carried out by the sender address.
     * @param sender_address The address with which the sender execute the protocol.
     * @param nro The NRO sign.
     */
    event NonRepudiationOfOrigin(
        uint256 indexed label,
        address indexed sender_address,
        Signature nro
    );

    /**
     * @notice Pubblication of the NRR sign by the recipient.
     * @dev By publishing the non-repudiation of receipt the recipient confirms that he has received the ciphertext correctly and wants to obtain the key.
     * @param label The label associated by the contract to the execution of the protocol carried out by the sender address.
     * @param sender_address The address with which the sender execute the protocol.
     * @param nrr The NRR sign.
     */
    event NonRepudiationOfReceipt(
        uint256 indexed label,
        address indexed sender_address,
        Signature nrr
    );

    /**
     * @notice Pubblication of the key and of the CON_K sign.
     * @dev This event allows the sender to publish the key. The key is published in plaintext. 
     * @param label The label associated by the contract to the execution of the protocol carried out by the sender address.
     * @param sender_address The address with which the sender execute the protocol.
     * @param key The key to decrypt the cryptotext.
     * @param con_k The CON_K sign.
     */
    event SubmissionOfKey(
        uint256 indexed label,
        address indexed sender_address,
        SymmetricKey key,
        Signature con_k
    );

    // -- FUNCTIONS --
    /**
     * @notice Get the next label for a certain address.
     * @dev It allows any user to get the label that the contract will associate with the next execution of a certain address.
     * @param _addr The address from which to get the next label.
     * @return nextLabel The next label that will be associated to the next execution of the protocol of the _addr.
     */
    function getNextLabel(address _addr) external returns (uint256);
 
    /**
     * @notice This method allows the sender to publish the non-repudiation of origin sign.
     * @dev The sender must pay for the contract in order to be able to execute the protocol.
     * @param nro The evidence to publish. 
     * @param nonce_hash A hash that allows the contract to publish the next evidence only by the correct recipient. The input of the hash is a value that only the correct recipient know.
     * @return label Returns the label associate with the protocol execution.
     */
    function nonRepudiationOfOrigin(Signature nro, bytes32 nonce_hash)
        external
        payable
        returns (uint256);

    /**
     * @notice This method allows the recipient to publish the non-repudiation of receipt sign.
     * @dev This method allows the recipient to communicate that they have received the message and want to obtain the key to decrypt it.
     * @param nrr The evidence to publish. 
     * @param sender_address The address used from the sender to publish the previous evidence.
     * @param label The label associate with the protocol execution.
     * @param nonce The value that allow the recipient to publish the evidence.
     */
    function nonRepudiationOfReceipt(
        Signature nrr,
        address sender_address,
        uint256 label,
        Nonce nonce
    ) external;

    /**
     * @notice This method allows the sender to publish the key that decrypts the message.
     * @param key Symmetric key with which the message can be decrypted.
     * @param con_k The evidence to publish. 
     * @param label The label associate with the protocol execution.
     */ 
    function submissionOfKey(
        SymmetricKey key,
        Signature con_k,
        uint256 label
    ) external;
}
