// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

contract Destructible is Ownable {
    function destroy() public onlyOwner { 
        selfdestruct(payable(owner)); 
    }
}