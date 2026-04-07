*** Settings ***
Documentation                       Base resource file for blockchain api tests
Library                             String
Library                             RequestsLibrary
Library                             Collections
Library                             Process
Library                             ../../libs/blockchain.py

*** Variables ***
${ROOT_PATH}                        ${CURDIR}/..
@{Empty_List}

*** Keywords ***
#################################################  Environment  ############################################################################################
Set Suite Environment
    Set Library Search Order        keywords
    Set Log Level                   Trace

Set Test Environment
    Log Variables                   level=Trace

Clean Up Test
    Run Keyword If Test Failed      Set Tags    failed
    Run Keyword If Test Passed      Set Tags    passed


