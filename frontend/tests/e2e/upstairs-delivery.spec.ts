import { expect, test, type Page } from "@playwright/test"

async function selectDeliveryOrder(page: Page, orderCode: string, tableCode: string) {
  await page
    .getByRole("button", { name: `Mở chi tiết đơn ${orderCode}, bàn ${tableCode}` })
    .click()
}

test.beforeEach(async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 900 })
  await page.goto("/upstairs-delivery")
  await expect(page.getByRole("heading", { level: 1, name: "Upstairs Delivery" })).toBeVisible()
})

test("delivery queue displays grouped demo orders and operational context", async ({ page }) => {
  await expect(page.getByRole("combobox", { name: "Chọn tầng" })).toHaveCount(0)
  const queue = page.getByRole("region", { name: "Delivery Queue" })
  const waiting = queue.getByRole("region", { name: "Nhóm Chờ chuẩn bị" })
  const delivering = queue.getByRole("region", { name: "Nhóm Đang giao" })
  const delivered = queue.getByRole("region", { name: "Nhóm Đã giao" })

  await expect(waiting.getByLabel("3 đơn demo")).toBeVisible()
  await expect(delivering.getByLabel("1 đơn demo")).toBeVisible()
  await expect(delivered.getByLabel("2 đơn demo")).toBeVisible()
  await expect(waiting.getByText("AF-D201", { exact: true })).toBeVisible()
  await expect(waiting.getByText("Bàn T2-03", { exact: true })).toBeVisible()
  await expect(waiting.getByText("2× Latte · 1× Peach Tea", { exact: true })).toBeVisible()
})

test("status filter shows only the selected demo group", async ({ page }) => {
  await page.getByRole("combobox", { name: "Lọc trạng thái delivery demo" }).click()
  await page.getByRole("option", { name: "Đang giao" }).click()

  const queue = page.getByRole("region", { name: "Delivery Queue" })
  await expect(queue.getByRole("region", { name: "Nhóm Đang giao" })).toBeVisible()
  await expect(queue.getByRole("region", { name: "Nhóm Chờ chuẩn bị" })).toHaveCount(0)
  await expect(queue.getByText("AF-D204", { exact: true })).toBeVisible()
  await expect(queue.getByText("AF-D201", { exact: true })).toHaveCount(0)
})

test("search finds orders by order code and table code", async ({ page }) => {
  const search = page.getByRole("searchbox", { name: "Tìm đơn hoặc bàn demo" })

  await search.fill("AF-D203")
  await expect(page.getByText("1 / 6 đơn demo khớp tìm kiếm")).toBeVisible()
  await expect(page.getByText("AF-D203", { exact: true })).toBeVisible()
  await expect(page.getByText("AF-D201", { exact: true })).toHaveCount(0)

  await search.fill("T2-04")
  await expect(page.getByText("1 / 6 đơn demo khớp tìm kiếm")).toBeVisible()
  await expect(page.getByText("AF-D204", { exact: true })).toBeVisible()
})

test("search exposes an empty state in every visible group", async ({ page }) => {
  await page.getByRole("searchbox", { name: "Tìm đơn hoặc bàn demo" }).fill("không-tồn-tại")

  await expect(page.getByText("0 / 6 đơn demo khớp tìm kiếm")).toBeVisible()
  await expect(page.getByText("Không có đơn phù hợp")).toHaveCount(3)
})

test("desktop detail shows products, quantities, destination, note, and can close", async ({ page }) => {
  await selectDeliveryOrder(page, "AF-D201", "T2-03")
  const detail = page.getByRole("complementary", { name: "Chi tiết delivery demo" })

  await expect(detail.getByText("AF-D201", { exact: true })).toBeVisible()
  await expect(detail.getByText("T2-03", { exact: true })).toBeVisible()
  await expect(detail.getByText("Tầng 2", { exact: true })).toBeVisible()
  await expect(detail.getByLabel("Latte, số lượng 2")).toBeVisible()
  await expect(detail.getByLabel("Peach Tea, số lượng 1")).toBeVisible()
  await expect(detail.getByText("Đặt ở đầu bàn, tránh làm phiền khách đang họp.")).toBeVisible()

  await detail.getByRole("button", { name: "Đóng chi tiết delivery" }).click()
  await expect(detail.getByText("Chọn một đơn demo")).toBeVisible()
})

