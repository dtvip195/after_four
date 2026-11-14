import { expect, test } from "@playwright/test"

test.beforeEach(async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 900 })
  await page.goto("/pos")
  await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()
})

test("table workspace shows the illustrative floor dataset", async ({ page }) => {
  const workspace = page.getByRole("region", { name: "Không gian bàn" })

  await expect(workspace.getByLabel("6 bàn minh họa")).toBeVisible()
  await expect(workspace.getByRole("button", { name: /T1-01/ })).toBeVisible()
  await expect(workspace.getByRole("button", { name: /T1-06/ })).toBeVisible()
  await expect(workspace.getByText("Trạng thái đề xuất")).toBeVisible()
})

test("changing floor replaces the table fixture and clears local state", async ({ page }) => {
  const workspace = page.getByRole("region", { name: "Không gian bàn" })
  await workspace.getByRole("button", { name: /T1-01/ }).click()

  const floorSelector = page.getByRole("combobox", { name: "Chọn tầng" })
  await floorSelector.click()
  await page.getByRole("option", { name: "Tầng 2" }).click()

  await expect(workspace.getByLabel("5 bàn minh họa")).toBeVisible()
  await expect(workspace.getByRole("button", { name: /T2-01/ })).toBeVisible()
  await expect(workspace.getByRole("button", { name: /T1-01/ })).toHaveCount(0)
  await expect(workspace.getByText("Chưa chọn bàn")).toBeVisible()
})

test("selecting and clearing a table updates the preview", async ({ page }) => {
  const workspace = page.getByRole("region", { name: "Không gian bàn" })
  const table = workspace.getByRole("button", { name: /T1-02/ })
  const preview = workspace.getByRole("complementary", { name: "Thông tin bàn được chọn" })

  await table.click()

  await expect(table).toHaveAttribute("aria-pressed", "true")
  await expect(preview.getByText("Bàn mẫu 02", { exact: true })).toBeVisible()
  await expect(preview.getByText("T1-02", { exact: true })).toBeVisible()
  await expect(preview.getByText("Tầng 1", { exact: true })).toBeVisible()
  await expect(preview.getByText("Đang phục vụ", { exact: true })).toBeVisible()

  await preview.getByRole("button", { name: "Bỏ chọn bàn" }).click()
  await expect(workspace.getByText("Chưa chọn bàn")).toBeVisible()
})

test("table search matches code or name", async ({ page }) => {
  const workspace = page.getByRole("region", { name: "Không gian bàn" })
  await workspace.getByRole("searchbox", { name: "Tìm bàn minh họa" }).fill("T1-04")

  await expect(workspace.getByRole("button", { name: /T1-04/ })).toBeVisible()
  await expect(workspace.getByRole("button", { name: /T1-01/ })).toHaveCount(0)
  await expect(workspace.getByText("1 / 6 bàn đang hiển thị")).toBeVisible()
})

test("status filter shows only matching illustrative tables", async ({ page }) => {
  const workspace = page.getByRole("region", { name: "Không gian bàn" })
  await workspace.getByRole("combobox", { name: "Lọc trạng thái bàn minh họa" }).click()
  await page.getByRole("option", { name: "Cần chú ý" }).click()

  await expect(workspace.getByRole("button", { name: /T1-03/ })).toBeVisible()
  await expect(workspace.getByRole("button", { name: /T1-01/ })).toHaveCount(0)
  await expect(workspace.getByText("1 / 6 bàn đang hiển thị")).toBeVisible()
})

test("empty state and reset restore the table list", async ({ page }) => {
  const workspace = page.getByRole("region", { name: "Không gian bàn" })
  await workspace.getByRole("searchbox", { name: "Tìm bàn minh họa" }).fill("không tồn tại")

  await expect(
    workspace.getByRole("status").filter({ hasText: "Không tìm thấy bàn minh họa" })
  ).toBeVisible()
  await workspace.getByRole("button", { name: "Đặt lại" }).click()

  await expect(workspace.getByRole("button", { name: /T1-01/ })).toBeVisible()
  await expect(workspace.getByText("6 / 6 bàn đang hiển thị")).toBeVisible()
})

const viewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

for (const viewport of viewports) {
  test(`table management fits the ${viewport.name} viewport`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")

    if (viewport.width < 768) {
      await page.getByRole("tab", { name: "Bàn", exact: true }).click()
    }

    const workspace = page.getByRole("region", { name: "Không gian bàn" })
    await expect(workspace).toBeVisible()
    await workspace.getByRole("button", { name: /T1-01/ }).click()
    await expect(
      workspace.getByRole("complementary", { name: "Thông tin bàn được chọn" })
    ).toContainText("T1-01")

    const widths = await page.evaluate(() => ({
      bodyClientWidth: document.body.clientWidth,
      bodyScrollWidth: document.body.scrollWidth,
      htmlClientWidth: document.documentElement.clientWidth,
      htmlScrollWidth: document.documentElement.scrollWidth,
    }))

    expect(widths.htmlScrollWidth).toBeLessThanOrEqual(widths.htmlClientWidth + 1)
    expect(widths.bodyScrollWidth).toBeLessThanOrEqual(widths.bodyClientWidth + 1)
  })
}
