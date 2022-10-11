// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Destructible.sol";
import "./IFairDelivery.sol";
import "./Payable.sol";

/**
 * @title A Smart Contract for fair strong delivery
 * @author Davide Bonaventura
 * @notice This Smart Contract allows you to obtain non-repudiation property for all messages exchanged using any service for the exchange of messages (like email, whatsapp, telegram, paper, ...).
 */
contract FairDelivery is Payable, Destructible, IFairDelivery {
    // -- Types --
    struct StateData {
        bytes32 nonce;
        MessageState state;
    }

    // -- Constant --
    /**
     * @dev This constant contain the value of the solidity MAX_INT. 
     */
    uint256 private constant MAX_INT = 2**256 - 1;
    
    // -- Attributes --
    /**
     * @inheritdoc IFairDelivery
     */
    mapping(address => uint256) public override getNextLabel;

    /**
     * @dev This mapping allows you to know the state of any protocol execution performed from any address. This mapping is private.
     */
    mapping(address => mapping(uint256 => StateData))
        private currentProtocolState;

    // -- Modifiers --
    /**
     * @notice Check if the caller address can execute the protocol another time.
     * @dev The number of times each address can execute the protocol is limited to MAX_INT.
     */
    modifier labelsAvailable {
        if (getNextLabel[_msgSender()] == MAX_INT)
            revert NotEnoughLabels(
                _msgSender(),
                "Maximum number of labels for this address reached, use a different one"
            );
        _;
    }

    /**
     * @notice Check if the expected state of the protocol matches its current state.
     * @dev Not all state changes are allowed.
     * @param expectedState The state in which the execution of the protocol should be in order for the change of status to be allowed.
     * @param currentState The current state of the execution of the protocol whose state you want to change is.
     */
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

    /**
     * @notice Check if the address that is trying to publish the NRR evidence for a certain protocol execution belongs to the recipient of the message.
     * @dev Only an address belonging to the recipient should be able to publish the NRR evidence.
     * @param sender_address .
     * @param nonce A number that only the correct recipient should know.
     * @param label .
     */
    modifier authorizedAddress(address sender_address, Nonce nonce, uint256 label) {
        bytes32 expectedHash = currentProtocolState[sender_address][label].nonce;
        bytes32 currentHash = keccak256(abi.encode(nonce));

        if (currentHash != expectedHash)
            revert UnauthorizedAddress(expectedHash, currentHash);
        _;
    }

    /**
     * @dev Check if the contract method was invoked from a valid address.
     */
    modifier validAddress {
        if(_msgSender() == address(0)){
            revert NotValidAddress();
        }
        _;
    }

    /**
     * @notice This is the constructor of the contract.
     * @dev The constructor invoke the constructor of the contracts which it extends by passing the appropriate parameters.
     * @param minFee The minimum fee to start a new instance of the protocol.
     */
    constructor(uint256 minFee) payable Payable(minFee) {

    }

    /// @inheritdoc IFairDelivery
    function nonRepudiationOfOrigin(Signature nro, bytes32 nonce)
        external
        payable
        override
        validAddress
        labelsAvailable
        checkMessageState(
            MessageState.NULL_STATE,
            currentProtocolState[msg.sender][getNextLabel[msg.sender]].state
        )
        enoughFee
        returns (uint256 label)
    {
        label = getNextLabel[msg.sender]++;
        currentProtocolState[msg.sender][label].state = MessageState.NRO;
        currentProtocolState[msg.sender][label].nonce = nonce;

        emit NonRepudiationOfOrigin(label, msg.sender, nro);
    }

    /// @inheritdoc IFairDelivery
    function nonRepudiationOfReceipt(
        Signature nrr,
        address sender_address,
        uint256 label,
        Nonce nonce
    )
        external
        override
        validAddress
        authorizedAddress(sender_address, nonce, label)
        checkMessageState(
            MessageState.NRO,
            currentProtocolState[sender_address][label].state
        )
    {
        currentProtocolState[sender_address][label].state = MessageState.NRR;
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
            currentProtocolState[msg.sender][getNextLabel[msg.sender]].state
        )
    {
        currentProtocolState[msg.sender][label].state = MessageState.CON_K;
        delete currentProtocolState[msg.sender][label].nonce;

        emit SubmissionOfKey(label, msg.sender, key, sub_k);
    }
}
