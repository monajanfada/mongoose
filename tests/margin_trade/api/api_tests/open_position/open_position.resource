*** Settings ***
Documentation       A user opens a margin trade position
Library             DateTime
Library             String
Resource            ../../resources/keywords.resource


*** Variables ***
${Collateral_Currency}     TMN
${Loan_Currency}           USDT
${Init_State}              INIT
${Max_Age}                 ${1209600}
${Fee_Coefficient}         0.0025    # 25%
${Liquidity_Coefficient}   0.05      # 5%
${Call_Price_Coefficient}  0.3       # 30%
${Margin_Coefficient}      0.00015   # 0.015%


*** Keywords ***
When the user opens a position
    [Arguments]        ${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}    ${take_profit}    
    Set Json Body      ${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}    ${take_profit}    
    Post User parameters by API For Valid Response    

Post User parameters by API For Valid Response
    Open A Margin Trade Position    ${data}     ${headers}  


Set Json Body
    [Arguments]        ${market}             ${side}     ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}       ${take_profit}    
    ${data}=           Create Dictionary     market=${market}   side=${side}         collateral=${collateral}     risk_coef=${risk_coef}       
    ...                open_price=${open_price}      stop_loss=${stop_loss}    take_profit=${take_profit}    
    Set Test Variable                        ${data}

    
Then The position is opened
    Check JSON Body For Correct Response    ${response}

Check JSON Body For Correct Response
    [Arguments]       ${response} 
    Should Be Equal As Numbers    ${response.status_code}    200
    Log                          ${response.json()}
    ${result}=    Get From Dictionary    ${response.json()}    result
    Set Test Variable            ${Success_sts}     ${response.json()}    
    Set Test Variable            ${result}
    Check ID
    Check Market
    Check side
    Check Collateral Value
    Check Collateral Currency
    Check Loan Value
    Check Loan Currency
    Check Risk Coefficient Amount
    Check Open Price
    Check Stop Loss Amount
    Check Take Profit Amount
    Check Liquidity Price
    Check Call Price
    Check Is Called
    Check State
    Check Max Age Amount
    Check Created At 
    Check First Order Filled
    Check Success Status 

    
Open A Margin Trade Position
    [Arguments]    ${data}      ${headers}=${HEADERS}        ${HOST_STAGE}=${HOST_STAGE}
    ${response}=   POST      ${HOST_STAGE}/v1/margin-trade/positions      headers=${headers}    json=${data} 
    Set Test Variable    ${response}

Check ID
    ${ID_Response}=            Get From Dictionary             ${result}                   id
    ${Json_Body}               Get Status                      ${ID_Response}
    ${Response_Body}           Get From Dictionary             ${Json_Body}                result
    Set Test Variable          ${Response_Body}
    ${ID}                      Get From Dictionary             ${Response_Body}            id
    Should Be Equal            ${ID}                           ${ID_Response}

Check Market
    ${Market_Response}=        Get From Dictionary                 ${result}    market
    Should Be Equal            ${data['market']}                   ${Market_Response}

Check side
    ${Side_Response}=          Get From Dictionary              ${result}    side
    Should Be Equal            ${data['side']}                  ${Side_Response}
    
Check Collateral Value
    ${Loan_Currecy_Response}=    Get From Dictionary    ${result['collateral']}    value
    Should Be Equal              ${data['collateral']}             ${Loan_Currecy_Response}

Check Collateral Currency
    ${Loan_Currecy_Response}=    Get From Dictionary    ${result['collateral']}    currency
    Should Be Equal              ${Collateral_Currency}            ${Loan_Currecy_Response}

Check Loan Value
    ${Loan_Value_Response}=            Get From Dictionary               ${result['loan']}    value
    IF      '${data['side']}' == 'short'
            ${Loan_Value}              Evaluate                  round((${data['collateral']} * ${data['risk_coef']}) / ${data['open_price']}) 
    ELSE
            ${Loan_Value}              Evaluate                  round(${data['collateral']} * ${data['risk_coef']}) 
    END
    ${Loan_Value}                      Convert To String                 ${Loan_Value}
    Set Test Variable                  ${Loan_Value}
    Should Be Equal                    ${Loan_Value_Response}            ${Loan_Value}

