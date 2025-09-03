*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${chrome}        chrome
${URL}           https://alldares.me/en
${name}          Abhay
${friend_name}   Shiv
${timeout}       5
${Invalid}       @
${link}          https://alldares.me/en/share/lp0Qj

*** Test Cases ***
Homepage Test
    Create WebDriver With Chrome Options
    Navigate To Homepage
    Sleep    5
    View Homepage
    Close Browser

Username Input Test (User)
    Create WebDriver With Chrome Options
    Navigate To Homepage
    Blank Username And Submit
    Sleep    2
    Clear Input Text
    Invalid Username And Submit
    Sleep    2
    Clear Input Text
    Fill Username And Submit
    Sleep    2
    Wait Until Page Contains Element    class:skip
    Close Browser

Skip Button at Question Page
    Create WebDriver With Chrome Options
    Question Page With Skip Button
    Close Browser

Question Page
    Create WebDriver With Chrome Options
    Question Page without skip button
    Close Browser

Share Page with Link Copy
    Create WebDriver With Chrome Options
    Share Link Copy

Accept Page
    Create WebDriver With Incognito Chrome Options
    Navigate To Accept Page
    Sleep    5
    Close Browser

Username Input Test (Friend)
    Create WebDriver With Incognito Chrome Options
    Navigate To Accept Page
    Clear Input Text
    Accept Username Blank
    Sleep    2
    Accept Username Invalid
    Sleep    2
    Clear Input Text
    Accept Username Valid
    Sleep    2
    Wait Until Page Contains Element    class:hint_sec
    Close Browser

# Answer Page with Hint
#     Create WebDriver With Incognito Chrome Options
#     Hint Reject
#     Hint Accept
#     Close Browser

Answer Page
    Create WebDriver With Incognito Chrome Options
    Accept Username Valid
    Answer Page Incog
    Close Browser

Complete Page
    Create WebDriver With Incognito Chrome Options
    Complete Page Incog
    Close Browser

View Scoreboard
    Switch Browser    Browser1
    Sleep    2
    Scoreboard

View-Answer Page
    Switch Browser    Browser1
    Reload Page
    View-Answer User
    Close Browser

*** Keywords ***
Create WebDriver With Chrome Options
    ${chrome_options}=    Evaluate    selenium.webdriver.ChromeOptions()
    Call Method    ${chrome_options}    add_argument    --start-maximized
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-popup-blocking
    Create WebDriver    Chrome    options=${chrome_options}    alias=Browser1

Create WebDriver With Incognito Chrome Options
    ${chrome_options}=    Evaluate    selenium.webdriver.ChromeOptions()
    Call Method    ${chrome_options}    add_argument    --incognito
    Call Method    ${chrome_options}    add_argument    --start-maximized
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --disable-popup-blocking
    Create WebDriver    Chrome    options=${chrome_options}    alias=Browser2

Navigate To Homepage
    Go To    ${URL}

Refresh Browser
    Execute Javascript    window.location.reload()

Remove Ins Tags
    Execute Javascript    document.querySelectorAll("ins")?.forEach(ad => ad?.remove());

Video Ad Remove
    ${ad}=    Execute Javascript    document.querySelector(".ad-video");
    ${ad_class}=      Run Keyword If    ${ad} is not None    Execute Javascript    return document.querySelector(".ad-video").className;
    Log To Console    ${ad_class}
    IF    ${ad_class} == 'ad-video'
        Execute Javascript    document.getElementsByClassName('rewardCloseButton').click();
        Sleep    30
    ELSE
        Sleep    25
    END

One Signal Remove
    Execute Javascript    document.getElementById("onesignal-slidedown-allow-button")?.click();

Vignette Ads Remove
    Execute Javascript    document.querySelector("ins[data-vignette-loaded]")?.remove();

Remove Sticky Ads
    Execute Javascript    document.querySelector("sticky-ad")?.forEach(ad => ad?.remove());

Score Button
    Execute Javascript    document.querySelectorAll(".primary-btn")[2].click();

Clear Input Text
    Clear Element Text    name:name

View Homepage
    Execute Javascript    document.querySelector(".input").scrollIntoView({behavior: 'smooth', block: 'center'});
    ${input}=    Execute Javascript    return document.querySelectorAll(".input")[0];
    Wait Until Page Contains Element    ${input}

Input Username
    Navigate To Homepage
    Sleep    5
    Remove Ins Tags
    One Signal Remove
    Remove Sticky Ads
    Wait Until Page Contains Element    class:input    timeout=${timeout}.
    Remove Ins Tags
    Remove Sticky Ads
    Log To Console    1st Try
    Remove Sticky Ads
    Log To Console    scroll started
    Scroll Element Into View    class:primary-btn
    Sleep    2
    Remove Sticky Ads
    Execute Javascript    window.scrollBy(0, 400)
    # Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Log To Console    scroll ended

