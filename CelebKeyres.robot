*** Settings ***
Library           SeleniumLibrary
Library           OperatingSystem
Library           String
Library           Collections

*** Variables ***
${BROWSER}                chrome
${USER_NAME}              Abhay
${FRIEND_NAME}            Shiv
${TIMEOUT}                15
${SHORT_WAIT}             5
${INVALID}                @
${post}                   None
${SHARE_LINK}             None
${old_class}              None
${question_page_check}    None
${lang_test}              None
${PRIMARY_ALIAS}          Browser1
${INCOG_ALIAS}            Browser2

*** Keywords ***
# ----------------
# Browser setup
# ----------------
Open Primary Browser
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-popup-blocking
    Create WebDriver    Chrome    options=${options}    alias=${PRIMARY_ALIAS}
    Set Selenium Implicit Wait    0
    Go To    about:blank

Create Incognito
    ${options}=    Evaluate    selenium.webdriver.ChromeOptions()    modules=selenium.webdriver
    Call Method    ${options}    add_argument    --incognito
    Call Method    ${options}    add_argument    --start-maximized
    Call Method    ${options}    add_argument    --disable-extensions
    Call Method    ${options}    add_argument    --disable-popup-blocking
    Create WebDriver    Chrome    options=${options}    alias=${INCOG_ALIAS}
    Set Selenium Implicit Wait    0
    Go To    about:blank

Open Incognito Browser If Needed
    ${exists}=    Run Keyword And Return Status    Switch Browser    ${INCOG_ALIAS}
    Run Keyword If    not ${exists}    Create Incognito

Run Tests on Languages
    [Arguments]    ${URL}
    Log To Console   is ${URL} imported form the urls.csv file
    Open primary browser
    Log to Console   Running test on URL: ${URL}
    Switch Browser    ${PRIMARY_ALIAS}
    Go To    ${URL}
    Log To Console    Navigated to ${URL}
    Wait Until Element Is Visible    css:input[name="name"]    timeout=${TIMEOUT}
    Remove Ads
    Input Username
    Answer Questions Without Skip
    Sleep    5s
    Copy Share Link
    Open Incognito Browser If Needed
    Navigate To Accept Page
    Accept Valid Username
    Answer Questions Incognito
    Close All Browsers
    Force Garbage Collection

Force Garbage Collection
    Evaluate    import gc; gc.collect()

# ----------------
# Navigation
# ----------------
# Navigate To Homepage
#     Switch Browser    ${PRIMARY_ALIAS}
#     Go To    ${URL}
#     Log To Console    Navigated to {URL}
#     # Wait For SPA Idle
#     Wait Until Element Is Visible    css:input[name="name"]    timeout=${TIMEOUT}
#     Remove Ads

Navigate To Accept Page
    Should Not Be Equal    ${SHARE_LINK}    None
    Switch Browser    ${INCOG_ALIAS}
    Go To    ${SHARE_LINK}
    # Wait For SPA Idle
    Wait Until Element Is Visible    css:input[name="name"]    timeout=${TIMEOUT}
    Remove Ads

# ----------------
# Ad removal & helpers
# ----------------
Remove Ads
    # safe DOM ops, wrapped in try/catch to avoid JS exceptions
    Execute Javascript    try{document.querySelectorAll("ins, iframe, sticky-ad, .vpaid, .video-ad, .fullscreen-ad").forEach(x=>x.remove());}catch(e){}
    Execute Javascript    try{var b=document.getElementById("onesignal-slidedown-allow-button"); if(b){b.click();}}catch(e){}

# ----------------
# Click helpers
# ----------------
Safe Click
    [Arguments]    ${selector}
    TRY
        ${ok}=    Run Keyword And Return Status    Click Element    ${selector}
        Run Keyword If    ${ok}    Return From Keyword
    EXCEPT
    # Selenium click failed → try JS fallback
        ${clean}=    Evaluate    selector.replace("css:", "")    selector=${selector}
        ${clean_esc}=    Evaluate    clean.replace("'", "\\\\'")    clean=${clean}
        ${js}=    Catenate    SEPARATOR=\n
        ...    var s='${clean_esc}';
        ...    var el=document.querySelector(s);
        ...    if(el){ try{ el.click(); return true; } catch(e){ return false; } } else { return false; }
        ${js_ok}=    Execute Javascript    ${js}
        IF    not ${js_ok}
            Fail    Safe Click failed for selector ${selector}
        END
    END

Scroll And Click
    [Arguments]    ${selector}
    Wait Until Element Is Visible    ${selector}    timeout=${TIMEOUT}
    Execute Javascript    document.querySelector('${selector.replace("css:", "")}').scrollIntoView({block: 'center'});    
    Safe Click    ${selector}

# ----------------
# Input & form helpers
# ----------------
Input Username
    Wait Until Element Is Visible    css:input[name="name"]    timeout=${TIMEOUT}
    Clear Element Text    css:input[name="name"]
    Execute Javascript    document.querySelector('.primary-btn').scrollIntoView({block: 'center'});
    Input Text    css:input[name="name"]    ${USER_NAME}
    Scroll And Click    css:.primary-btn
    Sleep    ${TIMEOUT}
    # Wait For SPA Idle

