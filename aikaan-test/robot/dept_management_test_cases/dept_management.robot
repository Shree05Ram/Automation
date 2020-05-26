*** Settings ***
Documentation    All the Department Management feature related test cases are present in this file
...
...              The test cases are inteded to perform creation and deleteion of users.
Resource         dept_management.resource
Resource         ../generic_files/common.resource
Library          SeleniumLibrary
Test Setup      Run Keywords
...             KEY_LOGIN_TO_AIKAAN_DASHBOARD
...             KEY_SKIP_HELP_TOUR
...             KEY_CLICK_USER_NAV_TAB
Test Teardown   Close Browser
Force Tags      user_management 

*** Variables ***
${DEPT_NAME}    TestDepartment

*** Test Cases ***
DEPT_TC_001: Creatio of Department
    [Tags]    smoke
    KEY_CLICK_DEPT_CREATE_BTN_AND_FILLUP_FORM    ${DEPT_NAME}1
    KEY_CLICK_CREATE_AND_VALIDATE_DEPT_CREATION    ${DEPT_NAME}1
 
DEPT_TC_002: Deletion of Department
   [Tags]    smoke
   KEY_CLICK_DEPT_DELETE_ICON_AND_CONFIRM    ${DEPT_NAME}1

