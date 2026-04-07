*** Settings ***
Documentation                       Base resource file for margin trade api tests
# Variables                           routes.py     
Library                             RequestsLibrary
Library                             Collections
Library                             Process
Library                             ../../libs/margin_trade.py
# resource                            ../../resources/all.resource                         

*** Variables ***
${ROOT_PATH}                        ${CURDIR}/..
@{Empty_List}
${API_KEY}                          17|dPcIN8a6rDRuxpHfUfd8hpyG9qiSbe43qKt2vTko 

*** Keywords ***
#################################################  Environment  ############################################################################################
Set Suite Environment
    Set Library Search Order        keywords
    Set Log Level                   Trace
    Set Test Header

Set Test Environment
    Log Variables                   level=Trace

Clean Up Test
    Run Keyword If Test Failed      Set Tags    failed
    Run Keyword If Test Passed      Set Tags    passed

Set Test Header
    [Arguments]                     ${auth_token}=${API_KEY}    
    ${headers}=                     Create Dictionary        X-api-key=${auth_token} 
    Set Suite Variable              ${headers}
