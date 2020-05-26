*** Settings ***
Documentation    All the Custom Group feature related test cases are present in this file
...
...              The test cases are inteded to perform creation, updation and deleteion of groups.
Resource         custom_group.resource
Resource         ../generic_files/common.resource
Library          SeleniumLibrary
Test Setup	Run Keywords
...		KEY_LOGIN_TO_AIKAAN_DASHBOARD
...		KEY_SKIP_HELP_TOUR
...		KEY_CLICK_CG_NAV_TAB
Test Teardown	Close Browser
Force Tags       custom_group

*** Variables ***
${CUSTOM_GROUP_NAME}    AutoTestCustomGroup
${EDITED_CUSTOM_GROUP_NAME}    New${CUSTOM_GROUP_NAME}
${EDITED_CUSTOM_GROUP_DESC}    NewDescription
${TAG_KEY}		TestTagKey1
${TAG_VALUE}            TestTagVal1

*** Test Cases ***
CG_TC_001: Creation of Custom Group without Tags
    [Tags]    smoke
    KEY_CLICK_CG_CREATE_BTN
    KEY_ENTER_CG_NAME_AND_CLICK_NEXT_BTN    ${CUSTOM_GROUP_NAME}1
    KEY_CLICK_CG_CREATE_BTN_AND_VALIDATE    ${CUSTOM_GROUP_NAME}1

CG_TC_002: Deletion of Custom Group
    [Tags]    smoke
    KEY_DELETE_CG	${CUSTOM_GROUP_NAME}1

CG_TC_003: Creation of Custom Group with existing Tags
    [Tags]    sanity
    KEY_CLICK_CG_CREATE_BTN
    KEY_ENTER_CG_NAME_AND_CLICK_NEXT_BTN    ${CUSTOM_GROUP_NAME}1
    Click Element    id:tag_key_dropdown                                   #Click on the tag key dropdown
    Click Element    id:tagkey_device_type_option                          #Select a tag key from the dropdown list
    KEY_ENTER_TAG_VAL_AND_CLICK_ADD_TAG
    KEY_CLICK_CG_CREATE_BTN_AND_VALIDATE    ${CUSTOM_GROUP_NAME}1

CG_TC_004: Creation of Custom Group with new Tags
    [Tags]    sanity
    KEY_CLICK_CG_CREATE_BTN
    KEY_ENTER_CG_NAME_AND_CLICK_NEXT_BTN    ${CUSTOM_GROUP_NAME}2
    Click Element   id:tag_key_dropdown
    Input Text      css:\#tag_key_dropdown > input    ${TAG_KEY}           #Click on the tag key dropdown and enter new key
    KEY_ENTER_TAG_VAL_AND_CLICK_ADD_TAG
    KEY_CLICK_CG_CREATE_BTN_AND_VALIDATE    ${CUSTOM_GROUP_NAME}2

CG_TC_005: Search a Custom Group
    [Tags]    smoke
    KEY_ENTER_SEARCH_KEYWORD    ${CUSTOM_GROUP_NAME}1
    KEY_VALIDATE_SEARCH    ${CUSTOM_GROUP_NAME}1

CG_TC_007: Edit a Custom Group
    [Tags]    sanity
    KEY_CLICK_ON_CUSTOM_GROUP_NAME    ${CUSTOM_GROUP_NAME}1
    KEY_CLICK_ON_EDIT_ICON
    KEY_CHANGE_NAME_AND_DESCRIPTION    ${EDITED_CUSTOM_GROUP_NAME}    ${EDITED_CUSTOM_GROUP_DESC}
    KEY_CLICK_UPDATE_BTN_AND_VALIDATE    ${EDITED_CUSTOM_GROUP_NAME}    ${EDITED_CUSTOM_GROUP_DESC}

Deletion of created Custom Groups
    [Tags]    sanity
    KEY_DELETE_CG	${EDITED_CUSTOM_GROUP_NAME}
    KEY_DELETE_CG	${CUSTOM_GROUP_NAME}2

