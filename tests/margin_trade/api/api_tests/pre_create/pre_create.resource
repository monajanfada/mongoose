*** Settings ***
Documentation             A user pre create a position in margin trade
Resource                  ../../resources/keywords.resource

*** Variables ***
${Currency}                TMN
${Currency_Other_Side}     USDT
${Max_Age}                 ${1209600}
${Margin_Coefficient}      0.00015   # 0.015%
${Max_Life_Time}           336
${Time_Span}               4         #Isn't it?
${Fee_Coefficient}         0.0025    # 25%
${Liquidity_Coefficient}   0.05      # 5%
${Call_Price_Coefficient}  0.3       # 30%
    
*** Keywords ***
When the user chooses some parameters
    [Arguments]        ${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}    ${take_profit}
    Set Json Body      ${market}   ${side}  ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}    ${take_profit}
    Post User parameters by API For Valid Response     

Post User parameters by API For Valid Response
    Pre Create A Margin Trade    ${data}     ${headers}  


Set Json Body
    [Arguments]        ${market}             ${side}     ${collateral}   ${risk_coef}      ${open_price}      ${stop_loss}       ${take_profit}
    ${data}=           Create Dictionary     market=${market}   side=${side}         collateral=${collateral}     risk_coef=${risk_coef}       
    ...                open_price=${open_price}      stop_loss=${stop_loss}    take_profit=${take_profit}
    Set Test Variable                        ${data}

    

Pre Create A Margin Trade
    [Arguments]    ${data}      ${headers}=${HEADERS}      ${HOST_STAGE}=${HOST_STAGE}
    ${response}=   POST       ${HOST_STAGE}/v1/margin-trade/public/dry-run      headers=${headers}    json=${data} 
    Set Test Variable    ${response}


Then the user receives extend fee and liquidation price
    Check JSON Body For Correct Response    ${response}

Check JSON Body For Correct Response
    [Arguments]       ${response} 
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}     
    ${result}=    Get From Dictionary    ${response.json()}    result
    Set Test Variable            ${Success_sts}     ${response.json()}    
    Set Test Variable            ${result}
    Check Loan Value
    Check Open Fee Value
    Check Open Fee Currency
    Check Liquidity Price
    Check Call Price
    Check Collateral Value
    Check Collateral Currency
    Check Loan Currency
    Check Extend Fee Value
    Check Extend Fee Currency
    Check Market
    Check Max Age Amount
    Check Open Price
    Check Risk Coefficient Amount
    Check side
    Check Stop Loss Amount
    Check Take Profit Amount
    Check Trade Fee Value
    Check Trade Fee Currency
    Check Success Status 
    


Check Liquidity Price
    ${Liquidity_Price_Response}=            Get From Dictionary                ${result}    liquidity_price
    ${Miimum_Price}=                        Evaluate                           round((1+(${Margin_Coefficient}) - 1/${data['risk_coef']})/((1-${Fee_Coefficient})**2)*${result['open_price']})
    ${Differential_Validation}=             Evaluate                           round(${result['open_price']}-${Miimum_Price})     
    ${Liquidity_Price}=                     Evaluate                           round((${Differential_Validation}*${Liquidity_Coefficient})+${Miimum_Price})   
    Set Test Variable                       ${Miimum_Price}              
    Set Test Variable                       ${Liquidity_Price}               
    Set Test Variable                       ${Differential_Validation}
    ${Liquidity_Price}                      Convert To String                  ${Liquidity_Price}
    Should Be Equal                         ${Liquidity_Price_Response}        ${Liquidity_Price}

    
Check Collateral Value
    ${Collateral_Value_Response}=    Get From Dictionary            ${result['collateral']}    value
    Should Be Equal                  ${data['collateral']}          ${Collateral_Value_Response}

Check Collateral Currency
    ${Collateral_Currency_Response}=    Get From Dictionary    ${result['collateral']}    currency
    Should Be Equal                     ${Currency}            ${Collateral_Currency_Response}

Check Extend Fee Value
    Check Open Fee Value

