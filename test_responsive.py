import time
from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page(viewport={"width": 1280, "height": 800})
    page.goto("http://localhost:3000")
    page.wait_for_timeout(3000)
    page.screenshot(path="/app/dashboard_desktop.png")
    browser.close()
