import { expect, test } from "@playwright/test"

const destinations = [
  { name: "Dashboard", path: "/dashboard" },
  { name: "POS", path: "/pos" },
  { name: "Orders", path: "/orders" },
  { name: "Tables", path: "/tables" },
  { name: "Kitchen", path: "/kitchen" },
  { name: "Menu", path: "/menu" },
  { name: "Categories", path: "/categories" },
  { name: "Inventory", path: "/inventory" },
  { name: "Recipes", path: "/recipes" },
  { name: "Staff", path: "/staff" },
  { name: "Reports", path: "/reports" },
  { name: "Settings", path: "/settings" },
] as const

test("the default route loads Dashboard", async ({ page }) => {
  await page.goto("/")

  await expect(page).toHaveURL(/\/dashboard$/)
  await expect(page.getByRole("heading", { level: 1, name: "Dashboard" })).toBeVisible()
})

test("every application destination navigates and exposes its active state", async ({ page }) => {
  await page.setViewportSize({ width: 1440, height: 900 })
  await page.goto("/dashboard")

  const navigation = page.getByRole("navigation", { name: "Điều hướng ứng dụng" })

  for (const destination of destinations) {
    const link = navigation.getByRole("link", { name: destination.name, exact: true })
    await link.click()

    await expect(page).toHaveURL(new RegExp(`${destination.path}$`))
    await expect(
      page.getByRole("heading", { level: 1, name: destination.name, exact: true })
    ).toBeVisible()
    await expect(link).toHaveAttribute("aria-current", "page")
  }
})

test("an unknown route displays the not-found page", async ({ page }) => {
  await page.goto("/unknown-destination")

  await expect(
    page.getByRole("heading", { level: 1, name: "Không tìm thấy trang" })
  ).toBeVisible()
  await expect(page.getByRole("link", { name: "Về Dashboard" })).toBeVisible()
})

test("the Design System route remains accessible", async ({ page }) => {
  await page.goto("/design-system")

  await expect(page.getByRole("heading", { level: 1, name: "Component Showcase" })).toBeVisible()
  await expect(page.getByRole("link", { name: "Application shell" })).toHaveAttribute(
    "href",
    "/dashboard"
  )
})

test("the floor selector updates application-level state", async ({ page }) => {
  await page.goto("/dashboard")

  const floorSelector = page.getByRole("combobox", { name: "Chọn tầng" })
  await expect(floorSelector).toContainText("Tầng 1")
  await expect(page.getByLabel("Phạm vi hiện tại: Tầng 1")).toBeVisible()

  await floorSelector.click()
  await page.getByRole("option", { name: "Tầng 2" }).click()

  await expect(floorSelector).toContainText("Tầng 2")
  await expect(page.getByLabel("Phạm vi hiện tại: Tầng 2")).toBeVisible()
})

test("mobile navigation opens, navigates, and closes", async ({ page }) => {
  await page.setViewportSize({ width: 390, height: 844 })
  await page.goto("/dashboard")

  const navigationTrigger = page.getByRole("button", { name: "Mở điều hướng" })
  await expect(navigationTrigger).toBeVisible()
  await navigationTrigger.click()

  const navigationSheet = page.getByRole("dialog", { name: "Điều hướng ứng dụng" })
  await expect(navigationSheet).toBeVisible()
  await navigationSheet.getByRole("link", { name: "Orders", exact: true }).click()

  await expect(page).toHaveURL(/\/orders$/)
  await expect(page.getByRole("heading", { level: 1, name: "Orders" })).toBeVisible()
  await expect(navigationSheet).toBeHidden()
})
