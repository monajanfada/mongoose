*** Settings ***
Documentation                           A user closes an open position
Resource                                ../../resources/keywords.resource
Library                                 String

*** Variables ***
${Collateral_Currency}     TMN
${Loan_Currency}           USDT
${Init_State}              CREATED
${Max_Age}                 ${1209600}
${market}                  USDTTMN  
${side}                    short  
${collateral}              10000000   
${risk_coef}               1   
${open_price}              60000
${stop_loss}               90000
${take_profit}             56000
${Interest_Value}          0.03    #CHECK
${Intrest_Currency}        USDT

*** Keywords ***
When the user closes a position
    Close a margin trade position       ${headers}

The position is closed
    Check JSON Body For Correct Response    ${response}

Close a margin trade position
    [Arguments]            ${headers}=${HEADERS}    ${HOST_STAGE}=${HOST_STAGE}
    ${ID}          Open Position     ${market}       ${side}       ${collateral}       ${risk_coef}      ${open_price}      ${stop_loss}    ${take_profit}
    Set Test Variable  ${ID}
    Get Status     ${ID}
    ${data}=           Create Dictionary     close_price=${100000}
    ${response}=   PATCH     ${HOST_STAGE}/v1/margin-trade/positions/${ID}/close    headers=${headers}   json=${data}    
    Set Test Variable    ${response}

Check JSON Body For Correct Response
    [Arguments]       ${response} 
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}
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
    Check Interest Value
    Check Interest Currency
    Check Profit Value
    Check Profit Currency
    Check Risk Coefficient Amount
    Check Open Price
    Check Stop Loss Amount
    Check Take Profit Amount
    Check Liquidity Price
    Check Call Price
    Check Is Called
    Check State
    Check Max Age Amount
    Check Order ID
    Check Order Market
    Check Order Side
    Check Order Price Value
    Check Order Price Currency
    Check Order Filled Price Value
    Check Order Filled Price Currency
    Check Order Volume Value
    Check Order Volume Currency
    Check Order Fee Value
    Check Order Fee Currency
    Check Order Filled Value
    Check Order Filled Currency
    Check Order Created At 
    Check Is Open
    Check Created At 
    Check Opened At 
    Check Expires At
    Check Close Reason 
    Check First Order Filled
    Check Success Status 

    
Open A Margin Trade Position
    [Arguments]    ${data}      ${headers}=${HEADERS}                        ${HOST_STAGE}=${HOST_STAGE}
    ${response}=   POST         ${HOST_STAGE}/v1/margin-trade/positions      headers=${headers}    json=${data} 
    Set Test Variable           ${response}

Check ID
    ${ID_Response}=            Get From Dictionary             ${result}                   id
    ${Json_Body}               Get Status                      ${ID_Response}
    ${Response_Body}           Get From Dictionary             ${Json_Body}                result
    Set Test Variable          ${Response_Body}
    ${ID}                      Get From Dictionary             ${Response_Body}            id
    Should Be Equal            ${ID}                           ${ID_Response}

Check Market
    ${Market_Response}=        Get From Dictionary                 ${result}    market
    Should Be Equal            ${market}                  ${Market_Response}

Check side
    ${Side_Response}=          Get From Dictionary              ${result}    side
    Should Be Equal            ${side}                  ${Side_Response}
    
Check Collateral Value
    ${Loan_Currecy_Response}=    Get From Dictionary    ${result['collateral']}    value
    Should Be Equal              ${collateral}             ${Loan_Currecy_Response}

Check Collateral Currency
    ${Loan_Currecy_Response}=    Get From Dictionary    ${result['collateral']}    currency
    Should Be Equal              ${Collateral_Currency}            ${Loan_Currecy_Response}

Check Loan Value
    ${Loan_Value_Response}=            Get From Dictionary               ${result['loan']}    value
    IF      '${side}' == 'short'
            ${Loan_Value}              Evaluate                  (${collateral} * ${risk_coef}) / ${open_price}
    ELSE
            ${Loan_Value}              Evaluate                  ${collateral} * ${risk_coef}
    END
    Set Test Variable                  ${Loan_Value}   
    ${Loan_Value}                      Convert To String                 ${Loan_Value}
    ${contains_decimal}                Evaluate    '.' in '${Loan_Value}'
    Run Keyword If                     ${contains_decimal}      Process Decimal Value    ${Loan_Value}                  
    Should Be Equal                    ${Loan_Value_Response}            ${Loan_Value}

Process Decimal Value
    [Arguments]                        ${Loan_Value}
    ${Integer_Number}                  ${Decimal_Number}                 Split String           ${Loan_Value}     .
    ${first two} 	                   Get Substring                	 ${Decimal_Number}  	0	2
    ${Catenated_Value}                 Catenate                          ${Integer_Number}      .   ${first two}    
    ${Evaluated_Loan_Value}            Remove String Using Regexp        ${Catenated_Value}     ${SPACE}
    Set Test Variable                  ${Loan_Value}                     ${Evaluated_Loan_Value}

