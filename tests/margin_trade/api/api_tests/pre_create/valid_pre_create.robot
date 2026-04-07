*** Settings ***
Documentation                           The User gets confirmation for suggested parameters 
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test
Resource	                            pre_create.resource      
Library                                 DataDriver     valid.csv    encoding=UTF-8    handle_template_tags=DefaultTags

Test Template      Dry Run  

*** Test Cases ***
${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}  ${take_profit}

*** Keywords ***
Dry Run 
    [Arguments]        ${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}    ${take_profit}
    When the user chooses some parameters   ${market}        ${side}         ${collateral}      ${risk_coef}
    ...                                     ${open_price}    ${stop_loss}    ${take_profit}
    Then the user receives extend fee and liquidation price