// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

contract Payable is Ownable {

    uint256 public minimumFee;

    error NotEnoughFee(string description, uint256 minFee);
    error NotEnoughBalance(string description, uint256 currentBalance);
    event Received(address indexed from, uint value);

    modifier enoughFee {
        if(minimumFee < msg.value)
            revert NotEnoughFee("The fee must be greater than or equal to the minimum", minimumFee);
        _;
    }

    modifier enoughBalance(uint256 amount) {
        if(amount > address(this).balance)
            revert NotEnoughFee("The amount must be less than or equal to the current balance", minimumFee);
        _;
    }

    constructor(uint256 _minimumFee) {
        setMinimumFee(_minimumFee);
    }

    function setMinimumFee(uint256 newFee) public onlyOwner {
        minimumFee = newFee;
    }

    function payTo(address to, uint256 amount, bool flag) public onlyOwner enoughBalance(amount) {
        assert(flag);
        payable(to).transfer(amount);
    }

    function payToOwner(uint256 amount) external { 
        payTo(owner, amount, true); 
    }

    receive() external payable {/* emit Received(msg.sender, msg.value); */}
    fallback() external payable {}
}