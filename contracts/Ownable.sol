// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol

pragma solidity ^0.8.0;

abstract contract Ownable {

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public owner;

    constructor() {
        _transferOwnership(msg.sender);
    }

    // ** MODIFIERS **
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    // ** INTERNAL FUNCTIONS **
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = owner;
        owner = payable(newOwner);
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    function _checkOwner() internal view virtual {
        require(owner == msg.sender, "Ownable: caller is not the owner");
    }

    // ** PUBLIC FUNCTIONS **
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
}