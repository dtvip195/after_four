import { expect, test, type Page } from "@playwright/test"

async function addProductToOrder(page: Page, productName: string) {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  await menu.getByRole("button", { name: `Xem chi tiết ${productName}` }).click()

  const detail = page.getByRole("dialog", { name: productName })
  await expect(detail).toBeVisible()
  await detail.getByRole("button", { name: "Thêm vào đơn demo" }).click()
  await expect(detail).toBeHidden()
}

test.beforeEach(async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 900 })
  await page.goto("/pos")
  await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()
})

test("order starts empty with a zero subtotal", async ({ page }) => {
  const order = page.getByRole("complementary", { name: "Đơn minh họa" })

  await expect(order.getByText("Đơn đang trống")).toBeVisible()
  await expect(order.getByLabel("Loại sản phẩm: 0")).toBeVisible()
  await expect(order.getByLabel("Tổng số lượng: 0")).toBeVisible()
  await expect(order.getByLabel("Tạm tính demo: 0 ₫")).toBeVisible()
})

test("product detail adds a new product to the order", async ({ page }) => {
  await addProductToOrder(page, "Latte")

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  const line = order.getByRole("listitem", { name: "Dòng đơn Latte" })
  await expect(line).toBeVisible()
  await expect(line.getByLabel("Số lượng Latte: 1")).toBeVisible()
  await expect(order.getByLabel("Tạm tính demo: 58.000 ₫")).toBeVisible()
})

test("adding the same product again increases quantity", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  await addProductToOrder(page, "Latte")

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await expect(order.getByLabel("Số lượng Latte: 2")).toBeVisible()
  await expect(order.getByLabel("Tạm tính demo: 116.000 ₫")).toBeVisible()
})

test("quantity controls increase, decrease, and stop at one", async ({ page }) => {
  await addProductToOrder(page, "Latte")

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  const decrease = order.getByRole("button", { name: "Giảm số lượng Latte" })
  const increase = order.getByRole("button", { name: "Tăng số lượng Latte" })

  await expect(decrease).toBeDisabled()
  await increase.click()
  await expect(order.getByLabel("Số lượng Latte: 2")).toBeVisible()
  await decrease.click()
  await expect(order.getByLabel("Số lượng Latte: 1")).toBeVisible()
  await expect(decrease).toBeDisabled()
  await expect(order.getByRole("listitem", { name: "Dòng đơn Latte" })).toBeVisible()
})

test("remove action deletes one product line", async ({ page }) => {
  await addProductToOrder(page, "Latte")

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await order.getByRole("button", { name: "Xóa Latte khỏi đơn" }).click()

  await expect(order.getByText("Đơn đang trống")).toBeVisible()
  await expect(order.getByRole("listitem", { name: "Dòng đơn Latte" })).toHaveCount(0)
})

test("line note can be edited without changing quantity", async ({ page }) => {
  await addProductToOrder(page, "Latte")

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  const note = order.getByRole("textbox", { name: "Ghi chú cho Latte" })
  await note.fill("Ít đá — ghi chú demo")

  await expect(note).toHaveValue("Ít đá — ghi chú demo")
  await expect(order.getByLabel("Số lượng Latte: 1")).toBeVisible()
})

test("subtotal uses integer VND across multiple lines", async ({ page }) => {
  await addProductToOrder(page, "Espresso")
  await addProductToOrder(page, "Latte")
  await addProductToOrder(page, "Latte")

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await expect(order.getByLabel("Loại sản phẩm: 2")).toBeVisible()
  await expect(order.getByLabel("Tổng số lượng: 3")).toBeVisible()
  await expect(order.getByLabel("Tạm tính demo: 161.000 ₫")).toBeVisible()
})

test("clear order requires confirmation and preserves menu fixtures", async ({ page }) => {
  await addProductToOrder(page, "Espresso")
  await addProductToOrder(page, "Latte")

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await order.getByRole("button", { name: "Xóa toàn bộ" }).click()

  const confirmation = page.getByRole("dialog", { name: "Xóa toàn bộ đơn demo?" })
  await expect(confirmation).toBeVisible()
  await confirmation.getByRole("button", { name: "Xóa toàn bộ sản phẩm" }).click()

  await expect(order.getByText("Đơn đang trống")).toBeVisible()
  await expect(
    page
      .getByRole("region", { name: "Chọn món minh họa" })
      .getByRole("button", { name: "Xem chi tiết Latte" })
  ).toBeVisible()
})

test("mobile tabs preserve order state", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 })
  await page.goto("/pos")
  await addProductToOrder(page, "Latte")

  await page.getByRole("tab", { name: "Đơn", exact: true }).click()
  let order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await expect(order.getByLabel("Số lượng Latte: 1")).toBeVisible()

  await page.getByRole("tab", { name: "Menu", exact: true }).click()
  await addProductToOrder(page, "Latte")
  await page.getByRole("tab", { name: "Đơn", exact: true }).click()
  order = page.getByRole("complementary", { name: "Đơn minh họa" })

  await expect(order.getByLabel("Số lượng Latte: 2")).toBeVisible()
  await expect(order.getByLabel("Tạm tính demo: 116.000 ₫")).toBeVisible()
})

test("table management remains usable with a populated order", async ({ page }) => {
  await addProductToOrder(page, "Latte")

  const tables = page.getByRole("region", { name: "Không gian bàn" })
  await tables.getByRole("button", { name: /T1-01/ }).click()

  await expect(
    tables.getByRole("complementary", { name: "Thông tin bàn được chọn" })
  ).toContainText("T1-01")
  await expect(
    page.getByRole("complementary", { name: "Đơn minh họa" }).getByLabel("Số lượng Latte: 1")
  ).toBeVisible()
})

const viewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

for (const viewport of viewports) {
  test(`order management fits the ${viewport.name} viewport`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await addProductToOrder(page, "Latte")

    if (viewport.width < 768) {
      await page.getByRole("tab", { name: "Đơn", exact: true }).click()
    }

    const order = page.getByRole("complementary", { name: "Đơn minh họa" })
    await expect(order).toBeVisible()
    await expect(order.getByRole("button", { name: "Tăng số lượng Latte" })).toBeVisible()
    await expect(order.getByRole("button", { name: "Xóa Latte khỏi đơn" })).toBeVisible()

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
