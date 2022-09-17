// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./Ownable.sol";
import "./IFairDelivery.sol";

contract FairDelivery is Ownable, IFairDelivery{

    uint256 private constant MAX_INT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;

    mapping (address => uint256) private currentLabel;
    
    function sendNonRepudiationOfOriginFlag (string calldata h_name, HASH hash ) public returns (bool) {

        require(
            currentLabel[msg.sender] < MAX_INT,
            "ERRORE"
        );

        // emit 

        

        return true;
    }
}