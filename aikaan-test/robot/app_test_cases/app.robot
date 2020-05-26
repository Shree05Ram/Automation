*** Settings ***
Documentation    All the Application related test cases are present in this file
...
...              The test cases are inteded to perform creation and deleteion of apps.
Resource         app.resource
Resource         ../generic_files/common.resource
Library          SeleniumLibrary
Test Setup	Run Keywords
...		KEY_LOGIN_TO_AIKAAN_DASHBOARD
...		KEY_SKIP_HELP_TOUR
...		KEY_CLICK_APP_NAV_TAB
#Test Teardown	Close Browser
Force Tags       app

*** Variables ***
${APP_NAME}    AutoTestApp
${APP_DESC}    This is automation test app

*** Test Cases ***
AP_TC_001: Creation of Application
    [Tags]    smoke
    KEY_CLICK_APP_CREATE_BTN
    #KEY_ENTER_APP_NAME_AND_DESC    ${APP_NAME}1    ${APP_DESC}
    KEY_UPLOAD_YAML_FILE
    #KEY_CLICK_APP_CREATE_BTN_AND_VALIDATE    ${APP_NAME}1

AP_TC_003: Deletion of Application
    [Tags]    smoke
    KEY_DELETE_APP	${APP_NAME}1

AP_TC_002: List of Created Applications
    [Tags]    smoke
    KEY_APP_LIST
