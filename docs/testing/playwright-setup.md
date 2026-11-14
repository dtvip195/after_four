# AFTER FOUR — Playwright setup

> Phase 3.2.4 · Chromium-only end-to-end browser checks for the frontend.

## Scope

Playwright verifies the existing foundation page and Component Showcase. It does not add a POS Application Shell, business behavior, accessibility scanning, or screenshot diff baselines.

## Installation

From `frontend/`, install the test runner and the single supported browser:

```bash
npm install --save-dev @playwright/test
npx playwright install chromium
```

The browser command installs Chromium, its headless shell, and Playwright's required FFmpeg helper in the Playwright cache. It does not install Firefox or WebKit. Re-run the browser command after a Playwright upgrade when its required Chromium revision changes.

## Commands

Run all E2E tests headlessly:

```bash
npm run test:e2e
```

Run with a visible Chromium window:

```bash
npm run test:e2e:headed
```

Open Playwright UI Mode for interactive execution and debugging:

```bash
npm run test:e2e:ui
```

The Playwright web server configuration starts Vite automatically at `http://127.0.0.1:5173` and waits until it is available. A separately started dev server is not required.

## Artifacts, screenshots, and traces

- Test output is stored in `frontend/test-results/`.
- The HTML report is stored in `frontend/playwright-report/`.
- A full-page Design System screenshot is attached for 390 × 844, 768 × 1024, and 1440 × 900.
- Automatic failure screenshots use `screenshot: "only-on-failure"`.
- One retry is configured, and `trace: "on-first-retry"` records the retry.
- Artifact and report folders are ignored by Git.

Open the latest HTML report:

```bash
npx playwright show-report
```

Open a trace directly:

```bash
npx playwright show-trace test-results/path/to/trace.zip
```

## Coverage

### Route smoke tests

- `/` and `/design-system` return successful document responses.
- Each route renders its expected level-one heading.
- Uncaught page errors and browser console errors fail the test.
- Failed or HTTP-error document, script, stylesheet, and font resources fail the test.

### Responsive checks

- Viewports: 390 × 844, 768 × 1024, and 1440 × 900.
- Main content and all major showcase sections render.
- The document and body do not introduce horizontal overflow.
- Major headings stay inside the viewport horizontally.
- A table may scroll horizontally only when its own `overflow-x: auto` container contains that overflow.

### Interaction checks

- Tabs switch visible content.
- Dialog, Sheet, and Drawer open and close through their accessible controls.
- Text input, Select, Checkbox, Radio Group, and Switch respond to keyboard input.
- The explicit focus specimen receives focus and exposes a visible focus style.

### Screenshot checks

Full-page Component Showcase screenshots are generated as test artifacts at all three target widths. They are review artifacts, not visual-regression snapshots, so this phase does not compare pixels against committed baselines.

## Remaining limitations

- Chromium is the only installed and configured browser.
- There is no axe integration or automated WCAG audit.
- There is no visual-regression baseline or pixel-diff threshold.
- Tests do not replace manual checks with a screen reader, touch hardware, 200% zoom, or OS text scaling.
- The routes use the current minimal `App.tsx` pathname handling; routing behavior beyond `/` and `/design-system` is not covered.
- CI workflow configuration is outside Phase 3.2.4.

## Phase 3.2.4 verification result

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, no warnings |
| `npm run build` | Pass |
| Interaction tests | 6/6 pass |
| Full `npm run test:e2e` | 13 pass, 1 fail |

The remaining failure is the 390 × 844 responsive check. The document is 451px wide at a 390px viewport. Runtime isolation identified the Table specimen inside the Primitives section as the source: its grid track expands to a 435px minimum width instead of containing the table's intended horizontal scroll. Hiding only that specimen during diagnosis returns the document width to 390px.

The 768 × 1024 and 1440 × 900 responsive checks pass. Phase 3.2.4 does not change existing UI solely to make a test pass, so the mobile assertion remains active and failing for owner review rather than being skipped or weakened. That run generated a retry trace and failure screenshot under `frontend/test-results/`; later Playwright runs replace generated artifacts.

## Phase 3.2.5 mobile overflow fix

The mobile failure was caused by the Table `Specimen` acting as a grid item with the default `min-width: auto`. Its table minimum-content contribution expanded the parent grid track from the available 358px to approximately 435px. The table wrapper already used `overflow-x: auto`, but the expanded grid track prevented that overflow from being contained locally.

The Table specimen in `frontend/src/app/design-system/primitives-section.tsx` now receives `min-w-0`. This changes only the affected grid-item boundary: the table retains its intrinsic width and scrolls inside the existing table wrapper on mobile. No global overflow masking, table content changes, or responsive assertion changes were made.

Verified layout measurements:

| Viewport | Document width | Table wrapper client/scroll width | Result |
| --- | --- | --- | --- |
| 390 × 844 | 390px, previously 451px | 356px / 433px | No document overflow; intentional table scroll remains |
| 768 × 1024 | 768px | 718px / 718px | Pass, no regression |
| 1440 × 900 | 1440px | 1374px / 1374px | Pass, no regression |

Final Phase 3.2.5 verification:

| Check | Result |
| --- | --- |
| `npm run typecheck` | Pass |
| `npm run lint` | Pass, no warnings |
| `npm run build` | Pass |
| `npm run test:e2e` | 14 passed, 0 failed |
