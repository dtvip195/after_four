import { expect, test, type Page } from "@playwright/test"

async function addProductToOrder(page: Page, productName: string) {
  const menu = page.getByRole("region", { name: "Chọn món minh họa" })
  await menu.getByRole("button", { name: `Xem chi tiết ${productName}` }).click()
  await page
    .getByRole("dialog", { name: productName })
    .getByRole("button", { name: "Thêm vào đơn demo" })
    .click()
}

async function openPayment(page: Page) {
  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await order.getByRole("button", { name: "Thanh toán demo" }).click()
  const payment = page.getByRole("dialog", { name: "Thanh toán demo", exact: true })
  await expect(payment).toBeVisible()
  return payment
}

test.beforeEach(async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 900 })
  await page.goto("/pos")
  await expect(page.getByRole("heading", { level: 1, name: "POS" })).toBeVisible()
})

test("empty order cannot open payment UI", async ({ page }) => {
  const checkout = page
    .getByRole("complementary", { name: "Đơn minh họa" })
    .getByRole("button", { name: "Thanh toán demo" })

  await expect(checkout).toBeDisabled()
  await expect(page.getByRole("dialog", { name: "Thanh toán demo", exact: true })).toHaveCount(0)
})

test("payment summary matches the current order state", async ({ page }) => {
  await addProductToOrder(page, "Espresso")
  await addProductToOrder(page, "Latte")
  await addProductToOrder(page, "Latte")
  const payment = await openPayment(page)

  await expect(payment.getByText("Espresso", { exact: true })).toBeVisible()
  await expect(payment.getByText("1 × 45.000 ₫", { exact: true })).toBeVisible()
  await expect(payment.getByLabel("Espresso, thành tiền 45.000 ₫")).toBeVisible()
  await expect(payment.getByText("2 × 58.000 ₫", { exact: true })).toBeVisible()
  await expect(payment.getByLabel("Latte, thành tiền 116.000 ₫")).toBeVisible()
  await expect(payment.getByLabel("Tạm tính trong Payment UI: 161.000 ₫")).toBeVisible()
})

test("payment methods expose one accurate selected state and method-specific guidance", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  const payment = await openPayment(page)
  const cash = payment.getByRole("radio", { name: /Tiền mặt/ })
  const transfer = payment.getByRole("radio", { name: /Chuyển khoản ngân hàng/ })
  const qr = payment.getByRole("radio", { name: /QR Payment/ })

  await cash.click()
  await expect(cash).toBeChecked()
  await expect(transfer).not.toBeChecked()
  await payment.getByRole("button", { name: "Tiếp tục xác nhận" }).click()
  await expect(payment.getByText("Nhập số tiền khách đưa để tiếp tục.")).toBeVisible()

  await transfer.click()
  await expect(transfer).toBeChecked()
  await expect(cash).not.toBeChecked()
  await expect(payment.getByText("Nhập số tiền khách đưa để tiếp tục.")).toHaveCount(0)
  await expect(payment.getByText(/Chưa có tài khoản, mã QR hoặc cổng thanh toán thật/)).toBeVisible()

  await qr.click()
  await expect(qr).toBeChecked()
  await expect(transfer).not.toBeChecked()
  await expect(payment.getByText("Hướng dẫn QR Payment mô phỏng")).toBeVisible()
})

test("a payment method is required before confirmation", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  const payment = await openPayment(page)

  await payment.getByRole("button", { name: "Tiếp tục xác nhận" }).click()
  await expect(payment.getByText("Chưa chọn phương thức")).toBeVisible()
  await expect(page.getByRole("dialog", { name: "Xác nhận thanh toán demo" })).toHaveCount(0)
})

test("cash accepts exact and excess integer VND and calculates change", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  const payment = await openPayment(page)
  await payment.getByRole("radio", { name: /Tiền mặt/ }).click()
  const receivedAmount = payment.getByRole("textbox", { name: "Số tiền khách đưa" })

  await receivedAmount.fill("58000")
  await expect(payment.getByText("0 ₫", { exact: true })).toBeVisible()

  await receivedAmount.fill("100000")
  await expect(payment.getByText("42.000 ₫", { exact: true })).toBeVisible()
  await payment.getByRole("button", { name: "Tiếp tục xác nhận" }).click()

  const confirmation = page.getByRole("dialog", { name: "Xác nhận thanh toán demo" })
  await expect(confirmation).toBeVisible()
  await expect(confirmation.getByText("100.000 ₫", { exact: true })).toBeVisible()
  await expect(confirmation.getByText("42.000 ₫", { exact: true })).toBeVisible()
})

