*** Settings ***
Documentation                           A user gets public info about margin trade
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test
Resource	                            get_markets.resource      



*** Test Cases ***
Get All Markets
    [Tags]    api      markets
    When a random user requests information about markets
    Then the user receives information on the enabled markets