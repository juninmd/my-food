from playwright.sync_api import sync_playwright
import time

def run():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()

        try:
            print("Navigating to http://localhost:8080...")
            page.goto("http://localhost:8080")

            # Wait for some time to let Flutter load (since selectors are flaky)
            time.sleep(10)

            print("Taking screenshot of top...")
            page.screenshot(path="verification/dashboard_top.png")

            print("Scrolling down...")
            # Scroll by simulating mouse wheel or touch
            page.mouse.wheel(0, 500)
            time.sleep(2)
            page.screenshot(path="verification/dashboard_mid.png")

            page.mouse.wheel(0, 500)
            time.sleep(2)
            page.screenshot(path="verification/dashboard_bottom.png")

            print("Screenshots saved.")

        except Exception as e:
            print(f"Error: {e}")
            page.screenshot(path="verification/error_scroll.png")
        finally:
            browser.close()

if __name__ == "__main__":
    run()
