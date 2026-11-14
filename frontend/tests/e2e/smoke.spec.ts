import { expect, test, type Page } from "@playwright/test"

const criticalResourceTypes = new Set(["document", "font", "script", "stylesheet"])

function observeRuntimeFailures(page: Page) {
  const pageErrors: string[] = []
  const consoleErrors: string[] = []
  const resourceErrors: string[] = []

  page.on("pageerror", (error) => pageErrors.push(error.message))
  page.on("console", (message) => {
    if (message.type() === "error") {
      consoleErrors.push(message.text())
    }
  })
  page.on("requestfailed", (request) => {
    if (criticalResourceTypes.has(request.resourceType())) {
      resourceErrors.push(
        `${request.method()} ${request.url()}: ${request.failure()?.errorText ?? "failed"}`
      )
    }
  })
  page.on("response", (response) => {
    const request = response.request()

    if (criticalResourceTypes.has(request.resourceType()) && response.status() >= 400) {
      resourceErrors.push(`${response.status()} ${request.method()} ${response.url()}`)
    }
  })

  return { consoleErrors, pageErrors, resourceErrors }
}

const routes = [
  { path: "/", heading: "Dashboard" },
  { path: "/dashboard", heading: "Dashboard" },
  { path: "/pos", heading: "POS" },
  { path: "/upstairs-delivery", heading: "Upstairs Delivery" },
  { path: "/design-system", heading: "Component Showcase" },
] as const

for (const route of routes) {
  test(`${route.path} loads without runtime or critical resource errors`, async ({ page }) => {
    const failures = observeRuntimeFailures(page)
    const response = await page.goto(route.path)

    expect(response, `Expected a document response for ${route.path}`).not.toBeNull()
    expect(response?.ok(), `Expected ${route.path} to return a successful response`).toBe(true)
    await expect(page.getByRole("heading", { level: 1, name: route.heading })).toBeVisible()
    await page.evaluate(() => document.fonts.ready)

    expect(failures.pageErrors, "Uncaught page errors").toEqual([])
    expect(failures.consoleErrors, "Console errors").toEqual([])
    expect(failures.resourceErrors, "Critical resource errors").toEqual([])
  })
}
