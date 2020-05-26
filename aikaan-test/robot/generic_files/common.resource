*** Settings ***
Variables	env_variables.py
Library		SeleniumLibrary

*** Variables ***
${BASE_URL}	https://${SERVER_ENV}/
${LOGIN_URL}	${BASE_URL}login

*** Keywords ***
KEY_LOGIN_TO_AIKAAN_DASHBOARD
	Open Browser	${LOGIN_URL}	${BROWSER_ENV}
	Set Selenium Speed	${SPEED_ENV}
	Click Element	login_email
	Input Text	login_email	${EMAIL_ENV}
	Click Element	login_password
	Input Text	login_password    ${PASSWORD_ENV}
	Click Button	login_button
	Wait Until Page Contains	Hello! Welcome to AiKaan dashboard
	Location Should Be	${BASE_URL}

KEY_SKIP_HELP_TOUR
    Wait Until Page Contains Element    css:.react-joyride__tooltip > div:nth-child(2) > div:nth-child(1) > button:nth-child(1)
    Click Element    css:.react-joyride__tooltip > div:nth-child(2) > div:nth-child(1) > button:nth-child(1)
