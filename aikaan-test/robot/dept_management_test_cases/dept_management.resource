*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported SeleniumLibrary.
Library           SeleniumLibrary

*** Keywords ***
KEY_CLICK_USER_NAV_TAB
    Wait Until Page Contains Element    id:nav_user_dropdown
    Click Element    id:nav_user_dropdown
    Click Element    id:settings_btn

KEY_CLICK_DEPT_CREATE_BTN_AND_FILLUP_FORM
    [Arguments]    ${DEPT_NAME}
    Wait Until Page Contains    Create new department    timeout=10s
    Click Button     id:create_new_dept_btn
    Click Element    id:create_dept_name_input
    Input Text       id:create_dept_name_input    ${DEPT_NAME}

KEY_CLICK_CREATE_AND_VALIDATE_DEPT_CREATION
    [Arguments]    ${DEPT_NAME}
    Click Button   id:create_dept_create_btn
    Wait Until Page Contains    ${DEPT_NAME}
    Page Should Contain    ${DEPT_NAME}

KEY_CLICK_DEPT_DELETE_ICON_AND_CONFIRM
    [Arguments]    ${DEPT_NAME}
    Wait Until Page Contains     Create new department
    Scroll Element Into View    id:user_mgmt_section
    Wait Until Page Contains Element    id:dept_delete_btn_${DEPT_NAME}
    Click Button    id:dept_delete_btn_${DEPT_NAME}
    Click Button    id:dept_delete_confirm_btn
    Wait Until Page Does Not Contain    ${DEPT_NAME}
    Page Should Not Contain    ${DEPT_NAME}
