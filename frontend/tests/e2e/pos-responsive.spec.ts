import { expect, test } from "@playwright/test"

const viewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

for (const viewport of viewports) {
  test(`POS fits the ${viewport.name} viewport (${viewport.width}x${viewport.height})`, async ({
    page,
  }) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    const widths = await page.evaluate(() => ({
      bodyClientWidth: document.body.clientWidth,
      bodyScrollWidth: document.body.scrollWidth,
      htmlClientWidth: document.documentElement.clientWidth,
      htmlScrollWidth: document.documentElement.scrollWidth,
    }))

    expect(widths.htmlScrollWidth).toBeLessThanOrEqual(widths.htmlClientWidth + 1)
    expect(widths.bodyScrollWidth).toBeLessThanOrEqual(widths.bodyClientWidth + 1)
    await expect(page.getByRole("combobox", { name: "Chọn tầng" })).toBeVisible()

    const floorWorkspace = page.getByRole("region", { name: "Không gian bàn" })
    const menuWorkspace = page.getByRole("region", { name: "Chọn món minh họa" })
    const orderPanel = page.getByRole("complementary", { name: "Đơn minh họa" })

    if (viewport.width < 768) {
      await expect(menuWorkspace).toBeVisible()
      await expect(floorWorkspace).toBeHidden()
      await expect(orderPanel).toBeHidden()

      await page.getByRole("tab", { name: "Bàn", exact: true }).click()
      await expect(floorWorkspace).toBeVisible()
      await page.getByRole("tab", { name: "Đơn", exact: true }).click()
      await expect(orderPanel).toBeVisible()
    } else {
      await expect(floorWorkspace).toBeVisible()
      await expect(menuWorkspace).toBeVisible()
      await expect(orderPanel).toBeVisible()

      const floorBox = await floorWorkspace.boundingBox()
      const menuBox = await menuWorkspace.boundingBox()
      const orderBox = await orderPanel.boundingBox()
      expect(floorBox).not.toBeNull()
      expect(menuBox).not.toBeNull()
      expect(orderBox).not.toBeNull()

      if (viewport.width >= 1280) {
        expect((floorBox?.x ?? 0) + (floorBox?.width ?? 0)).toBeLessThanOrEqual(
          (menuBox?.x ?? 0) + 1
        )
        expect((menuBox?.x ?? 0) + (menuBox?.width ?? 0)).toBeLessThanOrEqual(
          (orderBox?.x ?? 0) + 1
        )
      } else {
        expect((floorBox?.y ?? 0) + (floorBox?.height ?? 0)).toBeLessThanOrEqual(
          (menuBox?.y ?? 0) + 1
        )
        expect((menuBox?.x ?? 0) + (menuBox?.width ?? 0)).toBeLessThanOrEqual(
          (orderBox?.x ?? 0) + 1
        )
      }
    }
  })
}
