*** Settings ***
Resource          ../../resources/keywords.resource

*** Variables ***
${max_collateral_amount}               100000000
${min_collateral_amount}               3000000


*** Keywords ***
the user sets risk of coefficient
    [Arguments]        ${market}       ${side}    ${risk_coef} 
    Set Json Body      ${market}       ${side}    ${risk_coef}
    Post User parameters by API For Valid Response    

Post User parameters by API For Valid Response
    Set Risk of Coefficient for Margin Trade       ${data}     ${headers} 


Set Json Body
    [Arguments]        ${market}       ${side}    ${risk_coef}
    ${data}=           Create Dictionary       side=${side}         market=${market}        risk_coef=${risk_coef}     
    Set Test Variable                        ${data}

    

the user can see the appropriate minimum and maximum collateral amounts
    Check JSON Body For Correct Response    ${response}
    Check collateral max and min            ${response.json()}

Check collateral max and min    
    [Arguments]    ${response_body}
    ${collateral}=    Get From Dictionary    ${response_body['result']}    collateral
    Should Be Equal    ${collateral['max']}     ${max_collateral_amount}
    Should Be Equal    ${collateral['min']}     ${min_collateral_amount}

Check JSON Body For Correct Response
    [Arguments]       ${response} 
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}
    RETURN    ${response}



Post User parameters by API
    Run Keyword And Expect Error   *     Set Risk of Coefficient for Margin Trade     ${data}     ${headers}  

    
Set Risk of Coefficient for Margin Trade
    [Arguments]    ${data}      ${headers}=${HEADERS}     ${HOST_STAGE}=${HOST_STAGE}
    ${response}=   POST    ${HOST_STAGE}/v1/margin-trade/public/loan    headers=${headers}    json=${data} 
    Set Test Variable    ${response}
