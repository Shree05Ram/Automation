*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported SeleniumLibrary.
Library           SeleniumLibrary

*** Keywords ***
KEY_CLICK_CG_NAV_TAB
    Wait Until Page Contains Element    id:nav_customgroups
    Click Element    id:nav_customgroups

KEY_CLICK_CG_CREATE_BTN
    Wait Until Page Contains Element    id:custom_group_create_btn
    Click Button    id:custom_group_create_btn

KEY_ENTER_CG_NAME_AND_CLICK_NEXT_BTN
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Input Text       id:custom_group_name_input    ${CUSTOM_GROUP_NAME}
    Click Button    id:custom_group_create_next_btn

KEY_CLICK_CG_CREATE_BTN_AND_VALIDATE
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Click Button    id:custom_group_create_create_btn
    Page Should not Contain    ${CUSTOM_GROUP_NAME} already exists
    Wait Until Page Contains    ${CUSTOM_GROUP_NAME}
    Page Should Contain    ${CUSTOM_GROUP_NAME}

KEY_DELETE_CG
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Wait Until Page Contains    ${CUSTOM_GROUP_NAME}
    Click Link       ${CUSTOM_GROUP_NAME}
    KEY_CLICK_CG_DELETE_ICON_AND_CONFIRM
    KEY_VALIDATE_CG_DELETION    ${CUSTOM_GROUP_NAME}

KEY_CLICK_CG_DELETE_ICON_AND_CONFIRM
    Wait Until Page Contains Element    id:custom_group_delete_btn
    Click Button     id:custom_group_delete_btn
    Wait Until Page Contains Element    id:custom_group_delete_confirm_btn
    Click Button     id:custom_group_delete_confirm_btn

KEY_VALIDATE_CG_DELETION
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Wait until Page Contains Element    id:custom_groups_list_tbl
    Page Should not Contain    ${CUSTOM_GROUP_NAME}

KEY_ENTER_TAG_VAL_AND_CLICK_ADD_TAG
    Click Element    id:tag_value_input
    Input Text       id:tag_value_input    ${TAG_VALUE}                     #Enter a value
    Click Button     id:add_tag_btn                                         #Add tag button

KEY_ENTER_SEARCH_KEYWORD
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Wait Until Page Contains Element   id:dynamic_group_search_btn
    Click Element    id:dynamic_group_search_btn
    Input Text   id:dynamic_group_search_btn    ${CUSTOM_GROUP_NAME}

KEY_VALIDATE_SEARCH
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Wait Until Page Contains Element   id:custom_groups_list_tbl
    Table Should Contain    id:custom_groups_list_tbl    ${CUSTOM_GROUP_NAME}

KEY_CLICK_ON_CUSTOM_GROUP_NAME
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Wait Until Page contains Element    id:custom_group_${CUSTOM_GROUP_NAME}
    Click Element    id:custom_group_${CUSTOM_GROUP_NAME}

KEY_CLICK_ON_EDIT_ICON
    Wait Until Page Contains Element    id:dynamic_group_update_icon
    Click Button    id:dynamic_group_update_icon

KEY_CHANGE_NAME_AND_DESCRIPTION
    [Arguments]    ${EDITED_CUSTOM_GROUP_NAME}    ${EDITED_CUSTOM_GROUP_DESC}
    Wait Until Page Contains Element    id:edit_dynamic_group_name_input
    Input Text    id:edit_dynamic_group_name_input     ${EDITED_CUSTOM_GROUP_NAME}
    Input Text    id:edit_dynamic_group_description_input    ${EDITED_CUSTOM_GROUP_DESC}

KEY_CLICK_UPDATE_BTN_AND_VALIDATE
    [Arguments]    ${EDITED_CUSTOM_GROUP_NAME}    ${EDITED_CUSTOM_GROUP_DESC}
    Click Button    id:dynamic_group_update_btn
    Wait Until Page Contains   ${EDITED_CUSTOM_GROUP_NAME} 
    Page Should Contain    ${EDITED_CUSTOM_GROUP_NAME}
    Page Should Contain    ${EDITED_CUSTOM_GROUP_DESC}

