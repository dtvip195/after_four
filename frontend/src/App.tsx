import { lazy, Suspense } from "react"
import { Coffee } from "lucide-react"
import { Navigate, Route, Routes } from "react-router"

import { AppShell } from "@/app/layout/app-shell"
import { navigationItems } from "@/app/navigation/navigation-config"
import { NotFoundPage } from "@/app/pages/not-found-page"
import { PlaceholderPage } from "@/app/pages/placeholder-page"

const DesignSystemPage = lazy(() =>
  import("@/app/design-system/design-system-page").then((module) => ({
    default: module.DesignSystemPage,
  }))
)

const PosPage = lazy(() =>
  import("@/features/pos/pages/pos-page").then((module) => ({
    default: module.PosPage,
  }))
)

const UpstairsDeliveryPage = lazy(() =>
  import("@/features/upstairs-delivery/pages/upstairs-delivery-page").then((module) => ({
    default: module.UpstairsDeliveryPage,
  }))
)

function PageLoading() {
  return (
    <main
      role="status"
      className="flex min-h-svh items-center justify-center bg-background p-6 text-foreground"
    >
      <div className="flex items-center gap-3 text-sm font-medium">
        <Coffee aria-hidden="true" className="size-5 text-primary" />
        Đang tải AFTER FOUR…
      </div>
    </main>
  )
}

function App() {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/dashboard" replace />} />
      <Route
        path="/design-system"
        element={
          <Suspense fallback={<PageLoading />}>
            <DesignSystemPage />
          </Suspense>
        }
      />
      <Route element={<AppShell />}>
        <Route
          path="/upstairs-delivery"
          element={
            <Suspense fallback={<PageLoading />}>
              <UpstairsDeliveryPage />
            </Suspense>
          }
        />
        <Route
          path="/pos"
          element={
            <Suspense fallback={<PageLoading />}>
              <PosPage />
            </Suspense>
          }
        />
        {navigationItems.filter((item) => item.path !== "/pos").map((item) => (
          <Route
            key={item.path}
            path={item.path}
            element={<PlaceholderPage item={item} />}
          />
        ))}
        <Route path="*" element={<NotFoundPage />} />
      </Route>
    </Routes>
  )
}

export default App