Check Loan Currency
    ${Loan_Currecy_Response}=    Get From Dictionary         ${result['loan']}    currency
    Should Be Equal              ${Loan_Currency}            ${Loan_Currecy_Response}

Check Interest Value
    ${Intrest_Value_Response}=      Get From Dictionary       ${result['interest']}    value
    Should Be Equal                 ${Interest_Value}         ${Intrest_Value_Response}

Check Interest Currency
    ${Intrest_Currecy_Response}=    Get From Dictionary         ${result['interest']}    currency
    Should Be Equal                 ${Intrest_Currency}            ${Intrest_Currecy_Response}

Check Profit Value
    ${Intrest_Value_Response}=      Get From Dictionary       ${result['interest']}    value
    Should Be Equal                 ${Interest_Value}         ${Intrest_Value_Response}
    
Check Profit Currency
    ${Intrest_Currecy_Response}=    Get From Dictionary         ${result['interest']}    currency
    Should Be Equal                 ${Intrest_Currency}            ${Intrest_Currecy_Response}
Check Risk Coefficient Amount
    ${Risk_Coef_Response}=        Get From Dictionary                ${result}    risk_coef
    Should Be Equal               ${risk_coef}                       ${Risk_Coef_Response}

Check Open Price
    ${Open_Price_Response}=       Get From Dictionary                ${result}    open_price
    Should Be Equal               ${open_price}                      ${Open_Price_Response}

Check Stop Loss Amount 
    ${Stop_Loss_Response}=          Get From Dictionary                   ${result}    stop_loss
    Should Be Equal                 ${stop_loss}                          ${Stop_Loss_Response}

Check Take Profit Amount
    ${Take_Profit_Response}=          Get From Dictionary                   ${result}    take_profit
    Should Be Equal                   ${take_profit}                        ${Take_Profit_Response}

Check Liquidity Price
    ${Liquidity_Price_Response}=            Get From Dictionary                ${result}    liquidity_price
    Should Be Equal                         ${Liquidity_Price_Response}                     ${None}
    # ${Liquidity_Price}                      Evaluate                           round((((1 + ${Open_Fee_Value}) - 1/${risk_coef})/0.95)*${result['open_price']})
    # Set Test Variable                       ${Liquidity_Price}
    # ${Liquidity_Price}                      Convert To String                  ${Liquidity_Price}
    # Should Be Equal                         ${Liquidity_Price_Response}        ${Liquidity_Price}
    
Check Call Price
    ${Call_Price_Response}=                      Get From Dictionary                     ${result}    call_price
    Should Be Equal                              ${Call_Price_Response}                  ${None}
    # ${Call_Price}                                Evaluate                                round(${Liquidity_Price}*1.05)
    # ${Call_Price}                                Convert To String                       ${Call_Price}
    # Should Be Equal                              ${Call_Price_Response}                  ${Liquidity_Price}

Check Is Called
    ${Is_Called_Response}=              Get From Dictionary    ${result}    is_called
    Should Be Equal                     ${Is_Called_Response}    ${FALSE} 

Check State
    ${State_Response}=              Get From Dictionary    ${result}    state
    Should Be Equal                 ${State_Response}    ${Init_State}

Check Max Age Amount
    ${Max_Age_Response}=                Get From Dictionary    ${result}    max_age
    Should Be Equal                     ${Max_Age}             ${Max_Age_Response}

Check Order ID
    ${Order_ID}=                        Get From Dictionary             ${Response_Body['order']}        id
    ${Order_ID_Response}=               Get From Dictionary             ${result['order']}           id
    Should Be Equal                     ${Order_ID}                     ${Order_ID_Response}

Check Order Market
    ${Order_Market}                     Get From Dictionary             ${Response_Body['order']}        market
    ${Order_Market_Response}=           Get From Dictionary             ${result['order']}           market
    Should Be Equal                     ${Order_Market}                 ${Order_Market_Response}
Check Order Side
    ${Order_Side}                       Get From Dictionary             ${Response_Body['order']}        side
    ${Order_Side_Response}=             Get From Dictionary             ${result['order']}           side
    Should Be Equal                     ${Order_Side}                   ${Order_Side_Response}

Check Order Price Value
    ${Order_Price_Value}                Get From Dictionary             ${Response_Body['order']['price']}        value
    ${Order_Price_Value_Response}=      Get From Dictionary             ${result['order']['price']}        value
    Should Be Equal                     ${Order_Price_Value}                     ${Order_Price_Value_Response}

Check Order Price Currency
    ${Order_Price_Currency}             Get From Dictionary             ${Response_Body['order']['price']}        currency
    ${Order_Price_Currency_Response}=   Get From Dictionary             ${result['order']['price']}        currency
    Should Be Equal                     ${Order_Price_Currency}                     ${Order_Price_Currency_Response}

