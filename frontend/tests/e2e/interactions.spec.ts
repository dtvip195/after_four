import { expect, test } from "@playwright/test"

test.beforeEach(async ({ page }) => {
  await page.goto("/design-system")
  await expect(page.getByRole("heading", { level: 1, name: "Component Showcase" })).toBeVisible()
})

test("tabs switch their associated content", async ({ page }) => {
  await page.getByRole("tab", { name: "Chi tiết", exact: true }).click()
  await expect(page.getByText("Nội dung chi tiết", { exact: true })).toBeVisible()

  await page.getByRole("tab", { name: "Trống", exact: true }).click()
  await expect(page.getByText("Chưa có dữ liệu mẫu", { exact: true })).toBeVisible()
})

test("dialog opens and closes", async ({ page }) => {
  await page.getByRole("button", { name: "Mở Dialog" }).click()

  const dialog = page.getByRole("dialog", { name: "Chỉnh nội dung mẫu" })
  await expect(dialog).toBeVisible()
  await dialog.getByRole("button", { name: "Hủy" }).click()
  await expect(dialog).toBeHidden()
})

test("sheet opens and closes", async ({ page }) => {
  await page.getByRole("button", { name: "Mở Sheet" }).click()

  const sheet = page.getByRole("dialog", { name: "Chi tiết minh họa" })
  await expect(sheet).toBeVisible()
  await sheet.getByRole("button", { name: "Đóng Sheet" }).click()
  await expect(sheet).toBeHidden()
})

test("drawer opens and closes", async ({ page }) => {
  await page.getByRole("button", { name: "Mở Drawer" }).click()

  const drawer = page.getByRole("dialog", { name: "Hành động trên mobile" })
  await expect(drawer).toBeVisible()
  await drawer.getByRole("button", { name: "Đóng", exact: true }).click()
  await expect(drawer).toBeHidden()
})

test("form controls support keyboard interaction", async ({ page }) => {
  const nameInput = page.getByRole("textbox", { name: "Tên hiển thị", exact: true })
  await nameInput.focus()
  await page.keyboard.type("Quầy thử nghiệm")
  await expect(nameInput).toHaveValue("Quầy thử nghiệm")

  const areaSelect = page.getByRole("combobox", { name: "Khu vực minh họa" })
  await areaSelect.focus()
  await page.keyboard.press("Enter")
  const upperFloorOption = page.getByRole("option", { name: "Tầng 2 · mẫu" })
  await expect(upperFloorOption).toBeVisible()
  await upperFloorOption.press("Enter")
  await expect(areaSelect).toContainText("Tầng 2 · mẫu")
  await expect(upperFloorOption).toBeHidden()

  const receiptCheckbox = page.getByRole("checkbox", { name: "In biên nhận mẫu" })
  await receiptCheckbox.focus()
  await expect(receiptCheckbox).toBeChecked()
  await page.keyboard.press("Space")
  await expect(receiptCheckbox).not.toBeChecked()

  const compactRadio = page.getByRole("radio", { name: "Gọn" })
  await compactRadio.focus()
  await page.keyboard.press("Space")
  await expect(compactRadio).toBeChecked()

  const soundSwitch = page.getByRole("switch", { name: "Bật âm thanh minh họa" })
  await soundSwitch.focus()
  await expect(soundSwitch).toBeChecked()
  await page.keyboard.press("Space")
  await expect(soundSwitch).not.toBeChecked()
})

test("keyboard focus has a visible indicator", async ({ page }) => {
  const focusTarget = page.getByRole("button", { name: "Tab để focus" })
  await focusTarget.focus()
  await expect(focusTarget).toBeFocused()

  const focusStyles = await focusTarget.evaluate((element) => {
    const styles = getComputedStyle(element)

    return {
      boxShadow: styles.boxShadow,
      outlineStyle: styles.outlineStyle,
      outlineWidth: styles.outlineWidth,
    }
  })

  expect(
    focusStyles.boxShadow !== "none" ||
      (focusStyles.outlineStyle !== "none" && focusStyles.outlineWidth !== "0px")
  ).toBe(true)
})
