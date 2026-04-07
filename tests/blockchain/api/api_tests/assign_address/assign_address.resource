*** Settings ***
Resource           ../../resources/keywords.resource
Resource           ../address_verification/address_verification.resource

*** Variables ***
${message}           The operation was successful
${status}            ${True}

*** Keywords ***
When an address is assigned
    Get User Details
    
Get User Details
    [Arguments]     ${HOST_STAGE}=${HOST_STAGE}
    ${response}=       GET          url=${HOST_STAGE}/api/address/BSC?userId=1&clusterId=2
    Set Test Variable               ${response}


Then the signature verification is successful
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}
    Set Test Variable     ${response_body}     ${response.json()}
    Check Assign Address Response Body    

Check Assign Address Response Body
    Check Response status
    Check Response Message
    # Check Result Address
    # Check Result Path 

Check Response Message
    ${Message_Response}=        Get From Dictionary          ${response_body}    message
    Should Be Equal             ${message}                   ${Message_Response}

Check Response status
    ${Status_Response}=        Get From Dictionary          ${response_body}    status
    Should Be Equal             ${status}                   ${Status_Response}


