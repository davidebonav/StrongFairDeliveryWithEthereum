// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

/**
 * @dev Contract module which provides a mechanism to make some methods of the contract payable.
 * This contract is Ownable.
 */
contract Payable is Ownable {

    /**
     * @dev Return the value of the minimum fee.
     * The value is returned in wei.
     * @return minimumFee Return the minimum fee
     */
    uint256 public minimumFee;

    error NotEnoughFee(string description, uint256 minFee);
    error NotEnoughBalance(string description, uint256 currentBalance);

    /**
     * @dev This event Notifies that the contract has received some currency.
     * The value is in wei.
     * @param from Address that have send the currency.
     * @param value The amount of currency received.
     */
    event Received(address indexed from, uint value);

    /**
     * @dev Check if the method caller has sent enough currency.
     * Throws if the currency sent is less than the minimum fee.
     */
    modifier enoughFee {
        if(minimumFee < _msgValue())
            revert NotEnoughFee("The fee must be greater than or equal to the minimum", minimumFee);
        _;
    }

    /**
     * @dev Check if the contract has enough balance over a certain amount.
     * Throws if the amount requested is greater than the balance of the contract.
     * @param amount The amount to check.
     */
    modifier enoughBalance(uint256 amount) {
        if(amount > address(this).balance)
            revert NotEnoughFee("The amount must be less than or equal to the current balance", minimumFee);
        _;
    }

    /**
     * @dev This is the constructor of the contract.
     * Initializes the contract setting the minimum fee of the payable methods.
     */
    constructor(uint256 _minimumFee) {
        setMinimumFee(_minimumFee);
    }

    /**
     * @dev Allows to change the minimum fee required by the payable methods.
     * Only the owner of the contract can call this method.
     * @param newFee The new minimum fee.
     */
    function setMinimumFee(uint256 newFee) public onlyOwner {
        minimumFee = newFee;
    }

    /**
     * @dev Allows the contract owner to pay a certain amount to a certain address.
     * Only the owner of the contract can call this method. The balance must be less than the amount to be paid.
     * @param to The address to which to pay the amount
     * @param amount The amount to be paid.
     * @param flag This parameter must be set to true for the payment to be executed. If set to false the payment is cancelled.
     */
    function payTo(address to, uint256 amount, bool flag) public onlyOwner enoughBalance(amount) {
        assert(flag);
        payable(to).transfer(amount);
    }

    /**
     * @dev Allows the contract to pay a certain amount to the owner.
     * This metod call the payTo method with the to param equals to the owner. Therefore, only the owner of the contract can call this method. The method is external, cannot be invoked internally in the contract.
     * @param amount The amount to be paid.
     */
    function payToOwner(uint256 amount) external { 
        payTo(owner(), amount, true); 
    }

    receive() external payable {/* emit Received(msg.sender, msg.value); */}
    fallback() external payable {}
}