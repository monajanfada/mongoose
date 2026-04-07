*** Settings ***
Documentation      A user gets public info about margin trade
Resource           ../../resources/keywords.resource

*** Variables ***
${Expected_BTCTMN_Symbol}                  BTCTMN
${Expected_USDTBTC_Symbol}                 BTCUSDT
${Expected_USDTTMN_Symbol}                 USDTTMN
${Expected_Base_BTCTMN_Market}             BTC
${Expected_Quote_BTCTMN_Market}            TMN
${Expected_Base_BTCUSDT_Market}            BTC
${Expected_Quote_BTCUSDT_Market}           USDT
${Expected_Base_USDTTMN_Market}            USDT
${Expected_Base_USDTTMN_Market}            TMN
${Expected_Min_Risk_Coef}                  1
${Expected_Max_Risk_Coef}                  10
${Expected_Max_Risk_Step}                  0.5

*** Keywords ***
When a random user requests information about markets
    Get User Details
    
Get User Details
    [Arguments]                     ${HOST_STAGE}=${HOST_STAGE}
    ${response}=       GET          ${HOST_STAGE}/v1/margin-trade/public/markets
    Set Test Variable               ${response}

Then the user receives information on the enabled markets
    Should Be Equal As Numbers    ${response.status_code}    200
    Log    ${response.json()}
    Check Get Market Expected Response Body    ${response.json()}

Check Get Market Expected Response Body
    [Arguments]    ${response_body}
    ${markets}=    Get From Dictionary    ${response_body}    result
    ${first_market}=    Get From List    ${markets}    0
    Set Market Variables     ${first_market}
    Check Expected BTCTMN Market
    # Check Expected BTCTMN Base Market      must check with Ali
    # Check Expected BTCTMN Quote Market
    # Check Expected BTCTMN Min Risk Coef
    # Check Expected BTCTMN Max Risk Coef
    # Check Expected BTCTMN Max Risk Step
    # Check Expected BTCUSDT Market
    # Check Expected BTCUSDT Base Market
    # Check Expected BTCUSDT Quote Market
    # Check Expected BTCUSDT Min Risk Coef
    # Check Expected BTCUSDT Max Risk Coef
    # Check Expected BTCUSDT Max Risk Step
    # Check Expected USDTTMN Market
    # Check Expected USDTTMN Base Market
    # Check Expected USDTTMN Quote Market
    # Check Expected USDTTMN Min Risk Coef
    # Check Expected USDTTMN Max Risk Coef
    # Check Expected USDTTMN Max Risk Step

Check Expected BTCTMN Market
    Should Be Equal    ${Market_symbol}    ${Expected_BTCTMN_Symbol}

Check Expected Base Market
    Should Be Equal    ${Market_base}    ${Expected_Base_Market}


Check Expected Quote Market
    Should Be Equal    ${Market_quote}    ${Expected_quote_Market}

Check Expected Min Risk Coef
    Should Be Equal    ${Market_min_risk_coef}    ${Expected_Min_Risk_Coef}

Check Expected Max Risk Coef
    Should Be Equal    ${Market_max_risk_coef}    ${Expected_Max_Risk_Coef}


Check Expected Max Risk Step
    Should Be Equal    ${Market_risk_coef_step}    ${Expected_Max_Risk_Step}

Set Market Variables 
    [Arguments]    ${market_info}
    FOR    ${key}    ${value}    IN    &{market_info}
        Set Test Variable    ${market_${key}}    ${value}
    END
