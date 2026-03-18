import time
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)

    # Desktop
    context_desktop = browser.new_context(viewport={"width": 1280, "height": 800})
    page_desktop = context_desktop.new_page()
    page_desktop.goto("http://localhost:3000")
    page_desktop.wait_for_timeout(3000)
    page_desktop.screenshot(path="/app/desktop_verify.png", full_page=True)
    context_desktop.close()

    # Mobile
    context_mobile = browser.new_context(viewport={"width": 375, "height": 812})
    page_mobile = context_mobile.new_page()
    page_mobile.goto("http://localhost:3000")
    page_mobile.wait_for_timeout(3000)
    page_mobile.screenshot(path="/app/mobile_verify.png", full_page=True)
    context_mobile.close()

    browser.close()
