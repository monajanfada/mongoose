*** Settings ***
Resource            ../../resources/keywords.resource

*** Variables ***
${status}        ${True}
${message}       address verified
${result}        ${True}

*** Keywords ***
When an address is sent on a specific network
    [Arguments]        ${network}   ${address}     
    Set Json Body      ${network}   ${address}       
    Post User parameters by API For Valid Response   

Set Json Body
    [Arguments]        ${network}   ${address} 
    ${data}=           Create Dictionary     network=${network}   address=${address}            
    Set Test Variable                        ${data}

Post User parameters by API For Valid Response
    Check Address Validation    ${data}     

Check Address Validation
    [Arguments]    ${data}           ${HOST_STAGE}=${HOST_STAGE}
    ${response}=   POST      ${HOST_STAGE}/api/v2/address/validate         json=${data} 
    Set Test Variable    ${response}
    
Then validation of address verification response is checked
    Check JSON Body For Correct Response    ${response}

Check JSON Body For Correct Response
    [Arguments]       ${response} 
    Should Be Equal As Numbers    ${response.status_code}    200
    Log                          ${response.json()}
    Set Test Variable            ${Success_sts}     ${response.json()}    
    Check Response Messages

Check Response Messages
    Check Success Status
    Check Response Message
    Check True Result

Check Success Status
    ${Status_Response}=        Get From Dictionary           ${Success_sts}    status
    Should Be Equal            ${status}                     ${Status_Response}

Check Response Message
    ${Message_Response}=        Get From Dictionary          ${Success_sts}    message
    Should Be Equal             ${message}                   ${Message_Response}

Check True Result
    ${Result_Response}=        Get From Dictionary           ${Success_sts}    result
    Should Be Equal            ${result}                     ${Result_Response}
