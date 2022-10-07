// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Destructible.sol";
import "./IFairDelivery.sol";
import "./Payable.sol";

contract FairDelivery is Payable, Destructible, IFairDelivery {
    // -- Types --
    struct StateData {
        bytes32 proofToDo;
        MessageState state;
    }

    // -- Constant --
    uint256 private constant MAX_INT = 2**256 - 1;
    
    // -- Attributes --
    /// @inheritdoc IFairDelivery
    mapping(address => uint256) public override currentLabel;
    mapping(address => mapping(uint256 => StateData))
        private currentMessageState;

    // -- Modifiers --
    modifier labelsAvailable {
        if (currentLabel[msg.sender] == MAX_INT)
            revert NotEnoughLabels(
                msg.sender,
                "Maximum number of labels for this address reached, use a different one"
            );
        _;
    }

    modifier checkMessageState(
        MessageState expectedState,
        MessageState currentState
    ) {
        if (expectedState != currentState)
            revert InvalidMessageState(
                expectedState,
                currentState,
                "The current state is not the same as the expected state"
            );
        _;
    }

    modifier authorizedAddress(address sender_address, Hash proof, uint256 label) {
        bytes32 expectedHash = currentMessageState[sender_address][label].proofToDo;
        bytes32 currentHash = keccak256(abi.encode(proof));

        if (currentHash != expectedHash)
            revert UnauthorizedAddress(expectedHash, currentHash);
        _;
    }

    modifier validAddress {
        if(msg.sender == address(0)){
            revert NotValidAddress();
        }
        _;
    }

    constructor(uint256 minFee) payable Payable(minFee) {}

    /// @inheritdoc IFairDelivery
    function nonRepudiationOfOrigin(Signature nro, bytes32 proofToDo)
        external
        payable
        override
        validAddress
        labelsAvailable
        checkMessageState(
            MessageState.NULL_STATE,
            currentMessageState[msg.sender][currentLabel[msg.sender]].state
        )
        enoughFee
        returns (uint256 label)
    {
        label = currentLabel[msg.sender]++;
        currentMessageState[msg.sender][label].state = MessageState.NRO;
        currentMessageState[msg.sender][label].proofToDo = proofToDo;

        emit NonRepudiationOfOrigin(label, msg.sender, nro);
    }

    /// @inheritdoc IFairDelivery
    function nonRepudiationOfReceipt(
        Signature nrr,
        address sender_address,
        uint256 label,
        Hash proof
    )
        external
        override
        validAddress
        authorizedAddress(sender_address, proof, label)
        checkMessageState(
            MessageState.NRO,
            currentMessageState[sender_address][label].state
        )
    {
        currentMessageState[sender_address][label].state = MessageState.NRR;
        emit NonRepudiationOfReceipt(label, sender_address, nrr);
    }

    /// @inheritdoc IFairDelivery
    function submissionOfKey(
        SymmetricKey key,
        Signature sub_k,
        uint256 label
    )
        external
        override
        validAddress
        checkMessageState(
            MessageState.NRR,
            currentMessageState[msg.sender][currentLabel[msg.sender]].state
        )
    {
        currentMessageState[msg.sender][label].state = MessageState.CON_K;
        delete currentMessageState[msg.sender][label].proofToDo;

        emit SubmissionOfKey(label, msg.sender, key, sub_k);
    }
}
