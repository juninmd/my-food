from playwright.sync_api import sync_playwright

def run():
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()

        # Listen for console logs
        page.on("console", lambda msg: print(f"Console: {msg.text}"))
        page.on("pageerror", lambda err: print(f"Page Error: {err}"))

        try:
            print("Navigating to http://localhost:8080...")
            page.goto("http://localhost:8080")

            print("Waiting for Dashboard title...")
            page.wait_for_selector("text=Dashboard", timeout=60000)

            print("Waiting for Macro Card...")
            page.wait_for_selector("text=Remaining", timeout=10000)

            print("Waiting for Surprise Me button...")
            page.wait_for_selector("text=Surprise Me", timeout=10000)

            print("Taking screenshot...")
            page.screenshot(path="verification/dashboard.png", full_page=True)
            print("Screenshot saved to verification/dashboard.png")

        except Exception as e:
            print(f"Error: {e}")
            page.screenshot(path="verification/error.png")
        finally:
            browser.close()

if __name__ == "__main__":
    run()
