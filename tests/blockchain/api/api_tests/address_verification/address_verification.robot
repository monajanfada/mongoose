*** Settings ***
Documentation      check address validation for specific network
Resource	       address_verification.resource   
Suite Setup        Set Suite Environment
Test Setup         Set Test Environment
Test Teardown      Clean Up Test   
Library            DataDriver     valid.csv    encoding=UTF-8    handle_template_tags=DefaultTags

Test Template      Address Validation  

*** Test Cases ***
${network}   ${address} 

*** Keywords ***
Address Validation 
    [Arguments]       ${network}   ${address} 
    When an address is sent on a specific network    ${network}   ${address} 
    Then validation of address verification response is checked
