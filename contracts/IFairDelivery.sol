// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IFairDelivery {
    // -- TYPES --
    type Hash is uint256;
    type Signature is uint256;
    type SymmetricKey is uint256;
    type Ciphertext is uint256;

    // -- ENUMS --
    enum EmailState{ NOT_USED, NRO, NRR, CON_K }

    // -- ERRORS --
    error NotEnoughLabels (address addr, string description);
    error InvalidEmailState (EmailState expectedState, EmailState currentState, string description);
    error NotValidAddress (string description);
    error NotValidHash (bytes32 expected, bytes32 current);

    // -- EVENTS --
    event NonRepudiationOfOrigin (uint256 indexed label, address indexed sender_address, Signature nro, uint256 currentTimestamp);
    event NonRepudiationOfReceipt (uint256 indexed label, address indexed sender_address, Signature nrr, uint256 currentTimestamp);
    event SubmissionOfKey (uint256 indexed label, address indexed sender_address, SymmetricKey key, Signature sub_k, uint256 currentTimestamp);
    // event ConfirmationOfKey ( );

    // -- FUNCTIONS --
    function currentLabel (address) external returns(uint256);
    function nonRepudiationOfOrigin (Signature, bytes32) external returns(uint256 label);
    function nonRepudiationOfReceipt (Signature, address, uint256, Hash) external;
    function submissionOfKey (SymmetricKey, Signature, uint256) external;

}
