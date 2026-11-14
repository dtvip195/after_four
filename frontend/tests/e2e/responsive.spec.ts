import { expect, test, type Page } from "@playwright/test"

const viewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

const majorSectionNames = [
  "Một nền tảng ấm, rõ và có kỷ luật",
  "Tiếng Việt rõ ràng, số liệu quét nhanh",
  "Hành động rõ, emphasis có giới hạn",
  "Label thật, lỗi gần field, touch area đủ rộng",
  "Tín hiệu có nhãn, icon và độ ưu tiên rõ",
  "Primitive thật, không sao chép component",
  "Một lát cắt nhỏ, không phải POS Application Shell",
] as const

async function expectTablesToContainTheirOwnOverflow(page: Page) {
  const tables = page.getByRole("table")

  for (let index = 0; index < (await tables.count()); index += 1) {
    const overflow = await tables.nth(index).evaluate((table) => {
      const container = table.parentElement

      return {
        containerOverflowX: container ? getComputedStyle(container).overflowX : "missing",
        needsHorizontalScroll: container
          ? container.scrollWidth > container.clientWidth + 1
          : false,
      }
    })

    if (overflow.needsHorizontalScroll) {
      expect(overflow.containerOverflowX).toBe("auto")
    }
  }
}

for (const viewport of viewports) {
  test(`design system fits the ${viewport.name} viewport (${viewport.width}x${viewport.height})`, async ({
    page,
  }) => {
    await page.setViewportSize(viewport)
    await page.goto("/design-system")

    const main = page.getByRole("main")
    await expect(main).toBeVisible()
    await expect(page.getByRole("heading", { level: 1, name: "Component Showcase" })).toBeVisible()
    await expect(page.getByText("AFTER FOUR · Design system playground")).toBeVisible()
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

    const mainBox = await main.boundingBox()
    expect(mainBox).not.toBeNull()
    expect(mainBox?.x ?? -1).toBeGreaterThanOrEqual(-1)
    expect((mainBox?.x ?? 0) + (mainBox?.width ?? 0)).toBeLessThanOrEqual(
      viewport.width + 1
    )

    for (const sectionName of majorSectionNames) {
      const heading = page.getByRole("heading", { level: 2, name: sectionName })
      await expect(heading).toBeVisible()

      const box = await heading.boundingBox()
      expect(box, `${sectionName} should have a layout box`).not.toBeNull()
      expect(box?.x ?? -1).toBeGreaterThanOrEqual(-1)
      expect((box?.x ?? 0) + (box?.width ?? 0)).toBeLessThanOrEqual(viewport.width + 1)
    }

    await expectTablesToContainTheirOwnOverflow(page)
  })
}
