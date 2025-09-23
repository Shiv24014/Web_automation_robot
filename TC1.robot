*** Settings ***
Resource    ./CelebKeyRes.robot
Library     DataDriver    file=urls.csv

Test Template    Run Tests on Languages

*** Test Cases ***
Test on language Sites using ${URL}
    [Template]    Run Tests on Languages
    https://2025.bfftest.xyz/en
    https://2025.bfftest.xyz/kr
    https://2025.bfftest.xyz/my
    https://2025.bfftest.xyz/th
    https://2025.bfftest.xyz/ch
    https://2025.bfftest.xyz/ro
    https://2025.bfftest.xyz/es
    https://2025.bfftest.xyz/it
    https://2025.bfftest.xyz/tr
    https://2025.bfftest.xyz/pt
    https://2025.bfftest.xyz/il
    https://2025.bfftest.xyz/fr
    https://2025.bfftest.xyz/de
    https://2025.bfftest.xyz/nl
    https://2025.bfftest.xyz/fi
    https://2025.bfftest.xyz/jp
    https://2025.bfftest.xyz/ar
    https://2025.bfftest.xyz/hr
    https://2025.bfftest.xyz/gr
    https://2025.bfftest.xyz/dk
    https://2025.bfftest.xyz/pl
    https://2025.bfftest.xyz/se
    https://2025.bfftest.xyz/ee
    https://2025.bfftest.xyz/rs
    https://2025.bfftest.xyz/lv
    https://2025.bfftest.xyz/hu
    https://2025.bfftest.xyz/si
    https://2025.bfftest.xyz/cz
    https://2025.bfftest.xyz/bg
    https://2025.bfftest.xyz/sk
    https://2025.bfftest.xyz/no