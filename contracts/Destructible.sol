// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

/**
 * @dev Contract module which provides a mechanism to destroy the contract.
 * This contract is Ownable.
 */
contract Destructible is Ownable {

    /**
     * @dev Allows the owner to destroy the contract.
     * All remaining Ether stored in the contract are sends to the owner.
     */
    function destroy() public onlyOwner { 
        selfdestruct(payable(owner())); 
    }
}