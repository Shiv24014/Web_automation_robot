*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${chrome}        chrome
${URL}           https://wowdare.xyz/en
${name}          Abhay
${friend_name}   Shiv
${timeout}       5
${Invalid}       @
${link}          https://wowdare.xyz/en/share/lp0Qj

*** Test Cases ***
# Homepage Test
#     Create WebDriver With Chrome Options
#     Navigate To Homepage
#     Sleep    5
#     View Homepage
#     Close Browser

# Username Input Test (User)
#     Create WebDriver With Chrome Options
#     Navigate To Homepage
#     Blank Username And Submit
#     Sleep    2
#     Clear Input Text
#     Invalid Username And Submit
#     Sleep    2
#     Clear Input Text
#     Fill Username And Submit
#     Sleep    2
#     Wait Until Page Contains Element    class:skip
#     Close Browser

# Skip Button at Question Page
#     Create WebDriver With Chrome Options
#     Question Page With Skip Button
#     Close Browser

# Question Page
#     Create WebDriver With Chrome Options
#     Question Page without skip button
#     Close Browser

Share Page with Link Copy
    Create WebDriver With Chrome Options
    Share Link Copy

# Accept Page
#     Create WebDriver With Incognito Chrome Options
#     Navigate To Accept Page
#     Sleep    5
#     Close Browser

# Username Input Test (Friend)
#     Create WebDriver With Incognito Chrome Options
#     Navigate To Accept Page
#     Clear Input Text
#     Accept Username Blank
#     Sleep    2
#     Accept Username Invalid
#     Sleep    2
#     Clear Input Text
#     Accept Username Valid
#     Sleep    2
#     Wait Until Page Contains Element    class:hint_sec
#     Close Browser

# Answer Page with Hint
#     Create WebDriver With Incognito Chrome Options
#     Hint Reject
#     Hint Accept
#     Close Browser

# Answer Page
#     Create WebDriver With Incognito Chrome Options
#     Accept Username Valid
#     Answer Page Incog
#     Close Browser

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
    Execute Javascript    document.querySelectorAll(".ad-video")?.forEach(ad => ad?.remove());

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
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
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
    Input Text    name:name    ${EMPTY}
    Remove Ins Tags
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
    Wait Until Page Contains Element    class:skip
    Sleep    2
    Remove Ins Tags
    Execute Javascript    document.getElementsByClassName("skip")[0].click();
    Sleep    2

Question Page without skip button
    Fill Username And Submit
    Sleep    5
    Execute Javascript    document.querySelector(".skip").scrollIntoView({behavior: 'smooth', block: 'center'});
    FOR    ${i}    IN RANGE    1    16
        Remove Ins Tags
        One Signal Remove
        Execute Javascript    document.querySelector(".options").scrollIntoView({behavior: 'smooth', block: 'center'});
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

Input Friend Username
    Navigate To Accept Page
    Remove Ins Tags
    One Signal Remove
    Vignette Ads Remove
    Wait Until Page Contains Element    class:input    timeout=${timeout}
    Remove Sticky Ads
    # ${btn_sel}=   Set Variable    ".primary-btn"
    Sleep    2
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Remove Sticky Ads

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
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Input Text    class:input    ${friend_name}
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
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
    Sleep    17
    Vignette Ads Remove
    Video Ad Remove
#    ${hint_accept}=    Execute Javascript    return document.querySelectorAll(".disabled-ans")[0];
#    Log To Console    ${hint_accept}
    Wait Until Page Contains Element    xpath=(//div[@class='option disabled-ans'])[1]
    Sleep    2

Answer Page Incog
    Input Friend Username
    Accept Username Valid
    Sleep    5
    Execute Javascript    document.querySelector(".options").scrollIntoView({behavior: 'smooth', block: 'center'});
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

Complete Page Incog
    Answer Page Incog
    Execute Javascript    document.querySelector(".complete-heading").scrollIntoView({behavior: 'smooth', block: 'center'});
    Sleep    3
    Execute Javascript    document.getElementById('step16').click();
    Sleep    4
    Vignette Ads Remove
#    Reload Page
#    Sleep    2
    Execute Javascript    document.getElementById('step16').click();
    Vignette Ads Remove
    Log To Console    "create new Quiz"
    Sleep    5
    Log To Console    "page open"
    Wait Until Page Contains Element    class:input
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    ${text}=    Get Text    class:input
    IF    '${text}' == '${friend_name}'
        Log To Console    "Strings are equal"
    END
    Sleep    2

Scoreboard
    Vignette Ads Remove
    Reload Page
    Sleep    5
    Remove Ins Tags
    Remove Sticky Ads
    Execute Javascript    document.querySelector(".v-ans").scrollIntoView({behavior: 'smooth', block: 'center'});
    Remove Ins Tags
    Remove Sticky Ads
    Execute Javascript    document.getElementsByClassName('v-ans')[0].click();
    Sleep    20
    Remove Ins Tags
    Video Ad Remove
    Wait Until Page Contains Element    class:result
    Execute Javascript    document.getElementsByClassName('result').scrollIntoView({behavior: 'smooth', block: 'center'});
    Sleep    2

View-Answer User
    Vignette Ads Remove
    Execute Javascript    document.querySelector(".result").scrollIntoView({behavior: 'smooth', block: 'center'});
    Execute Javascript    document.getElementsByClassName('scoreItemTxt')[0].click();
    Sleep    20
#    Reload Page
#    Sleep    2
#    Scroll Selector    ".result"
#    Execute Javascript    document.getElementsByClassName('scoreItem')[0].click();
#    Sleep    13
    Remove Ins Tags
    Video Ad Remove
    Wait Until Page Contains Element    class:viewCard
    Reload Page
    Sleep    2
    Remove Ins Tags
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Execute Javascript    document.getElementsByClassName('primary-btn')[0].click();
    Remove Ins Tags
    Execute Javascript    document.querySelector(".primary-btn").scrollIntoView({behavior: 'smooth', block: 'center'});
    Execute Javascript    document.getElementsByClassName('primary-btn')[0].click();
    Sleep    3
    Vignette Ads Remove
    Remove Ins Tags
    Wait Until Page Contains Element    id:link