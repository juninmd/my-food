from playwright.sync_api import sync_playwright
import time
import os

os.makedirs("verification/videos", exist_ok=True)
os.makedirs("verification/screenshots", exist_ok=True)

def run_cuj(page):
    url = os.getenv("APP_URL", "http://localhost:3000")
    page.goto(url)
    page.wait_for_load_state("networkidle")

    # Scroll down to see everything
    page.mouse.wheel(0, 500)
    page.wait_for_timeout(1000)

    # Take screenshot
    page.screenshot(path="verification/screenshots/verification.png")
    page.wait_for_timeout(1000)

if __name__ == "__main__":
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            record_video_dir="verification/videos",
            viewport={"width": 1280, "height": 800}
        )
        page = context.new_page()
        try:
            run_cuj(page)
        finally:
            context.close()
            browser.close()