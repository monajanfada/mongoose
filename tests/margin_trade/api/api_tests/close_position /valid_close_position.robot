*** Settings ***
Documentation                           The User gets confirmation for suggested parameters 
Suite Setup                             Set Suite Environment
Test Setup                              Set Test Environment
Test Teardown                           Clean Up Test
Resource	                               close_position.resource      

*** Test Cases ***
Close Position
   [Tags]    api   margintrade    close
   When the user closes a position   
   Then The position is closed