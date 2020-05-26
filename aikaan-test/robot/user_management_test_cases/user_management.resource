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

KEY_CLICK_USER_CREATE_BTN
    Wait Until Page Contains    Create new users
    Click Button    id:create_new_user_btn

KEY_SELECT_USER_AND_ACCOUNT_TYPE
    Wait Until Page Contains    Account type
    Click Element    id:user_type_dropdown
    Click Element    id:user_create_creation_type_single
    Click Element    id:account_type_dropdown
    Click Element    id:user_create_account_type_aicon
    
KEY_CLICK_NEXT_AND_FILLUP_FORM
    [Arguments]     ${USER_NAME}    ${MAIL_ID}    ${PASSWORD}
    Click Element    id:create_user_step_1_next_btn
    Click Element    id:create_user_name_input
    Input Text       id:create_user_name_input    ${USER_NAME}
    Click Element    id:create_user_email_input
    Input Text       id:create_user_email_input    ${MAIL_ID}
    Click Element    id:create_user_password_input
    Input Text       id:create_user_password_input    ${PASSWORD}
    Click Element    id:create_user_confirm_password_input
    Input Text       id:create_user_confirm_password_input    ${PASSWORD}
    Click Element    id:create_user_department_dropdown
    Click Element    id:create_user_dept_0
    Click Element    id:create_user_role_dropdown
    Click Element    id:create_user_role_Admin

KEY_CLICK_CREATE_AND_VALIDATE_USER_CREATION
    [Arguments]    ${USER_NAME}
    Click Element     id:create_user_create_btn
    Wait Until Page Contains Element    id:users_list_tbl
    Table Should Contain    id:users_list_tbl    ${USER_NAME}

KEY_CLICK_USER_DELETE_ICON_AND_CONFIRM
    [Arguments]    ${MAIL_ID}
    Wait Until Page Contains Element    id:user_delete_btn_${MAIL_ID}
    Click Element    id:user_delete_btn_${MAIL_ID}
    Wait Until Page Contains Element    id:user_delete_confirm_btn
    Click Button    id:user_delete_confirm_btn

KEY_VALIDATE_USER_DELETION
    [Arguments]    ${MAIL_ID}
    Wait Until Page Does Not Contain    ${MAIL_ID}
    Page Should Not Contain    ${MAIL_ID}
