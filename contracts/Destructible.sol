// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

/**
 * @notice Contract module which provides a mechanism to destroy the contract.
 * @dev This contract is Ownable.
 */
contract Destructible is Ownable {

    /**
     * @notice Notify the transfer of ownership of the contract.
     * @dev This event is emitted when the contract owner transfers ownership to another address. All remaining Ether stored in the contract are sends to the owner.
     */
    function destroy() public onlyOwner { 
        selfdestruct(payable(owner())); 
    }
}