Fill Username And Submit
    Input Username
    Remove Ins Tags
    Remove Sticky Ads
    Input Text    name:name    ${name}
    Remove Ins Tags
    Remove Sticky Ads
    Click Link    class:primary-btn

Blank Username and Submit
    Input Username
    Remove Ins Tags
    Remove Sticky Ads
    One Signal Remove
    Input Text    name:name    ${EMPTY}
    Remove Ins Tags
    One Signal Remove
    Remove Sticky Ads
    Wait Until Element Is Visible    class:primary-btn
    Click Link    class:primary-btn

Invalid Username and Submit
    Input Username
    Remove Ins Tags
    Remove Sticky Ads
    Input Text    name:name    ${Invalid}
    Remove Ins Tags
    Remove Sticky Ads
    Wait Until Element Is Visible    class:primary-btn
    Click Link    class:primary-btn

Question Page with skip button
    Fill Username And Submit
    Sleep    2
    Wait Until Page Contains Element    class:skip
    Sleep    2
    Remove Ins Tags
    Sleep    2
    Execute Javascript    document.querySelector(".skip").click();
    Sleep    2

Question Page without skip button
    Fill Username And Submit
    Sleep    5
    Execute Javascript    document.querySelector(".skip").scrollIntoView({behavior: 'smooth', block: 'center'});
    FOR    ${i}    IN RANGE    1    16
        Remove Ins Tags
        One Signal Remove
        Execute Javascript    document.querySelector(".options").scrollIntoView({block: 'center'});
        Sleep    1
        Click Element    css:.option:nth-child(1)
        Sleep    2
    END
    Sleep    5
    Wait Until Page Contains Element    class:copy-btn

Share Link Copy
    Question Page Without Skip Button
    Sleep    5
    Remove Ins Tags
    Vignette Ads Remove
    Remove Sticky Ads
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Remove Sticky Ads
    Click Element    class:copy-btn
    Log To Console    ${link}
    ${link}=    Get Text    class:input
    Log To Console    ${link}
    Wait Until Page Contains Element    class:copied-info
    Sleep    3
    Set Global Variable    ${link}

Navigate to Accept Page
    Log To Console    ${link}
    Go To    ${link}
    # Log To Console    ${share_link}
    # Go To    ${share_link}

Input Friend Username
    Navigate To Accept Page
    Sleep    5
    Remove Ins Tags
    One Signal Remove
    Vignette Ads Remove
    Wait Until Page Contains Element    class:input    timeout=${timeout}
    Remove Sticky Ads
    # ${btn_sel}=   Set Variable    ".primary-btn"
    Sleep    2
    Remove Sticky Ads
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Sleep    3

Accept Username Blank
    Input Friend Username
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Input Text    class:input    ${EMPTY}
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Click Link    class:primary-btn

Accept Username Invalid
    Input Friend Username
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Input Text    class:input    ${invalid}
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Click Link    class:primary-btn

Accept Username Valid
    Input Friend Username
    # Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Input Text    class:input    ${friend_name}
    # Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Click Link    class:primary-btn
    Set Global Variable    ${friend_name}
    RETURN    ${friend_name}

Hint Reject
    Input Friend Username
    Accept Username Valid
    Sleep    5
    Scroll Element Into View    class:hint_btn
    Click Button    class:hint_btn
    Sleep    1
    Click Button    class:cancel_gif_btn
    Sleep    2
    Wait Until Page Contains Element    class:hint_btn

