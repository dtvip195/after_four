import { expect, test } from "@playwright/test"

test.beforeEach(async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 900 })
  await page.goto("/pos")
  await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()
})

test("POS renders all three workspace areas on desktop", async ({ page }) => {
  await expect(page.getByRole("region", { name: "Không gian bàn" })).toBeVisible()
  await expect(page.getByRole("region", { name: "Chọn món minh họa" })).toBeVisible()
  await expect(page.getByRole("complementary", { name: "Đơn minh họa" })).toBeVisible()
  await expect(page.getByText("Không có nghiệp vụ thật")).toBeVisible()
})

test("menu search filters illustrative products", async ({ page }) => {
  const menuWorkspace = page.getByRole("region", { name: "Chọn món minh họa" })
  const search = menuWorkspace.getByRole("searchbox", { name: "Tìm món minh họa" })
  await search.fill("Latte")

  await expect(menuWorkspace.getByRole("article", { name: /Latte, giá minh họa/ })).toBeVisible()
  await expect(menuWorkspace.getByRole("article", { name: /Espresso, giá minh họa/ })).toHaveCount(0)
  await expect(menuWorkspace.getByText("1 sản phẩm minh họa")).toBeVisible()
})

test("category selection filters illustrative products", async ({ page }) => {
  const categories = page.getByRole("group", { name: "Lọc danh mục minh họa" })
  const teaCategory = categories.getByRole("button", { name: "Tea", exact: true })
  await teaCategory.click()

  await expect(teaCategory).toHaveAttribute("aria-pressed", "true")
  await expect(page.getByRole("article", { name: /Milk Tea, giá minh họa/ })).toBeVisible()
  await expect(page.getByRole("article", { name: /Peach Tea, giá minh họa/ })).toBeVisible()
  await expect(page.getByRole("article", { name: /Espresso, giá minh họa/ })).toHaveCount(0)
})

test("floor selection updates POS floor context", async ({ page }) => {
  const floorSelector = page.getByRole("combobox", { name: "Chọn tầng" })
  await floorSelector.click()
  await page.getByRole("option", { name: "Tầng 2" }).click()

  const floorWorkspace = page.getByRole("region", { name: "Không gian bàn" })
  await expect(floorSelector).toContainText("Tầng 2")
  await expect(floorWorkspace.getByText("Tầng 2", { exact: true })).toBeVisible()
})

test("order workspace starts empty and cannot trigger checkout", async ({ page }) => {
  const orderPanel = page.getByRole("complementary", { name: "Đơn minh họa" })

  await expect(orderPanel.getByText("Đơn đang trống", { exact: true })).toBeVisible()
  await expect(orderPanel.getByText("Tạm tính demo", { exact: true })).toBeVisible()
  await expect(orderPanel.getByText("0 ₫", { exact: true })).toBeVisible()
  await expect(
    orderPanel.getByRole("button", { name: "Thanh toán demo" })
  ).toBeDisabled()
})
