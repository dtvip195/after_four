import { Coffee, Palette } from "lucide-react"
import { Link } from "react-router"

import { ApplicationNavigation } from "@/app/navigation/application-navigation"

function AppSidebar() {
  return (
    <aside
      aria-label="Thanh điều hướng"
      className="sticky top-0 hidden h-svh w-18 shrink-0 flex-col border-r border-sidebar-border bg-sidebar text-sidebar-foreground md:flex lg:w-60"
    >
      <Link
        to="/dashboard"
        aria-label="AFTER FOUR · Dashboard"
        className="flex min-h-20 items-center justify-center gap-3 border-b border-sidebar-border px-3 outline-none focus-visible:ring-2 focus-visible:ring-sidebar-ring focus-visible:ring-inset lg:justify-start lg:px-5"
      >
        <span className="flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary text-primary-foreground">
          <Coffee aria-hidden="true" className="size-5" />
        </span>
        <span className="hidden min-w-0 lg:block">
          <span className="block text-meta font-bold tracking-label text-brand-clay">
            AFTER FOUR
          </span>
          <span className="mt-0.5 block truncate text-xs text-muted-foreground">
            Cafe management
          </span>
        </span>
      </Link>

      <div className="min-h-0 flex-1 overflow-y-auto px-2 py-5 lg:px-3">
        <ApplicationNavigation mode="responsive" />
      </div>

      <div className="border-t border-sidebar-border p-2 lg:p-3">
        <Link
          to="/design-system"
          aria-label="Design system"
          className="flex min-h-target items-center justify-center gap-3 rounded-lg px-2 text-sm font-medium text-muted-foreground outline-none hover:bg-sidebar-accent hover:text-sidebar-accent-foreground focus-visible:ring-2 focus-visible:ring-sidebar-ring focus-visible:ring-offset-2 focus-visible:ring-offset-sidebar lg:justify-start lg:px-3"
        >
          <Palette aria-hidden="true" className="size-5 shrink-0" />
          <span className="sr-only lg:not-sr-only">Design system</span>
        </Link>
      </div>
    </aside>
  )
}

export { AppSidebar }
