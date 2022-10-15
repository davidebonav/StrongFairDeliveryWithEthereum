// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner.
 */
abstract contract Context {
    /**
     * @dev Return the address of the message sender
     * @return senderAddress Address of the message sender.
     */
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    /**
     * @dev Return the data sendend by the message sender.
     * @return dataSended Data sended.
     */
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    /**
     * @dev Return the value sendend by the message sender.
     * @return valueSended Value sended.
     */
    function _msgValue() internal view virtual returns (uint) {
        return msg.value;
    }
}