*** Settings ***
Documentation    All the User Management feature related test cases are present in this file
...
...              The test cases are inteded to perform creation and deleteion of users.
Resource         user_management.resource
Resource         ../generic_files/common.resource
Library          SeleniumLibrary
Test Setup      Run Keywords
...             KEY_LOGIN_TO_AIKAAN_DASHBOARD
...             KEY_SKIP_HELP_TOUR
...             KEY_CLICK_USER_NAV_TAB
Test Teardown   Close Browser
Force Tags      user_management 

*** Variables ***
${USER_NAME}    TestUser
${MAIL_ID}      testuser@aikaan.io
${PASSWORD}     123456

*** Test Cases ***
UM_TC_001: Creation of AiKaan User 
    [Tags]    smoke
    KEY_CLICK_USER_CREATE_BTN
    KEY_SELECT_USER_AND_ACCOUNT_TYPE
    KEY_CLICK_NEXT_AND_FILLUP_FORM    ${USER_NAME}    ${MAIL_ID}    ${PASSWORD}
    KEY_CLICK_CREATE_AND_VALIDATE_USER_CREATION    ${USER_NAME}

UM_TC_004: Deletion of Aikaan User
    [Tags]    smoke
    KEY_CLICK_USER_DELETE_ICON_AND_CONFIRM    ${MAIL_ID}
    KEY_VALIDATE_USER_DELETION    ${MAIL_ID}

