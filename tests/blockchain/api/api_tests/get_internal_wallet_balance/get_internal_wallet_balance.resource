*** Settings ***
Documentation      A user assigns an address and check if the operation was successful
Resource           ../../resources/keywords.resource

*** Variables ***
${raw_param}      isRaw=${True}
${status}         ${True}
${message}        The operation was successful

*** Keywords ***
getting internal wallet balance for Etherium coin
    [Arguments]    ${coin_address}      ${token_param}    ${token_coin}
    Get Internal Wallet Balance   ${coin_address}      ${token_param}    ${token_coin}


Get Internal Wallet Balance   
    [Arguments]          ${coin_address}      ${token_param}    ${token_coin}   ${HOST_STAGE}=${HOST_STAGE}
    ${response}=   GET      ${HOST_STAGE}/api/balance/address/${coin_address}/${token_param}?${token_coin}&${raw_param}    
    Set Test Variable       ${response}
    Set Test Variable       ${coin_address}

Then the successful operation message is checked align with balances
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}
    Set Test Variable     ${response_body}     ${response.json()}
    Check Internal Wallet Balance Response Body    

Check Internal Wallet Balance Response Body
    Check Response status
    Check Response Message
    Check Result Address
    # Check Result Balance   must check it

Check Response Message
    ${Message_Response}=        Get From Dictionary          ${response_body}    message
    Should Be Equal             ${message}                   ${Message_Response}

Check Response status
    ${Status_Response}=        Get From Dictionary          ${response_body}    status
    Should Be Equal             ${status}                   ${Status_Response}

Check Result Address
    ${Address_Response}=        Get From Dictionary          ${response_body['result']}    address
    Should Be Equal             ${coin_address}              ${Address_Response}
        