test("cash rejects empty, invalid, and insufficient values", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  const payment = await openPayment(page)
  await payment.getByRole("radio", { name: /Tiền mặt/ }).click()
  const receivedAmount = payment.getByRole("textbox", { name: "Số tiền khách đưa" })
  const continueButton = payment.getByRole("button", { name: "Tiếp tục xác nhận" })

  await continueButton.click()
  await expect(payment.getByText("Nhập số tiền khách đưa để tiếp tục.")).toBeVisible()

  await receivedAmount.fill("58.000")
  await expect(payment.getByText("Số tiền chỉ gồm chữ số và phải là số nguyên VND hợp lệ.")).toBeVisible()

  await receivedAmount.fill("50000")
  await expect(payment.getByText("Số tiền khách đưa còn thiếu 8.000 ₫.")).toBeVisible()
  await continueButton.click()
  await expect(page.getByRole("dialog", { name: "Xác nhận thanh toán demo" })).toHaveCount(0)
})

test("confirmation can be cancelled back to payment UI", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  const payment = await openPayment(page)
  await payment.getByRole("radio", { name: /Chuyển khoản ngân hàng/ }).click()
  await payment.getByRole("button", { name: "Tiếp tục xác nhận" }).click()

  const confirmation = page.getByRole("dialog", { name: "Xác nhận thanh toán demo" })
  await confirmation.getByRole("button", { name: "Quay lại Payment UI" }).click()

  await expect(confirmation).toBeHidden()
  await expect(payment).toBeVisible()
  await expect(payment.getByRole("radio", { name: /Chuyển khoản ngân hàng/ })).toBeChecked()
})

test("demo confirmation sends no API request and preserves the order", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  const payment = await openPayment(page)
  await payment.getByRole("radio", { name: /QR Payment/ }).click()
  await payment.getByRole("button", { name: "Tiếp tục xác nhận" }).click()

  const networkRequests: string[] = []
  page.on("request", (request) => {
    if (["fetch", "xhr"].includes(request.resourceType())) {
      networkRequests.push(request.url())
    }
  })

  await page
    .getByRole("dialog", { name: "Xác nhận thanh toán demo" })
    .getByRole("button", { name: "Xác nhận thanh toán demo" })
    .click()
  await expect(page.getByRole("heading", { name: "Thanh toán demo thành công" })).toBeVisible()
  expect(networkRequests).toEqual([])

  await page.getByRole("button", { name: "Quay lại đơn" }).click()
  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await expect(order.getByLabel("Số lượng Latte: 1")).toBeVisible()
  await expect(order.getByLabel("Tạm tính demo: 58.000 ₫")).toBeVisible()
})

test("closing, editing the order, and reopening starts a fresh payment session", async ({ page }) => {
  await addProductToOrder(page, "Latte")
  let payment = await openPayment(page)
  await payment.getByRole("radio", { name: /Tiền mặt/ }).click()
  await payment.getByRole("textbox", { name: "Số tiền khách đưa" }).fill("100000")
  await payment.getByRole("button", { name: "Đóng" }).click()

  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await order.getByRole("button", { name: "Tăng số lượng Latte" }).click()
  payment = await openPayment(page)

  await expect(payment.getByLabel("Tạm tính trong Payment UI: 116.000 ₫")).toBeVisible()
  await expect(payment.getByRole("radio", { name: /Tiền mặt/ })).not.toBeChecked()
  await expect(payment.getByRole("textbox", { name: "Số tiền khách đưa" })).toHaveCount(0)
})

test("mobile tabs preserve order state after visiting payment UI", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 })
  await page.goto("/pos")
  await addProductToOrder(page, "Latte")
  await page.getByRole("tab", { name: "Đơn", exact: true }).click()
  const payment = await openPayment(page)
  await payment.getByRole("button", { name: "Đóng" }).click()

  await page.getByRole("tab", { name: "Menu", exact: true }).click()
  await page.getByRole("tab", { name: "Đơn", exact: true }).click()
  await expect(
    page.getByRole("complementary", { name: "Đơn minh họa" }).getByLabel("Số lượng Latte: 1")
  ).toBeVisible()
})

const paymentViewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

for (const viewport of paymentViewports) {
  test(`payment UI fits the ${viewport.name} viewport`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto("/pos")
    await addProductToOrder(page, "Latte")
    if (viewport.width < 768) {
      await page.getByRole("tab", { name: "Đơn", exact: true }).click()
    }
    const payment = await openPayment(page)
    await payment.getByRole("radio", { name: /Tiền mặt/ }).click()
    await payment.getByRole("button", { name: "Dùng số tiền 58.000 ₫" }).click()

    await expect(payment.getByText("Tiền thừa dự kiến", { exact: true })).toBeVisible()
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
