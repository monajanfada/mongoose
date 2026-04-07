*** Settings ***
Documentation      The user sets the risk coefficient to the correct value and should see the appropriate minimum and maximum collateral amounts 
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test
Resource	       risk_coefficient.resource      
Library            DataDriver     valid.csv    encoding=UTF-8    handle_template_tags=DefaultTags

Test Template      Risk Coefficient 

*** Test Cases ***
${market}       ${side}    ${risk_coef}

*** Keywords ***
Risk Coefficient 
    [Arguments]        ${market}       ${side}    ${risk_coef}
    When the user sets risk of coefficient     ${market}       ${side}    ${risk_coef}
    Then the user can see the appropriate minimum and maximum collateral amounts
