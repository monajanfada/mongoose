*** Settings ***
Documentation      Get assigned address for Etherium coin
Resource	       EVM_signer.resource  
Suite Setup        Set Suite Environment
Test Setup         Set Test Environment
Test Teardown      Clean Up Test   


*** Test Cases ***
Sign Etherium Transaction
    When Sending Transaction Information for Etherium 
    Then the made service is signed and the signature is returned 
