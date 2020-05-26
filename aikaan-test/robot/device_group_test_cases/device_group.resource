*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${TIMEOUT}    10s

*** Keywords ***
KEY_CLICK_DGP_NAV_TAB
    Wait Until Page Contains Element   id:nav_dgp
    Click Element   id:nav_dgp

KEY_CLICK_DG_CREATE_BTN
    Wait Until Page Contains Element    id:dgp_create
    Click Button    id:dgp_create

KEY_ENTER_DG_NAME_AND_CLICK_SAVE_BTN
    [Arguments]    ${DGP_NAME}
    Input Text      id:dgp_name    ${DGP_NAME}
    Click Button    id:dgp_save

KEY_VALIDATE_DG_CREATION
    [Arguments]    ${DGP_NAME}
    Page Should Not Contain    Profile Name ${DGP_NAME} already exists
    Wait Until Page Contains    ${DGP_NAME}    timeout=${TIMEOUT}
    Page Should Contain    ${DGP_NAME}

KEY_CREATE_DGP
    [Arguments]    ${DGP_NAME}
    KEY_CLICK_DG_CREATE_BTN
    KEY_ENTER_DG_NAME_AND_CLICK_SAVE_BTN    ${DGP_NAME}
    KEY_VALIDATE_DG_CREATION    ${DGP_NAME}

KEY_CLICK_EDIT_ICON_AND_UPDATE
    [Arguments]    ${DGP_NAME}
    Wait Until Page Contains    ${DGP_NAME}    timeout=${TIMEOUT}
    Click Element    id:dgp_${DGP_NAME}
    Wait Until Page Contains Element    id:edit_dgp_icon
    Click Button    id:edit_dgp_icon
    Click Element    id:edit_dgp_name_input
    Input Text    id:edit_dgp_name_input    ${DGP_NAME}EditNameText
    Click Element    id:edit_dgp_desc_input
    Input Text    id:edit_dgp_desc_input    EditDescription
    Click Button    id:edit_dgp_update_btn

KEY_VALIDATE_UPDATION
    [Arguments]    ${EDITED_DGP_NAME}     ${EDITED_DGP_DESC}
    Wait Until Page Contains    ${EDITED_DGP_NAME}    timeout=${TIMEOUT}
    Page Should Contain    ${EDITED_DGP_NAME}
    Page Should Contain    ${EDITED_DGP_DESC}

KEY_DELETE_DG
    [Arguments]    ${EDITED_DGP_NAME}
    KEY_CLICK_DG_DELETE_ICON_AND_CONFIRM
    KEY_VALIDATE_DG_DELETION    ${EDITED_DGP_NAME}

KEY_CLICK_DG_NAME
    [Arguments]    ${DGP_NAME}
    Wait until Page Contains    ${DGP_NAME}    timeout=${TIMEOUT}
    Click Link      ${DGP_NAME}

KEY_CLICK_DG_DELETE_ICON_AND_CONFIRM
    Wait Until Page Contains Element    id:dgp_delete
    Click Button    id:dgp_delete
    Click Button    id:dgp_delete_yes

KEY_VALIDATE_DG_DELETION
    [Arguments]   ${DGP_NAME}
    Wait Until Page Does Not Contain    ${DGP_NAME}    timeout=${TIMEOUT}
    Page Should Not Contain    ${DGP_NAME}