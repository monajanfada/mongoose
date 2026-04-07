*** Settings ***
Documentation      The User gets confirmation for suggested parameters 
Resource	       open_position.resource   
Suite Setup        Set Suite Environment
Test Setup         Set Test Environment
Test Teardown      Clean Up Test   
Library            DataDriver     valid.csv    encoding=UTF-8    handle_template_tags=DefaultTags

Test Template      Open Position  

*** Test Cases ***
${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}  ${take_profit}

*** Keywords ***
Open Position 
    [Arguments]        ${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}    ${take_profit}
    When the user opens a position   ${market}        ${side}         ${collateral}      ${risk_coef}   
    ...                                     ${open_price}    ${stop_loss}    ${take_profit}   
    Then The position is opened