Check Loan Currency
    ${Loan_Currecy_Response}=    Get From Dictionary    ${result['loan']}    currency
    Should Be Equal              ${Loan_Currency}            ${Loan_Currecy_Response}

Check Risk Coefficient Amount
    ${Risk_Coef_Response}=        Get From Dictionary                ${result}    risk_coef
    Should Be Equal               ${data['risk_coef']}               ${Risk_Coef_Response}

Check Open Price
    ${Open_Price_Response}=       Get From Dictionary                ${result}    open_price
    Should Be Equal               ${data['open_price']}              ${Open_Price_Response}

Check Stop Loss Amount 
    ${Stop_Loss_Response}=          Get From Dictionary                   ${result}    stop_loss
    Should Be Equal                 ${data['stop_loss']}                  ${Stop_Loss_Response}

Check Take Profit Amount
    ${Take_Profit_Response}=          Get From Dictionary                   ${result}    take_profit
    Should Be Equal                   ${data['take_profit']}                ${Take_Profit_Response}

Check Liquidity Price
    ${Liquidity_Price_Response}=            Get From Dictionary                ${result}    liquidity_price
    # ${Miimum_Price}=                        Evaluate                           round((1+(${Margin_Coefficient}) - 1/${data['risk_coef']})/((1-${Fee_Coefficient})**2)*${result['open_price']})
    # ${Differential_Validation}=             Evaluate                           round(${result['open_price']}-${Miimum_Price})     
    # ${Liquidity_Price}=                     Evaluate                           round((${Differential_Validation}*${Liquidity_Coefficient})+${Miimum_Price})   
    # Set Test Variable                       ${Miimum_Price}              
    # Set Test Variable                       ${Liquidity_Price}               
    # Set Test Variable                       ${Differential_Validation}
    # ${Liquidity_Price}                      Convert To String                  ${Liquidity_Price}
    # Should Be Equal                         ${Liquidity_Price_Response}        ${Liquidity_Price}
    Should Be Equal                         ${Liquidity_Price_Response}        ${None}
    
Check Call Price
    ${Call_Price_Response}=                      Get From Dictionary                     ${result}    call_price
    # ${Call_Price}                                Evaluate                                round((${Differential_Validation}*${Call_Price_Coefficient})+${Miimum_Price})
    # ${Call_Price}                                Convert To String                       ${Call_Price}
    # Should Be Equal                              ${Call_Price_Response}                  ${Call_Price}
    Should Be Equal                              ${Call_Price_Response}                  ${None}

Check Is Called
    ${Is_Called_Response}=              Get From Dictionary    ${result}    is_called
    Should Be Equal                     ${Is_Called_Response}    ${FALSE} 

Check State
    ${State_Response}=              Get From Dictionary    ${result}    state
    Should Be Equal                 ${State_Response}    ${Init_State}

Check Max Age Amount
    ${Max_Age_Response}=                Get From Dictionary    ${result}    max_age
    Should Be Equal                     ${Max_Age}             ${Max_Age_Response}

Check Created At
    ${Created_at}                      Get From Dictionary               ${Response_Body}                created_at
    ${Created_at_Response}=            Get From Dictionary               ${result}                   created_at
    Should Contain                     ${Created_at_Response}            ${Created_at}

Check First Order Filled
    ${First_Order_Filled_Response}=              Get From Dictionary    ${result}    first_order_filled
    Should Be Equal                              ${First_Order_Filled_Response}    ${False}

Check Success Status 
    ${Success_Response}=       Get From Dictionary                  ${response.json()}      success
    Should Be Equal            ${Success_Response}                  ${True}