Hint Accept
    Scroll Element Into View    class:hint_btn
    Click Button    class:hint_btn
    Sleep    1
    Click Button    class:primary-btn
    Sleep    10
    Remove Ins Tags    
    Video Ad Remove
    Sleep    2
    ${hint}=    Execute Javascript    document.querySelector(".option disabled-ans).className;
    Log To Console    ${hint}
    IF    ${hint} == 'option disabled-ans'
        Log To Console    Hint Accepted
    END
    # Wait Until Page Contains Element    css:.option:nth-child(1)
    Sleep    2

Answer Page Incog
    Input Friend Username
    Accept Username Valid
    Sleep    5
    Execute Javascript    document.querySelector(".options").scrollIntoView({block: 'center'});
    FOR    ${i}    IN RANGE    1    16
        Remove Ins Tags
        One Signal Remove
        Execute Javascript    document.querySelector(".options").scrollIntoView({block: 'center'});
        Click Element    css:.option:nth-child(1)
        Sleep    2
    END
    Sleep    5
    Remove Ins Tags
    Vignette Ads Remove
    Remove Sticky Ads
    Wait Until Page Contains Element    class:primary-btn

Verify Input Content
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Sleep    3
    ${text}=    Get Text    class:input
    IF    '${text}' == '${friend_name}'
        Log To Console    "Strings are equal: ${text}"
    ELSE
        Log To Console    "Strings differ: ${text} != ${friend_name}"
    END

Check Next Page
    ${input_exists}=    Run Keyword And Return Status    Execute Javascript    return document.querySelector('.input') !== null
    Run Keyword If    ${input_exists}    Verify Input Content
    ...    ELSE    Fail    "Neither step16 nor input element found"

Complete Page Incog
    Answer Page Incog
    Sleep    3
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Sleep    3
    ${click_success}=    Run Keyword And Return Status    Execute Javascript    document.querySelector(".primary-btn").click();
    Run Keyword If    not ${click_success}    Log To Console    "Initial step16 click failed"
    ${step16_exists}=    Run Keyword And Return Status    Execute Javascript    return document.querySelector(".primary-btn") !== null
    Run Keyword If    ${step16_exists}    Log To Console    CLick Link with Id as Step 16
    ...    ELSE    Check Next Page
#     Execute Javascript    document.getElementById('step16').click();
#     ${step16_exists}=    Run Keyword And Return Status    Execute Javascript    return document.querySelector('.step16') !== null
#     Run Keyword If    ${step16_exists}    Click Element    class:step16
# ...    ELSE    Execute Javascript    return document.querySelector('.input') !== null
#     Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
#     ${text}=    Get Text    class:input
#     IF    '${text}' == '${friend_name}'
#         Log To Console    "Strings are equal"
#     END
#     Sleep    2
#     Sleep    4
#     Vignette Ads Remove
#     Reload Page
#    Sleep    2
#     Execute Javascript    document.getElementById('step16').click();
#     Vignette Ads Remove
#     Log To Console    "create new Quiz"
#     Sleep    5
#     Log To Console    "page open"
    # Wait Until Page Contains Element    class:input
    # Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    # ${text}=    Get Text    class:input
    # IF    '${text}' == '${friend_name}'
    #     Log To Console    "Strings are equal"
    # END
    # Sleep    2

Scoreboard
    Vignette Ads Remove
    Reload Page
    Sleep    5
    Remove Ins Tags
    Remove Sticky Ads
    Execute Javascript    document.querySelector(".v-ans").scrollIntoView({block: 'center'});
    Sleep    3
    Remove Ins Tags
    Remove Sticky Ads
    Wait Until Element Is Visible    class:v-ans
    Execute Javascript    document.getElementsByClassName('v-ans')[0].click();
    Sleep    4
    Video Ad Remove
    # Sleep    20
    Remove Ins Tags
    Remove Sticky Ads
    Wait Until Page Contains Element    class:result
    Execute Javascript    document.querySelector(".result").scrollIntoView({block: 'center'});
    Sleep    3

View-Answer User
    Vignette Ads Remove
    Execute Javascript    document.querySelector(".result").scrollIntoView({block: 'center'});
    Execute Javascript    document.querySelectorAll('.top-3.rank-scoreboard-section span')[2].click();
    # Sleep    20
#    Reload Page
#    Sleep    2
#    Scroll Selector    ".result"
#    Execute Javascript    document.getElementsByClassName('scoreItem')[0].click();
    # Sleep    8
    Remove Ins Tags
    Wait Until Page Contains Element    class:view-answer
    Reload Page
    Sleep    2
    Remove Ins Tags
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Sleep    2
    Log To Console    scroll complete
    Log To Console    click initiated
    Execute Javascript    document.getElementsByClassName('primary-btn')[0].click();
    Sleep    2
    ${new_url}=    Execute Javascript    return window.location.href;
    Log To Console    ${new_url}
    Log To Console    ads present
    Vignette Ads Remove
    Reload Page
    Log To Console    ads removed
    Sleep    3
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({block: 'center'});
    Sleep    2
    Execute Javascript    document.getElementsByClassName('primary-btn')[0].click();
    Sleep    2
    Log To Console    land on scoreboard
    Remove Ins Tags
    Remove Sticky Ads
    # Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    # Execute Javascript    document.getElementsByClassName('primary-btn')[0].click();
    # Sleep    3
    # Vignette Ads Remove
    # Remove Ins Tags
    Wait Until Page Contains Element    id:link
    ${text}=    Get Text    id:link
    Log To Console    ${text}
    IF    '${text}' == '${link}'
        Log To Console    "Strings are equal"
    END
