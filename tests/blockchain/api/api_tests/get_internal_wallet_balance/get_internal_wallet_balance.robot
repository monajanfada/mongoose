*** Settings ***
Documentation      Get internal wallet balance for etherium coin
Resource	       get_internal_wallet_balance.resource   
Suite Setup        Set Suite Environment
Test Setup         Set Test Environment
Test Teardown      Clean Up Test   
Library            DataDriver     valid.csv    encoding=UTF-8    handle_template_tags=DefaultTags

Test Template      Internal Wallet Balance 

*** Test Cases ***
${coin_address}      ${token_param}    ${token_coin}

*** Keywords ***
Internal Wallet Balance 
    [Arguments]    ${coin_address}      ${token_param}    ${token_coin}
    When getting internal wallet balance for Etherium coin     ${coin_address}      ${token_param}    ${token_coin}
    Then the successful operation message is checked align with balances
