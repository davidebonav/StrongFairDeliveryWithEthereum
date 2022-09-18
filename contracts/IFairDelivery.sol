// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract IFairDelivery {
    // ** TYPES **
    type HASH is uint256;

    // ** EVENTS **

    event NonRepudiationOfOrigin (
        address indexed transactionSigner, 
        HASH emailFrom, HASH emailTo, 
        uint indexed label, 
        HASH indexed encMsg
    );
    
    event NonRepudiationOfReceipt (
        address indexed transactionSigner, 
        HASH emailFrom, 
        HASH emailTo, 
        uint indexed label, 
        HASH indexed encMsg
    );
    
    event SubmissionOfKey (
        address indexed transactionSigner, 
        HASH emailFrom, 
        HASH emailTo, 
        uint indexed label, 
        HASH indexed encKey
    );
    
    event ConfirmationOfKey (
        address indexed transactionSigner, 
        HASH emailFrom, 
        HASH emailTo, 
        uint indexed label, 
        HASH indexed encKey
    );

    // ** FUNCTIONS **

}
