*** Settings ***
Documentation     A resource file with reusable keywords and variables.
...
...               The system specific keywords created here form our own
...               domain specific language. They utilize keywords provided
...               by the imported SeleniumLibrary.
Library           SeleniumLibrary
Library           Process

*** Keywords ***
KEY_CLICK_APP_NAV_TAB
    Wait Until Page Contains Element    id:nav_apps
    Click Element    id:nav_apps

KEY_CLICK_APP_CREATE_BTN
    Wait Until Page Contains Element    css:.container > div:nth-child(1) > button:nth-child(1)    #id:app_create_btn
    Click Button    css:.container > div:nth-child(1) > button:nth-child(1)    #id:appcreate_btn

KEY_ENTER_APP_NAME_AND_DESC
    [Arguments]    ${APP_NAME}    ${APP_DESC}
    Input Text       id:app_name_input    ${APP_NAME}
    Input Text       id:app_description_input    ${APP_DESC}

KEY_UPLOAD_YAML_FILE
    Choose File    css:form.ui > span:nth-child(4)    app.yml
 
KEY_CLICK_APP_CREATE_BTN_AND_VALIDATE
    [Arguments]    ${APP_NAME}
    Click Button    id:app_create_create_btn
    Page Should not Contain    ${APP_NAME} already exists
    Wait Until Page Contains    ${APP_NAME}
    Page Should Contain    ${APP_NAME}

KEY_DELETE_APP
    [Arguments]    ${APP_NAME}
    Wait Until Page Contains    ${APP_NAME}
    KEY_CLICK_APP_DELETE_ICON_AND_CONFIRM
    KEY_VALIDATE_APP_DELETION    ${APP_NAME}

KEY_CLICK_APP_DELETE_ICON_AND_CONFIRM
    Wait Until Page Contains Element    id:app_delete_btn
    Click Button     id:app_delete_btn
    Wait Until Page Contains Element    id:app_delete_confirm_btn
    Click Button     id:app_delete_confirm_btn

KEY_VALIDATE_APP_DELETION
    [Arguments]    ${CUSTOM_GROUP_NAME}
    Wait until Page Contains Element    id:app_list_tbl
    Page Should not Contain    ${APP_NAME}
