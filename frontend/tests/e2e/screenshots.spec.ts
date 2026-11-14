import { expect, test, type Page } from "@playwright/test"

async function addScreenshotProduct(page: Page, productName: string) {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  await menu.getByRole("button", { name: `Xem chi tiết ${productName}` }).click()
  await page
    .getByRole("dialog", { name: productName })
    .getByRole("button", { name: "Thêm vào đơn demo" })
    .click()
}

const screenshotViewports = [
  { name: "390", width: 390, height: 844 },
  { name: "768", width: 768, height: 1024 },
  { name: "1440", width: 1440, height: 900 },
] as const

for (const viewport of screenshotViewports) {
  test(`captures the design system at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/design-system")
    await expect(page.getByRole("heading", { level: 1, name: "Component Showcase" })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`design-system-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, fullPage: true })
    await testInfo.attach(`design-system-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })

  test(`captures the application shell at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/dashboard")
    await expect(page.getByRole("heading", { level: 1, name: "Dashboard" })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`application-shell-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, fullPage: true })
    await testInfo.attach(`application-shell-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })

  test(`captures the POS screen at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`pos-screen-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, fullPage: true })
    await testInfo.attach(`pos-screen-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })

  test(`captures table management at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()

    if (viewport.width < 768) {
      await page.getByRole("tab", { name: "Bàn", exact: true }).click()
    }

    const workspace = page.getByRole("region", { name: "Không gian bàn" })
    await workspace.getByRole("button", { name: /T1-01/ }).click()
    await expect(
      workspace.getByRole("complementary", { name: "Thông tin bàn được chọn" })
    ).toContainText("T1-01")
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`table-management-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, fullPage: true })
    await testInfo.attach(`table-management-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })

  test(`captures product detail at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()

    const menu = page.getByRole("region", { name: "Chọn món minh họa" })
    await menu.getByRole("button", { name: "Xem chi tiết Latte" }).click()
    await expect(page.getByRole("dialog", { name: "Latte" })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`product-detail-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, animations: "disabled" })
    await testInfo.attach(`product-detail-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })

  test(`captures order management at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()

    await addScreenshotProduct(page, "Latte")
    await addScreenshotProduct(page, "Latte")

    if (viewport.width < 768) {
      await page.getByRole("tab", { name: "Đơn", exact: true }).click()
    }

    const order = page.getByRole("complementary", { name: "Đơn minh họa" })
    await order.getByRole("textbox", { name: "Ghi chú cho Latte" }).fill("Ít đá — demo")
    await expect(order.getByLabel("Số lượng Latte: 2")).toBeVisible()
    if (viewport.width === 768) {
      await order.evaluate((element) => element.scrollIntoView({ block: "start" }))
      await page.evaluate(() => window.scrollBy(0, -72))
    } else {
      await order.evaluate((element) => element.scrollIntoView({ block: "center" }))
    }
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`order-management-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, animations: "disabled" })
    await testInfo.attach(`order-management-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })

  test(`captures payment UI at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await addScreenshotProduct(page, "Latte")
    await addScreenshotProduct(page, "Latte")

    if (viewport.width < 768) {
      await page.getByRole("tab", { name: "Đơn", exact: true }).click()
    }

    await page
      .getByRole("complementary", { name: "Đơn minh họa" })
      .getByRole("button", { name: "Thanh toán demo" })
      .click()
    const payment = page.getByRole("dialog", { name: "Thanh toán demo", exact: true })
    await payment.getByRole("radio", { name: /Tiền mặt/ }).click()
    await payment.getByRole("textbox", { name: "Số tiền khách đưa" }).fill("150000")
    await expect(payment.getByText("34.000 ₫", { exact: true })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`payment-ui-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, animations: "disabled" })
    await testInfo.attach(`payment-ui-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })

  test(`captures upstairs delivery at ${viewport.name}px`, async ({ page }, testInfo) => {
    await page.setViewportSize(viewport)
    await page.goto("/upstairs-delivery")
    await expect(page.getByRole("heading", { level: 1, name: "Upstairs Delivery" })).toBeVisible()
    await page.getByRole("button", { name: "Mở chi tiết đơn AF-D201, bàn T2-03" }).click()

    if (viewport.width < 1280) {
      await expect(page.getByRole("dialog", { name: "Chi tiết đơn AF-D201" })).toBeVisible()
    } else {
      await expect(page.getByRole("complementary", { name: "Chi tiết delivery demo" })).toContainText("AF-D201")
    }
    await page.evaluate(() => document.fonts.ready)

    const screenshotPath = testInfo.outputPath(`upstairs-delivery-${viewport.name}.png`)
    await page.screenshot({ path: screenshotPath, animations: "disabled" })
    await testInfo.attach(`upstairs-delivery-${viewport.name}`, {
      path: screenshotPath,
      contentType: "image/png",
    })
  })
}