Check Extend Fee Currency
    ${Extend_Fee_Currecy_Response}=    Get From Dictionary    ${result['extend_fee']}    currency
    Should Be Equal                    ${Currency}            ${Extend_Fee_Currecy_Response}
    
Check Call Price
    ${Call_Price_Response}=                      Get From Dictionary                     ${result}    call_price
    ${Call_Price}                                Evaluate                                round((${Differential_Validation}*${Call_Price_Coefficient})+${Miimum_Price})
    ${Call_Price}                                Convert To String                       ${Call_Price}
    Should Be Equal                              ${Call_Price_Response}                  ${Call_Price}

Check Loan Value
    ${Loan_Value_Response}=            Get From Dictionary               ${result['loan']}    value
    ${Loan_Value}                      Evaluate                          ${data['collateral']} * ${data['risk_coef']} 
    ${Loan_Value}                      Convert To String                 ${Loan_Value}
    Set Test Variable                  ${Loan_Value}
    Should Be Equal                    ${Loan_Value_Response}            ${Loan_Value}

Check Loan Currency
    ${Loan_Currecy_Response}=    Get From Dictionary    ${result['loan']}    currency
    Should Be Equal              ${Currency}            ${Loan_Currecy_Response}
    
Check Market
    ${Market_Response}=        Get From Dictionary                ${result}    market
    Should Be Equal            ${data['market']}                  ${Market_Response}

Check Max Age Amount
    ${Max_Age_Response}=                Get From Dictionary    ${result}    max_age
    Should Be Equal                     ${Max_Age}             ${Max_Age_Response}

Check Open Fee Value
    ${Open_Fee_Value_Response}=            Get From Dictionary               ${result['open_fee']}    value
    ${Open_Fee_Value}                      Evaluate                          round(${Loan_Value} * 0.00015)
    Set Test Variable                      ${Open_Fee_Value}
    ${Open_Fee_Value}                      Convert To String                 ${Open_Fee_Value}
    Should Be Equal                        ${Open_Fee_Value_Response}        ${Open_Fee_Value}

Check Open Fee Currency
    ${Open_Fee_Currecy_Response}=    Get From Dictionary          ${result['loan']}    currency
    Should Be Equal                  ${Currency}                  ${Open_Fee_Currecy_Response}

Check Open Price
    ${Open_Price_Response}=       Get From Dictionary                ${result}    open_price
    Should Be Equal               ${data['open_price']}              ${Open_Price_Response}

Check Risk Coefficient Amount
    ${Risk_Coef_Response}=        Get From Dictionary                ${result}    risk_coef
    Should Be Equal               ${data['risk_coef']}               ${Risk_Coef_Response}
    
Check side
    ${Side_Response}=          Get From Dictionary              ${result}    side
    Should Be Equal            ${data['side']}                  ${Side_Response}

Check Stop Loss Amount 
    ${Stop_Loss_Response}=          Get From Dictionary                   ${result}    stop_loss
    Should Be Equal                 ${data['stop_loss']}                  ${Stop_Loss_Response}

Check Take Profit Amount
    ${Take_Profit_Response}=          Get From Dictionary                   ${result}    take_profit
    Should Be Equal                   ${data['take_profit']}                ${Take_Profit_Response}

Check Trade Fee Value
    ${Trade_Fee_Value_Response}=            Get From Dictionary                ${result['trade_fee']}    value
    ${Trade_Fee_Value}                      Evaluate                           round(${Loan_Value} * 0.0025)/${data['open_price']}
    ${Trade_Fee_Value}                      Convert To String                  ${Trade_Fee_Value}
    Should Be Equal                         ${Trade_Fee_Value_Response}        ${Trade_Fee_Value}

Check Trade Fee Currency
    ${Trade_Fee_Currecy_Response}=    Get From Dictionary         ${result['trade_fee']}    currency
    Should Be Equal                   ${Currency_Other_Side}      ${Trade_Fee_Currecy_Response}

Check Success Status 
    ${Success_Response}=       Get From Dictionary                  ${response.json()}      success
    Should Be Equal            ${Success_Response}                  ${True}