# ----------------
# Answer flows (robust)
# ----------------
Question Page
    ${old_classes}=    Get Element Attribute    css:.primary-btn    class
    @{old_class_list}=    Split String    ${old_classes}

    # Example: let’s check for the 2nd class (index=1)
    ${old_class}=    Get From List    ${old_class_list}    0
    Log To Console   Old specific class: ${old_class}
    Set Suite Variable    ${old_class}

Answer Page
    ${old_classes}=    Get Element Attribute    css:.hint_btn    class
    @{old_class_list}=    Split String    ${old_classes}

    # Example: let’s check for the 2nd class (index=1)
    ${old_class}=    Get From List    ${old_class_list}    0
    Log To Console    Old specific class: ${old_class}
    Set Suite Variable    ${old_class}

Get Page Type From Url List
    [Arguments]    @{url_list}
    Log To Console    Checking URL parts: @{url_list}
    FOR    ${part}    IN    @{url_list}
        # check substring so 'question?quiz=123' will match
        ${is_question}=    Run Keyword And Return Status    Should Contain    ${part}    question
        IF    ${is_question}
            RETURN    question
        END
        ${is_answer}=    Run Keyword And Return Status    Should Contain    ${part}    answer
        IF    ${is_answer}
            RETURN    answer
        END
    END
    RETURN    none


Pre-Quiz Setup
    [Arguments]    ${max_attempts}=10    ${delay}=1s
    ${page_type}=    Set Variable    none

    FOR    ${i}    IN RANGE    1    ${max_attempts} + 1
        ${page_set}=    Get Location
        @{url_list}=    Split String    ${page_set}    /
        Log To Console    Attempt ${i}: URL parts: @{url_list}

        ${page_type}=    Get Page Type From Url List    @{url_list}
        Log To Console    Attempt ${i}: detected page_type=${page_type}

        IF    '${page_type}' != 'none'
            Log To Console    Detected page type: ${page_type} on attempt ${i}
            Exit For Loop
        END
        Sleep    ${delay}
    END

    IF    '${page_type}' == 'none'
        Fail    Could not detect page type from URL list after ${max_attempts} attempts
    END

    # Now handle the detected page type
    IF    '${page_type}' == 'question'
        Log To Console    On Question page
        Question Page
        Set Suite Variable    ${page_type}
        RETURN    ${page_type}
    ELSE IF    '${page_type}' == 'answer'
        Log To Console    On Answer page
        Answer Page
        Set Suite Variable    ${page_type}
        RETURN    ${page_type}
    END

Answer Questions Without Skip
    Remove Ads    
    Pre-Quiz Setup    
    ${counter}=    Set Variable    0

    WHILE    True
        Wait Until Page Contains Element    css:.${old_class}    ${TIMEOUT}
        ${counter}=    Evaluate    ${counter} + 1
        Log To Console    >>> answering question ${counter}
        Remove Ads
        Execute Javascript    document.querySelector('.option').scrollIntoView({block: 'center'});
        Sleep    1s
        ${safe_click_check}=    Run Keyword And Return Status    Element Should Be Visible    css:.option    
        Run Keyword If    '${safe_click_check}' == 'True'    Safe Click    css:.option:nth-child(1)
        Log To Console    Safe click status: ${safe_click_check}

        IF    ${safe_click_check}
            Log To Console    Clicked option successfully
        ELSE
            Log To Console    Failed to click option, retrying after short wait
            Sleep    ${SHORT_WAIT}
            ${page_check}=    Get Location
            @{page_list}=    Split String    ${page_check}    /
            ${page_value}=    Set Variable     ${page_list}[-1]
            # assuming URL structure is consistent
            Log To Console    Current page part: ${page_value}

            # check if we are still on question/answer page or moved to share/complete
            IF    '${page_value}' == 'share' or '${page_value}' == 'completed'
                Log To Console    Option changed to share page, exiting loop
                Exit For Loop
            ELSE IF    '${page_value}' == 'question' or '${page_value}' == 'answer'
                Log To Console    Still on question page, continuing loop
            END
        END
    END
    
    # decide final page type
    ${page_type}=    Handle Post-Quiz Page
    Log To Console    Final page type: ${page_type}
    IF    '${page_type}' == 'share'
        Copy Share Link
    ELSE IF    '${page_type}' == 'answer'
        Log to Console   Navigating to Complete page
        Handle Answer Page
    END

Answer Questions Incognito
    Wait Until Page Contains Element    css:.options    timeout=${TIMEOUT}
    ${res}=    Answer Questions Without Skip
    RETURN    ${res}

