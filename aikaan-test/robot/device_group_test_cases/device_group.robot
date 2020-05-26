*** Settings ***
Documentation    All the device group related test cases are present in this file
...              The test cases are intended to perform creation and deletion of groups.
Resource         device_group.resource
Resource	 ../generic_files/common.resource
Library          SeleniumLibrary
Test Setup	 Run Keywords
...		 KEY_LOGIN_TO_AIKAAN_DASHBOARD
...		 KEY_SKIP_HELP_TOUR
...		 KEY_CLICK_DGP_NAV_TAB
Test Teardown	Close Browser
Force Tags	 device_group

*** Variables ***
${DGP_NAME}    AutoEETest
${EDITED_DGP_NAME}   ${DGP_NAME}2EditNameText

*** Test Cases ***
DG_TC_001: Creation of Device Group
    [Tags]    smoke
    KEY_CREATE_DGP    ${DGP_NAME}

DG_TC_003: Search a Device Group
    [Tags]    smoke
    Wait Until Page Contains Element    id:dgp_search
    Click Element    id:dgp_search
    Input Text    id:dgp_search    ${DGP_NAME}
    Wait until Page Contains Element    id:dgp_table
    Table Should Contain    id:dgp_table    ${DGP_NAME}

DG_TC_004: Edit Device Group
    [Tags]    sanity
    KEY_CREATE_DGP    ${DGP_NAME}2
    KEY_CLICK_EDIT_ICON_AND_UPDATE    ${DGP_NAME}2
    KEY_VALIDATE_UPDATION    ${EDITED_DGP_NAME}    EditDescription
    KEY_DELETE_DG  ${EDITED_DGP_NAME}

DG_TC_002: Deletion of Device Group
    [Tags]   smoke
    KEY_CLICK_DG_NAME    ${DGP_NAME}
    KEY_CLICK_DG_DELETE_ICON_AND_CONFIRM
    KEY_VALIDATE_DG_DELETION  ${DGP_NAME}
