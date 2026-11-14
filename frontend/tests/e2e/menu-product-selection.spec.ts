import { expect, test } from "@playwright/test"

test.beforeEach(async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 900 })
  await page.goto("/pos")
  await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()
})

test("menu workspace displays the illustrative product catalog", async ({ page }) => {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })

  await expect(menu.getByText("8 sản phẩm minh họa")).toBeVisible()
  await expect(menu.getByRole("article", { name: /Espresso, giá minh họa/ })).toBeVisible()
  await expect(menu.getByRole("article", { name: /Sparkling Water, giá minh họa/ })).toBeVisible()
})

test("product search filters the illustrative catalog", async ({ page }) => {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  await menu.getByRole("searchbox", { name: "Tìm món minh họa" }).fill("Latte")

  await expect(menu.getByRole("article", { name: /Latte, giá minh họa/ })).toBeVisible()
  await expect(menu.getByRole("article", { name: /Espresso, giá minh họa/ })).toHaveCount(0)
  await expect(menu.getByText("1 sản phẩm minh họa")).toBeVisible()
})

test("category selection updates the product grid", async ({ page }) => {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  const categories = menu.getByRole("group", { name: "Lọc danh mục minh họa" })
  const teaCategory = categories.getByRole("button", { name: "Tea", exact: true })

  await teaCategory.click()

  await expect(teaCategory).toHaveAttribute("aria-pressed", "true")
  await expect(menu.getByRole("article", { name: /Milk Tea, giá minh họa/ })).toBeVisible()
  await expect(menu.getByRole("article", { name: /Peach Tea, giá minh họa/ })).toBeVisible()
  await expect(menu.getByRole("article", { name: /Espresso, giá minh họa/ })).toHaveCount(0)
})

test("selecting a product opens detail and closing clears selection", async ({ page }) => {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  const productButton = menu.getByRole("button", { name: "Xem chi tiết Latte" })
  const productButtonState = page.locator('button[aria-label="Xem chi tiết Latte"]')

  await productButton.click()

  const detail = page.getByRole("dialog", { name: "Latte" })
  await expect(productButtonState).toHaveCount(2)
  await expect(productButtonState.nth(0)).toHaveAttribute("aria-pressed", "true")
  await expect(productButtonState.nth(1)).toHaveAttribute("aria-pressed", "true")
  await expect(detail.getByRole("heading", { name: "Latte" })).toBeVisible()
  await expect(detail.getByText("58.000 ₫", { exact: true })).toBeVisible()
  await expect(detail.getByText(/chỉ phục vụ kiểm tra hierarchy/)).toBeVisible()
  await expect(detail.getByRole("button", { name: "Thêm vào đơn demo" })).toBeEnabled()

  await detail.getByRole("button", { name: "Đóng chi tiết sản phẩm" }).click()
  await expect(detail).toBeHidden()
  await expect(productButton).toHaveAttribute("aria-pressed", "false")
})

test("product search exposes an empty state", async ({ page }) => {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  await menu.getByRole("searchbox", { name: "Tìm món minh họa" }).fill("không tồn tại")

  await expect(
    menu.getByRole("status").filter({ hasText: "Không có sản phẩm minh họa phù hợp" })
  ).toBeVisible()
  await expect(menu.getByText("0 sản phẩm minh họa")).toBeVisible()
})

test("table management remains usable after product detail interaction", async ({ page }) => {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  await menu.getByRole("button", { name: "Xem chi tiết Espresso" }).click()
  await page
    .getByRole("dialog", { name: "Espresso" })
    .getByRole("button", { name: "Đóng chi tiết sản phẩm" })
    .click()

  const tables = page.getByRole("region", { name: "Không gian bàn" })
  await tables.getByRole("button", { name: /T1-01/ }).click()

  await expect(
    tables.getByRole("complementary", { name: "Thông tin bàn được chọn" })
  ).toContainText("T1-01")
})

const viewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

for (const viewport of viewports) {
  test(`menu and product detail fit the ${viewport.name} viewport`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")

    const menu = page.getByRole("region", { name: "Chọn món minh họa" })
    await expect(menu).toBeVisible()
    await menu.getByRole("button", { name: "Xem chi tiết Latte" }).click()

    const detail = page.getByRole("dialog", { name: "Latte" })
    await expect(detail).toBeVisible()
    await expect(detail.getByRole("heading", { name: "Latte" })).toBeVisible()

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
