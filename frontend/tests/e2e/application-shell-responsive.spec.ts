import { expect, test } from "@playwright/test"

const viewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

for (const viewport of viewports) {
  test(`application shell fits the ${viewport.name} viewport (${viewport.width}x${viewport.height})`, async ({
    page,
  }) => {
    await page.setViewportSize(viewport)
    await page.goto("/dashboard")
    await expect(page.getByRole("heading", { level: 1, name: "Dashboard" })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    const documentWidths = await page.evaluate(() => ({
      bodyClientWidth: document.body.clientWidth,
      bodyScrollWidth: document.body.scrollWidth,
      htmlClientWidth: document.documentElement.clientWidth,
      htmlScrollWidth: document.documentElement.scrollWidth,
    }))

    expect(documentWidths.htmlScrollWidth).toBeLessThanOrEqual(
      documentWidths.htmlClientWidth + 1
    )
    expect(documentWidths.bodyScrollWidth).toBeLessThanOrEqual(
      documentWidths.bodyClientWidth + 1
    )

    const main = page.getByRole("main")
    const header = page.getByRole("banner")
    const floorSelector = page.getByRole("combobox", { name: "Chọn tầng" })
    const sidebar = page.getByRole("complementary", { name: "Thanh điều hướng" })
    const mobileTrigger = page.getByRole("button", { name: "Mở điều hướng" })

    await expect(main).toBeVisible()
    await expect(header).toBeVisible()
    await expect(floorSelector).toBeVisible()
    await expect(page.getByRole("button", { name: "Mở menu người dùng" })).toBeVisible()

    const mainBox = await main.boundingBox()
    expect(mainBox).not.toBeNull()
    expect((mainBox?.x ?? 0) + (mainBox?.width ?? 0)).toBeLessThanOrEqual(viewport.width + 1)

    if (viewport.width < 768) {
      await expect(mobileTrigger).toBeVisible()
      await expect(sidebar).toBeHidden()
      expect(mainBox?.x ?? -1).toBeGreaterThanOrEqual(-1)
    } else {
      await expect(mobileTrigger).toBeHidden()
      await expect(sidebar).toBeVisible()

      const sidebarBox = await sidebar.boundingBox()
      expect(sidebarBox).not.toBeNull()
      expect((sidebarBox?.x ?? 0) + (sidebarBox?.width ?? 0)).toBeLessThanOrEqual(
        (mainBox?.x ?? 0) + 1
      )
    }

    if (viewport.width >= 1024) {
      await expect(sidebar.getByText("Dashboard", { exact: true })).toBeVisible()
    }
  })
}
