*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           String

*** Variables ***
${BROWSER}        chrome
${URL}            https://2025.bfftest.xyz/en
${USER_NAME}      Abhay
${FRIEND_NAME}    Shiv
${TIMEOUT}        10
${INVALID}        @
${SHARE_LINK}     None
${PRIMARY_ALIAS}  Browser1
${INCOG_ALIAS}    Browser2

*** Keywords ***
Open Primary Browser
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-popup-blocking
    Create WebDriver    Chrome    options=${options}    alias=${PRIMARY_ALIAS}
    Set Selenium Implicit Wait    0
    Go To    about:blank

Open Incognito Browser If Needed
    ${exists}=    Run Keyword And Return Status    Switch Browser    ${INCOG_ALIAS}
    Run Keyword If    not ${exists}    Create Incognito

Create Incognito
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --incognito
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-popup-blocking
    Create WebDriver    Chrome    options=${options}    alias=${INCOG_ALIAS}
    Set Selenium Implicit Wait    0
    Go To    about:blank

Navigate To Homepage
    Switch Browser    ${PRIMARY_ALIAS}
    Go To    ${URL}
    Wait For Page Ready
    Wait Until Page Contains Element    css:input[name="name"]    timeout=${TIMEOUT}
    Remove Ads

Remove Ads
    Execute Javascript    try{document.querySelectorAll("ins").forEach(x=>x.remove())}catch(e){}
    Execute Javascript    try{document.querySelectorAll("sticky-ad").forEach(x=>x.remove())}catch(e){}
    Execute Javascript    try{var el=document.querySelector('ins[data-vignette-loaded]'); if(el){el.remove();}}catch(e){}
    Execute Javascript    try{var b=document.getElementById("onesignal-slidedown-allow-button"); if(b){b.click();}}catch(e){}

Scroll And Click
    [Arguments]    ${selector}
    Wait Until Element Is Visible    ${selector}    ${TIMEOUT}
    Scroll Element Into View    ${selector}
    Safe Click    ${selector}

Safe Click
    [Arguments]    ${selector}
    ${status}=    Run Keyword And Return Status    Wait Until Keyword Succeeds    3x    1.5s    Click Element    ${selector}
    IF    not ${status}
        ${clean}=    Evaluate    "${selector}".replace("css:","")
        ${clean_esc}=    Evaluate    "${clean}".replace("'", "\\'")
        Execute Javascript    var el=document.querySelector('${clean_esc}'); if(el){ try{ el.click(); } catch(e){} }
    END

Wait For Page Ready
    Wait Until Keyword Succeeds    10x    0.5s    Wait For Condition    return document.readyState === 'complete'

Input Username
    Navigate To Homepage
    Wait Until Element Is Visible    css:input[name="name"]    ${TIMEOUT}
    Clear Element Text    css:input[name="name"]
    Input Text    css:input[name="name"]    ${USER_NAME}
    Scroll And Click    css:.primary-btn
    Wait For Page Ready

Input Blank Username
    Navigate To Homepage
    Clear Element Text    css:input[name="name"]
    Input Text    css:input[name="name"]    ${EMPTY}
    Scroll And Click    css:.primary-btn

Input Invalid Username
    Navigate To Homepage
    Clear Element Text    css:input[name="name"]
    Input Text    css:input[name="name"]    ${INVALID}
    Scroll And Click    css:.primary-btn

Copy Button Not Visible
    ${status}=    Run Keyword And Return Status    Page Should Contain Element    css:.copy-btn
    ${result}=    Evaluate    not ${status}
    RETURN    ${result}

Answer Questions Without Skip
    Wait Until Page Contains Element    css:.options    timeout=${TIMEOUT}
    ${continue}=    Copy Button Not Visible
    WHILE    ${continue}
        Remove Ads
        ${has_option}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:.option:nth-child(1)    3s
        IF    ${has_option}
            Safe Click    css:.option:nth-child(1)
            Sleep    0.5s
        ELSE
            Sleep    1s
        END
        ${continue}=    Copy Button Not Visible
    END
    ${page_type}=    Handle Post-Quiz Page
    RETURN    ${page_type}

Handle Post-Quiz Page
    ${is_share}=    Run Keyword And Return Status    Page Should Contain Element    css:.copy-btn
    IF    ${is_share}
        ${result}=    Set Variable    share
    ELSE
        ${btn}=    Execute Javascript    return document.querySelectorAll('.primary-btn')[0];
        IF    '${btn}' != 'None'
            ${result}=    Set Variable    answer
        ELSE
            Fail    Neither Share page (.copy-btn) nor Answer page (.primary-btn[0]) detected
        END
    END
    RETURN    ${result}

Copy Share Link
    Remove Ads
    Wait Until Page Contains Element    css:.copy-btn    timeout=${TIMEOUT}
    Execute Javascript    document.querySelector('.copy-btn').scrollIntoView({block: 'center'});
    Safe Click    css:.copy-btn
    Wait Until Page Contains Element    css:.copied-info    timeout=${TIMEOUT}
    ${SHARE_LINK}=    Execute Javascript    return document.querySelector('.input').value || document.querySelector('.input').textContent;
    Should Not Be Empty    ${SHARE_LINK}
    Set Global Variable    ${SHARE_LINK}
    Log To Console    Copied Link: ${SHARE_LINK}

Navigate To Accept Page
    Should Not Be Equal    ${SHARE_LINK}    None
    Go To    ${SHARE_LINK}
    Wait For Page Ready
    Wait Until Page Contains Element    css:input[name="name"]    timeout=${TIMEOUT}
    Remove Ads

Accept Username
    [Arguments]    ${friend}
    Clear Element Text    css:input[name="name"]
    Input Text    css:input[name="name"]    ${friend}
    Scroll And Click    css:.primary-btn
    Wait For Page Ready

Accept Blank Username
    Accept Username    ${EMPTY}

Accept Invalid Username
    Accept Username    ${INVALID}

Accept Valid Username
    Accept Username    ${FRIEND_NAME}
    RETURN    ${FRIEND_NAME}

Answer Questions Incognito
    Wait Until Page Contains Element    css:.options    timeout=${TIMEOUT}
    ${page_type}=    Answer Questions Without Skip
    RETURN    ${page_type}

Handle Answer Page
    ${NEW_QUIZ}=    Execute Javascript    return document.querySelectorAll('.primary-btn')[0];
    Run Keyword If    '${NEW_QUIZ}' == 'None'    Fail    "New Quiz button not found!"
    Execute Javascript    document.querySelectorAll('.primary-btn')[0].scrollIntoView({block: 'center'});
    Safe Click    css:.primary-btn
    Log To Console    New Quiz button clicked

Verify Scoreboard
    Wait Until Page Contains Element    css:.v-ans    timeout=${TIMEOUT}
    Scroll And Click    css:.v-ans
    Wait Until Page Contains Element    css:.result    timeout=${TIMEOUT}
    Log To Console    Scoreboard verified
