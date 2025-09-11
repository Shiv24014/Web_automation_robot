*** Settings ***
Library           SeleniumLibrary
Resource          KeyResource.robot
Suite Setup       Open Primary Browser
Suite Teardown    Close All Browsers
Test Teardown     Capture Page Screenshot

*** Test Cases ***
# -------------------
# User Flow
# -------------------
Homepage Test
    [Tags]    userflow    smoke
    Navigate To Homepage

Username Input Test (User)
    [Tags]    userflow
    Input Blank Username
    Input Invalid Username
    Input Username

Share Or Answer Page Handling
    [Tags]    userflow
    ${page_type}=    Answer Questions Without Skip
    Run Keyword If    '${page_type}' == 'share'    Copy Share Link
    Run Keyword If    '${page_type}' == 'answer'    Handle Answer Page

# -------------------
# Friend Flow
# -------------------
Accept Page
    [Tags]    friendflow
    Open Incognito Browser If Needed
    Switch Browser    ${INCOG_ALIAS}
    Navigate To Accept Page

Username Input Test (Friend)
    [Tags]    friendflow
    Accept Blank Username
    Accept Invalid Username
    Accept Valid Username

Answer Page
    [Tags]    friendflow
    ${page_type}=    Answer Questions Incognito
    # Run Keyword If    '${page_type}' == 'share'    Copy Share Link
    Run Keyword And Ignore Error    Handle Answer Page

# -------------------
# Verification Flow
# -------------------
Complete Page
    [Tags]    verification
    Switch Browser    ${INCOG_ALIAS}
    Handle Answer Page

View Scoreboard
    [Tags]    verification
    Switch Browser    ${PRIMARY_ALIAS}
    Verify Scoreboard