test("changing demo status moves an order to the matching group", async ({ page }) => {
  await selectDeliveryOrder(page, "AF-D201", "T2-03")
  const detail = page.getByRole("complementary", { name: "Chi tiết delivery demo" })
  await detail.getByRole("combobox", { name: "Trạng thái demo của AF-D201" }).click()
  await page.getByRole("option", { name: "Đang giao" }).click()

  const queue = page.getByRole("region", { name: "Delivery Queue" })
  await expect(
    queue.getByRole("region", { name: "Nhóm Đang giao" }).getByText("AF-D201", { exact: true })
  ).toBeVisible()
  await expect(
    queue.getByRole("region", { name: "Nhóm Chờ chuẩn bị" }).getByText("AF-D201", { exact: true })
  ).toHaveCount(0)
  await expect(page.getByText("AF-D201 đã chuyển sang Đang giao trong dữ liệu demo.")).toBeAttached()
})

test("confirm delivered changes only local delivery state and sends no request", async ({ page }) => {
  await selectDeliveryOrder(page, "AF-D204", "T2-04")
  const networkRequests: string[] = []
  page.on("request", (request) => {
    if (["fetch", "xhr"].includes(request.resourceType())) networkRequests.push(request.url())
  })

  await page
    .getByRole("complementary", { name: "Chi tiết delivery demo" })
    .getByRole("button", { name: "Xác nhận đã giao — demo" })
    .click()

  const queue = page.getByRole("region", { name: "Delivery Queue" })
  await expect(
    queue.getByRole("region", { name: "Nhóm Đã giao" }).getByText("AF-D204", { exact: true })
  ).toBeVisible()
  await expect(page.getByText("6 / 6 đơn demo khớp tìm kiếm")).toBeVisible()
  expect(networkRequests).toEqual([])
})

test("delivery mutations reset on reload because fixtures are session-local", async ({ page }) => {
  await selectDeliveryOrder(page, "AF-D204", "T2-04")
  await page
    .getByRole("complementary", { name: "Chi tiết delivery demo" })
    .getByRole("button", { name: "Xác nhận đã giao — demo" })
    .click()
  await page.reload()

  const delivering = page
    .getByRole("region", { name: "Delivery Queue" })
    .getByRole("region", { name: "Nhóm Đang giao" })
  await expect(delivering.getByText("AF-D204", { exact: true })).toBeVisible()
})

test("review route does not change navigation placement or the Kitchen placeholder", async ({ page }) => {
  const navigation = page.getByRole("navigation", { name: "Điều hướng ứng dụng" })
  await expect(navigation.getByRole("link", { name: "Upstairs Delivery" })).toHaveCount(0)
  await navigation.getByRole("link", { name: "Kitchen", exact: true }).click()

  await expect(page).toHaveURL(/\/kitchen$/)
  await expect(page.getByRole("heading", { level: 1, name: "Kitchen" })).toBeVisible()
  await expect(page.getByText("Nền tảng Kitchen đã sẵn sàng")).toBeVisible()
})

test("delivery interactions do not affect POS order, payment, or table state", async ({ page }) => {
  await selectDeliveryOrder(page, "AF-D204", "T2-04")
  await page
    .getByRole("complementary", { name: "Chi tiết delivery demo" })
    .getByRole("button", { name: "Xác nhận đã giao — demo" })
    .click()

  await page.goto("/pos")
  const order = page.getByRole("complementary", { name: "Đơn minh họa" })
  await expect(order.getByText("Đơn đang trống")).toBeVisible()
  await expect(order.getByRole("button", { name: "Thanh toán demo" })).toBeDisabled()

  const tables = page.getByRole("region", { name: "Không gian bàn" })
  await tables.getByRole("button", { name: /T1-01/ }).click()
  await expect(tables.getByRole("complementary", { name: "Thông tin bàn được chọn" })).toContainText("T1-01")
})

const deliveryViewports = [
  { name: "mobile", width: 390, height: 844 },
  { name: "tablet", width: 768, height: 1024 },
  { name: "desktop", width: 1440, height: 900 },
] as const

for (const viewport of deliveryViewports) {
  test(`upstairs delivery fits the ${viewport.name} viewport`, async ({ page }) => {
    await page.setViewportSize(viewport)
    await page.goto("/upstairs-delivery")
    await selectDeliveryOrder(page, "AF-D201", "T2-03")

    if (viewport.width < 1280) {
      const detail = page.getByRole("dialog", { name: "Chi tiết đơn AF-D201" })
      await expect(detail).toBeVisible()
      await expect(detail.getByLabel("Latte, số lượng 2")).toBeVisible()
    } else {
      await expect(page.getByRole("complementary", { name: "Chi tiết delivery demo" })).toContainText("AF-D201")
    }

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
