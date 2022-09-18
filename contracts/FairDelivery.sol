// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Ownable.sol";
import "./IFairDelivery.sol";

contract FairDelivery is Ownable, IFairDelivery{
    // -- Types --
    struct StateData {
        bytes32 proofToDo;
        EmailState state;
    }

    // -- Attributes --
    uint256 private constant MAX_INT = 2**256-1;

    mapping(address => uint256) public override currentLabel;
    mapping(address => mapping(uint256 => StateData) ) private currentEmailState;

    // -- Modifiers --
    modifier labelsAvailable(){
        if (currentLabel[msg.sender] == MAX_INT)
            revert NotEnoughLabels(
                msg.sender, 
                "Numero massi di etichette raggiunto, usa un address differente"
            );
        _;
    }

    modifier checkEmailState(EmailState expectedState, EmailState currentState) {
        if(expectedState != currentState)
            revert InvalidEmailState(
                expectedState,
                currentState,
                "The current state is not the same as the expected state"
            );
        _;
    }

    modifier validSendAddress(address sender_address) {
        if (msg.sender == sender_address)
            revert NotValidAddress("");
        _;
    }

    function nonRepudiationOfOrigin ( Signature nro, bytes32 proofToDo ) 
        external 
        override 
        labelsAvailable 
        checkEmailState(EmailState.NOT_USED, currentEmailState[msg.sender][currentLabel[msg.sender]].state)
        returns(uint256 label) 
    {
        label = currentLabel[msg.sender]++;
        currentEmailState[msg.sender][label].state = EmailState.NRO;
        currentEmailState[msg.sender][label].proofToDo = proofToDo;

        emit NonRepudiationOfOrigin( label, msg.sender, nro, block.timestamp);
    }

    function nonRepudiationOfReceipt ( Signature nrr, address sender_address, uint256 label, Hash proof ) 
        external 
        override 
        validSendAddress(sender_address)
        checkEmailState(EmailState.NRO, currentEmailState[sender_address][label].state)
    {
        bytes32 expectedHash = currentEmailState[sender_address][label].proofToDo;
        bytes32 currentHash = keccak256(abi.encode(proof));

        if ( currentHash != expectedHash)
            revert NotValidHash(expectedHash, currentHash);

        currentEmailState[sender_address][label].state = EmailState.NRR;
        emit NonRepudiationOfReceipt( label, sender_address, nrr, block.timestamp);
    }
    
    function submissionOfKey ( SymmetricKey key, Signature sub_k, uint256 label ) 
        external 
        override 
        checkEmailState(EmailState.NRR, currentEmailState[msg.sender][currentLabel[msg.sender]].state)

    {
        currentEmailState[msg.sender][label].state = EmailState.CON_K;
        delete currentEmailState[msg.sender][label].proofToDo;

        emit SubmissionOfKey( label, msg.sender, key, sub_k, block.timestamp );
    }

}