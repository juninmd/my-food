from playwright.sync_api import sync_playwright

def run_cuj(page):
    page.goto("http://localhost:3000")
    page.wait_for_timeout(5000)

    # Click Tools tab on the left rail
    page.mouse.click(40, 350)
    page.wait_for_timeout(2000)
    page.screenshot(path="/home/jules/verification/screenshots/verification9a.png")

    # Click Food Catalog card
    page.mouse.click(800, 500)
    page.wait_for_timeout(2000)

    # Click Add Food Floating Action Button
    page.mouse.click(1220, 650)
    page.wait_for_timeout(2000)

    page.screenshot(path="/home/jules/verification/screenshots/verification9b.png")

if __name__ == "__main__":
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(
            record_video_dir="/home/jules/verification/videos"
        )
        page = context.new_page()
        page.set_viewport_size({"width": 1280, "height": 720})
        try:
            run_cuj(page)
        finally:
            context.close()
            browser.close()
