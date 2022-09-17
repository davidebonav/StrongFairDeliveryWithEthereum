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
/*
    H qualsiasi funzione hash
    PROTOCOLLO1 : 
    A -> B : { "emailFrom" : "", "emailTo" : "", "encMsg" : "", "label" : "", "nonce" : "", "timestamp" : 0 }
    A -> emit ( H_name, H(emailFrom||nonce), H(emailTo||nonce), H(encMsg||nonce), label, A(msg.sender), timstamp )
    B -> emit ( H_name, H(emailFrom||nonce), H(emailTo||nonce), H(encMsg||nonce+1), label, pubK, A(msg.sender) )
    A -> emit ( H_name, H(emailFrom||nonce), H(emailTo||nonce), {key}_pubK, label )
*/

/*

    H qualsiasi funzione hash
    A decide una funzoine HASH, questa deve essere la stessa in tutti gli eventi

    label, A(msg.sender) deve essere univoco per ogni log

    PROTOCOLLO2 : 
    A -> B : { emailFrom, emailTo, encMsg, label, currentTimstamp0, H_name } 
    A -> emit ( H_name, H(emailFrom||emailTo||encMsg||currentTimstamp0||label), label, A(msg.sender), currentTimstamp1 )
    
    B -> emit ( H_name, H(emailFrom||emailTo||encMsg||currentTimstamp1||label), label, pubK, A(msg.sender), currentTimstamp )
    B -> A : { "non ripudio di ricezione emesso", label }

    A -> emit ( H_name, H(key||label), {key}_pubK, label, currentTimstamp )


*/



/*
    A -> B : { emailFrom, emailTo, encMsg, currentTimstamp0, ( label, A(msg.sender) ), H_name } 


    A -> emit ( 
        H_name, 
        indexed H(emailFrom||emailTo||encMsg||label), 
        kekkack ( H(emailFrom||emailTo||encMsg||label+1) )
        indexed ( label, A(msg.sender) ), 
        currentTimstamp1 
    )




    PROTOCOLLO2 : 
    A -> B : { emailFrom, emailTo, encMsg, currentTimstamp0, ( label, A(msg.sender) ), H_name } 
    A -> emit ( H_name, indexed H(emailFrom||emailTo||encMsg||currentTimstamp0), indexed ( label, A(msg.sender) ), currentTimstamp1 )
    
    B -> emit ( H_name, indexed H(emailFrom||emailTo||encMsg||currentTimstamp1), pubK, indexed ( label, A(msg.sender) ), currentTimstamp2 )
    B -> A : { "non ripudio di ricezione emesso", label }

    A -> emit ( H_name, H(key||label), {key}_pubK, indexed ( label, A(msg.sender) ), currentTimstamp )


*/