import { useState } from "react"
import { Outlet, useLocation } from "react-router"

import type { FloorId } from "@/app/components/floor-options"
import { getFloorLabel } from "@/app/components/floor-options"
import { AppHeader } from "@/app/layout/app-header"
import { AppSidebar } from "@/app/layout/app-sidebar"
import { findNavigationItem } from "@/app/navigation/navigation-config"

const standalonePageTitles: Record<string, string> = {
  "/upstairs-delivery": "Upstairs Delivery",
}

type AppShellOutletContext = {
  selectedFloor: FloorId
  selectedFloorLabel: string
}

function AppShell() {
  const location = useLocation()
  const [selectedFloor, setSelectedFloor] = useState<FloorId>("floor-1")
  const navigationItem = findNavigationItem(location.pathname)
  const pageTitle = navigationItem?.title ?? standalonePageTitles[location.pathname] ?? "Không tìm thấy trang"

  return (
    <div className="flex min-h-svh min-w-0 bg-background text-foreground">
      <a
        href="#main-content"
        className="fixed top-2 left-2 z-50 -translate-y-20 rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground outline-none transition-transform focus:translate-y-0 focus:ring-2 focus:ring-ring focus:ring-offset-2"
      >
        Chuyển đến nội dung chính
      </a>
      <AppSidebar />
      <div className="flex min-w-0 flex-1 flex-col">
        <AppHeader
          pageTitle={pageTitle}
          selectedFloor={selectedFloor}
          showFloorSelector={location.pathname !== "/upstairs-delivery"}
          onFloorChange={setSelectedFloor}
        />
        <main id="main-content" className="min-w-0 flex-1 px-4 py-6 sm:px-5 md:py-8 lg:px-8">
          <div className="mx-auto w-full max-w-[96rem]">
            <Outlet
              context={{
                selectedFloor,
                selectedFloorLabel: getFloorLabel(selectedFloor),
              } satisfies AppShellOutletContext}
            />
          </div>
        </main>
      </div>
    </div>
  )
}

export { AppShell }
export type { AppShellOutletContext }