# ----------------
# Post-quiz handlers
# ----------------
Handle Post-Quiz Page
    Remove Ads
    Sleep     ${TIMEOUT}
    ${is_share}=    Run Keyword And Return Status    Page Should Contain Element    css:.copy-btn
    Log To Console    ${is_share} copy button found

    # check for Answer page button if not Share page
    IF    ${is_share}
        ${result}=    Set Variable    share
    ELSE
        Sleep    ${TIMEOUT}
        ${btn}=    Execute Javascript    return document.querySelectorAll('.primary-btn')[0];
        ${cop_btn}=    Run Keyword And Return Status    Page Should Contain Element    ${btn}
        IF    ${cop_btn}
            ${result}=    Set Variable    answer
        ELSE
            Fail    Neither Share page (copy button) nor Answer page (create new quiz) detected
        END
    END
    RETURN    ${result}

# ----------------
# Celeb Card & Share link
# ----------------

Celeb Verification
    Remove Ads
    ${celeb_url}=    Get Location
    Log To Console    Current URL: ${celeb_url}
    @{celeb_url_parts}=    Split String    ${celeb_url}    /
    Log To Console    URL parts: @{celeb_url_parts}

    #Two parts check whether the url is of correct celeb quiz or not
    ${celeb_check_1}=    Get From List    ${celeb_url_parts}    4
    Log To Console    Celeb check 1: ${celeb_check_1}
    ${celeb_check_2}=    Get From List    ${celeb_url_parts}    3
    Log To Console    Celeb check 2: ${celeb_check_2}
    ${celeb_check_3}=    Get From List    ${celeb_url_parts}    2
    Log To Console    Celeb check 3: ${celeb_check_3}
    # Log To Console    Celeb checks: ${celeb_check_1}, ${celeb_check_2}, ${celeb_check_3}

    ${status}=    Evaluate    "${celeb_check_3}" == "wowdare.xyz" and "${celeb_check_2}" == "${lang_test}" and "${celeb_check_1}" == "accept"
    Should Be True    ${status}    Not on correct celeb quiz accept page
    
Celeb Check
    Execute Javascript    return document.querySelector('.btn-sm-primary').scrollIntoView({block: 'center'});
    ${celeb_card_check}=    Run Keyword And Return Status    Page Should Contain Element    css:.btn-sm-primary

    # if celeb card present, click it
    IF     ${celeb_card_check}
        Log To Console    Celeb card found
        ${url}=    Get Location
        Log To Console    Current URL: ${url}
        ${test_url_part}=    Split String    ${URL}    /
        Log To Console    Test URL parts: @{test_url_part}
        ${lang_test}=    Get From List    ${test_url_part}    -2
        Log To Console    Language part from test URL: ${lang_test}
        Set Global Variable    ${lang_test}
        Safe Click    css:.btn-sm-primary
        Sleep    ${TIMEOUT}
        Switch Window    NEW
        Celeb Verification
    ELSE
        Log To Console    No celeb card found, continuing
    END

Copy Share Link
    Remove Ads
    Log To Console    Ads have been removed

    # check if celeb card present and handle it, if not then ignore and move ahead
    ${celeb_card}=    Run Keyword And Return Status    Get Webelement    css:.btn-sm-primary
    IF    not ${celeb_card}
        Log To Console    No celeb card present, skipping celeb check
        Skip
    ELSE
        Celeb Check
        Close Window
    END

    # now on share page, wait for copy button
    Sleep    3s
    Switch Window   
    Wait Until Element Is Enabled    css:.copy-btn    timeout=${TIMEOUT}
    Log To Console    Copy button is present and enabled
    Execute Javascript    document.querySelector('.copy-btn').scrollIntoView({block: 'center'});
    Log To Console    Copy button is in view
    Safe Click    css:.copy-btn
    Log To Console    Copy button clicked
    Wait Until Page Contains Element    css:.copied-info    timeout=${TIMEOUT}
    # pick the last .input (share field usually appears last)
    ${SHARE_LINK}=    Execute Javascript    return document.querySelector('.input').textContent.trim();
    Log To Console    Share link: ${SHARE_LINK}
    # Wait Until Keyword Succeeds    8x    1s    ${SHARE_LINK}     Fail     Invalid share link copied
    Should Not Be Empty    ${SHARE_LINK}
    Set Suite Variable    ${SHARE_LINK}
    Log To Console    Copied Link: ${SHARE_LINK}

Handle Answer Page
    ${NEW_QUIZ}=    Execute Javascript    return document.querySelectorAll('.primary-btn')[0] ? true : false;
    Run Keyword If    not ${NEW_QUIZ}    Fail    "New Quiz button not found!"

    # check if celeb card present and handle it, if not then ignore and move ahead
    ${celeb_card}=    Run Keyword And Return Status    Get Webelement    css:.btn-sm-primary
    IF    not ${celeb_card}
        Log To Console    No celeb card present, skipping celeb check
        Skip
    ELSE
        Celeb Check
        Close Window
    END
    
# ----------------
# Accept page / friend flow
# ----------------
Accept Username
    [Arguments]    ${friend}
    Clear Element Text    css:input[name="name"]
    Input Text    css:input[name="name"]    ${friend}
    Execute Javascript    document.querySelector('.primary-btn').scrollIntoView({block: 'center'});
    Scroll And Click    css:.primary-btn
    Sleep    ${TIMEOUT}

Accept Valid Username
    Accept Username    ${FRIEND_NAME}
    RETURN    ${FRIEND_NAME}