Check Order Filled Price Value
    ${Order_Filled_Price_Value}         Get From Dictionary             ${Response_Body['order']['filled_price']}        value
    ${Order_Filled_Price_Value_Response}=               Get From Dictionary             ${result['order']['filled_price']}        value
    Should Be Equal                     ${Order_Filled_Price_Value}                     ${Order_Filled_Price_Value_Response}

Check Order Filled Price Currency
    ${Order_Filled_Price_Currency}    Get From Dictionary             ${Response_Body['order']['filled_price']}        currency
    ${Order_Filled_Price_Currency_Response}=               Get From Dictionary             ${result['order']['filled_price']}        currency
    Should Be Equal                     ${Order_Filled_Price_Currency}                     ${Order_Filled_Price_Currency_Response}

Check Order Volume Value
    ${Order_Voluem_Value}               Get From Dictionary             ${Response_Body['order']['volume']}        value
    ${Order_Voluem_Value_Response}=     Get From Dictionary             ${result['order']['volume']}        value
    Should Be Equal                     ${Order_Voluem_Value}                     ${Order_Voluem_Value_Response}

Check Order Volume Currency
    ${Order_Volume_Currency}            Get From Dictionary             ${Response_Body['order']['volume']}        currency
    ${Order_Volume_Currency_Response}=  Get From Dictionary             ${result['order']['volume']}        currency
    Should Be Equal                     ${Order_Volume_Currency}        ${Order_Volume_Currency_Response}

Check Order Fee Value
    ${Order_Fee_Value}                  Get From Dictionary             ${Response_Body['order']['fee']}        value
    ${Order_Fee_Value_Response}=        Get From Dictionary             ${result['order']['fee']}        value
    Should Be Equal                     ${Order_Fee_Value}              ${Order_Fee_Value_Response}

Check Order Fee Currency
    ${Order_Volume_Currency}            Get From Dictionary             ${Response_Body['order']['fee']}        currency   
    ${Order_Volume_Currency_Response}=               Get From Dictionary             ${result['order']['fee']}           currency
    Should Be Equal                     ${Order_Volume_Currency}        ${Order_Volume_Currency_Response}

Check Order Filled Value
    ${Order_Filled_Value}               Get From Dictionary             ${Response_Body['order']['filled']}        value
    ${Order_Filled_Value_Response}=     Get From Dictionary             ${result['order']['filled']}         value
    Should Be Equal                     ${Order_Filled_Value}           ${Order_Filled_Value_Response}

Check Order Filled Currency
    ${Order_Filled_Currency}            Get From Dictionary             ${Response_Body['order']['filled']}        currency
    ${Order_Filled_Currency_Response}=  Get From Dictionary             ${result['order']['filled']}           currency
    Should Be Equal                     ${Order_Filled_Currency}        ${Order_Filled_Currency_Response}

Check Order Created At
    ${Order_Created_At}                 Get From Dictionary             ${Response_Body['order']}        created_at
    ${Order_Created_At_Response}=       Get From Dictionary             ${result['order']}           created_at
    Should Be Equal                     ${Order_Created_At}             ${Order_Created_At_Response}

Check Is Open
    ${Order_Is_Open}                    Get From Dictionary             ${Response_Body['order']}        is_open
    ${Order_Is_Open_Response}=          Get From Dictionary             ${result['order']}           is_open
    Should Be Equal                     ${Order_Is_Open}                ${Order_Is_Open_Response}

Check Opened At 
    ${Opened_At}                        Get From Dictionary             ${Response_Body}                 opened_at
    ${Opened_At_Response}=              Get From Dictionary             ${result}                        opened_at
    Should Be Equal                     ${Opened_At}                    ${Opened_At_Response}

Check Expires At
    ${Expires_At}                       Get From Dictionary              ${Response_Body}                expires_at
    ${Expires_At_Response}=             Get From Dictionary              ${result}          expires_at
    Should Be Equal                     ${Expires_At}                    ${Expires_At_Response}

Check Close Reason 
    ${Close_At}                      Get From Dictionary                 ${Response_Body}                close_reason
    ${Close_At_Response}=            Get From Dictionary                 ${result}          close_reason
    Should Be Equal                  ${Close_At}                         ${Close_At_Response}
    
Check Created At
    ${Created_at}                      Get From Dictionary               ${Response_Body}                created_at
    ${Created_at_Response}=            Get From Dictionary               ${result}                   created_at
    Should Contain                     ${Created_at_Response}            ${Created_at}

Check First Order Filled
    ${First_Order_Filled_Response}=    Get From Dictionary              ${result}                    first_order_filled
    Should Be Equal                    ${First_Order_Filled_Response}   ${False}

Check Success Status 
    ${Success_Response}=                Get From Dictionary             ${response.json()}           success
    Should Be Equal                     ${Success_Response}             ${True}
