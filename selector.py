import time
import psutil
import os
from time import sleep
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import traceback

VIGNETTE_CLOSE_SELECTOR = "dismiss-button"


def vignette_find_nd_close(driver):
    try:
        remove_ins_tags(driver)
        print(f"Vignette find & close")
        driver.execute_script("""
            document.querySelector("ins[data-vignette-loaded]")?.remove();
        """)
    except Exception as e:
        print(f"Failed vignette script")


def remove_ins_tags(driver):
    try:
        print(f"Ins find & close")
        driver.execute_script("""
            document.querySelectorAll("ins")?.forEach(ad => ad?.remove());
        """)
    except Exception as e:
        print(f"Failed vignette script")


def vignette_safe_click(by, selector, driver):
    sleep(2)
    vignette_find_nd_close(driver)
    remove_ins_tags(driver)
    print(f"{selector} Clicking")
    try:
        driver.find_element(by, selector).click()
    except Exception as e:
        traceback.print_exc()


def one_signal_find_nd_subscribe(driver):
    try:
        print(f"onesignal find & close")
        driver.execute_script("""
            document.getElementById("onesignal-slidedown-allow-button")?.click();
        """)
    except Exception as e:
        print(f"Failed vignette script")


def end_all_task(drivers):
    try:
        for driver in drivers:
            driver.quit()
        PROCNAME = "chrome.exe"
        for proc in psutil.process_iter():
            if proc.name() == PROCNAME:
                print("Ending process-" + proc.name())
                proc.kill()
    except Exception as e:
        print("Something went wrong while ending all task")
