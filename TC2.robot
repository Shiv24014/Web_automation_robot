*** Settings ***
Library    SeleniumLibrary
Resource    ./KeyResource.robot

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