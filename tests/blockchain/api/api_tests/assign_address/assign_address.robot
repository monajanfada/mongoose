*** Settings ***
Documentation      A user assigns an address and check if the operation was successful.
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test
Resource	                            assign_address.resource      



*** Test Cases ***
Get All Markets
    [Tags]    api      markets
    When an address is assigned 
    Then the signature verification is successful