const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext();
  const page = await context.newPage();
  await page.goto('http://localhost:3000');
  await page.waitForTimeout(3000);

  // Try finding by text for Semantic locator
  try {
    await page.getByText('Food Catalog').click();
    console.log("Clicked by text");
  } catch (e) {
    console.log("Could not find by text");
  }
  await page.waitForTimeout(2000);
  await page.screenshot({ path: '/home/jules/verification/screenshots/verification_grid.png' });
  await browser.close();
})();
