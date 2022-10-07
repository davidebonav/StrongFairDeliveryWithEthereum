// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IFairDelivery {
    /**
     * @title A Smart Contract for fair strong delivery
     * @author Davide Bonaventura
     * @notice This Smart Contract allows you to obtain non-repudiation property for all messages exchanged using any asynchronous messaging service
     */

    // -- TYPES --
    type Hash is uint256;
    type Signature is uint256;
    type SymmetricKey is uint256;
    type Ciphertext is uint256;

    // -- ENUMS --
    /// @notice Questo enum contiene tutti gli stati ammessi dallo Smart Contract per un qualunque messaggio
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
    /// @notice This event is placed whenever the sender intends to provide the recipient with evidence of the authenticity of the message received
    event NonRepudiationOfOrigin(
        uint256 indexed label,
        address indexed sender_address,
        Signature nro
    );

    /// @notice This event is placed every time the recipient wants to confirm that they have received the cryptotext and want to proceed to obtain the key to decrypt it
    event NonRepudiationOfReceipt(
        uint256 indexed label,
        address indexed sender_address,
        Signature nrr
    );

    /// @notice This event is set whenever the sender wants to send the key to the recipient to decrypt the message
    event SubmissionOfKey(
        uint256 indexed label,
        address indexed sender_address,
        SymmetricKey key,
        Signature sub_k
    );

    // -- FUNCTIONS --
    /// @notice This method allows you to get the next label for any address
    /// @param _addr address of which you want to get the next label
    /// @return Next label
    function currentLabel(address _addr) external returns (uint256);

    /// @notice This method allows the sender to publish the non-repudiation of origin flag relative to a message
    /// @param nro the evidence to publish
    /// @param proofToDo a value that only the correct recipient can calculate
    /// @return Returns the label to which the evidence was associated
    function nonRepudiationOfOrigin(Signature nro, bytes32 proofToDo)
        external
        payable
        returns (uint256);

    /// @notice This method allows the recipient to communicate that they have received the message and want to obtain the key to decrypt it
    /// @param nrr the evidence to publish
    /// @param sender_address the address from which the previous evidence was published
    /// @param label the label with which the evidence relating to the message in question is associated
    /// @param proof a hash that allows you to prove that you are the real recipient of the message
    function nonRepudiationOfReceipt(
        Signature nrr,
        address sender_address,
        uint256 label,
        Hash proof
    ) external;

    /// @notice This method allows the recipient to publish the key that decrypts the message
    /// @param key symmetric key with which the message can be decrypted
    /// @param sub_k evidence that guarantees that the published key is the correct one
    /// @param label the label that allows you to identify the message to which the evidence and the key refer
    function submissionOfKey(
        SymmetricKey key,
        Signature sub_k,
        uint256 label
    ) external;
}
