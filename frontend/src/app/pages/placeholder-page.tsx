import { Building2 } from "lucide-react"
import { useOutletContext } from "react-router"

import type { AppShellOutletContext } from "@/app/layout/app-shell"
import type { NavigationItem } from "@/app/navigation/navigation-config"

type PlaceholderPageProps = {
  item: NavigationItem
}

function PlaceholderPage({ item }: PlaceholderPageProps) {
  const { selectedFloorLabel } = useOutletContext<AppShellOutletContext>()
  const Icon = item.icon

  return (
    <div>
      <header className="flex flex-col gap-5 border-b pb-6 sm:flex-row sm:items-end sm:justify-between">
        <div className="min-w-0">
          <p className="text-meta font-bold tracking-label text-brand-clay">
            APPLICATION SHELL
          </p>
          <h1 className="mt-2 text-page font-semibold tracking-heading sm:text-display">
            {item.title}
          </h1>
          <p className="mt-2 max-w-2xl text-sm leading-6 text-muted-foreground sm:text-base">
            {item.description}
          </p>
        </div>
        <div
          aria-label={`Phạm vi hiện tại: ${selectedFloorLabel}`}
          className="flex min-h-target w-fit shrink-0 items-center gap-2 rounded-lg border bg-card px-3 text-sm font-medium"
        >
          <Building2 aria-hidden="true" className="size-4 text-brand-clay" />
          {selectedFloorLabel}
        </div>
      </header>

      <section aria-labelledby={`${item.title.toLowerCase()}-placeholder-title`} className="py-10 md:py-14">
        <div className="max-w-2xl border-l-2 border-brand-clay pl-5 sm:pl-6">
          <span className="flex size-11 items-center justify-center rounded-xl bg-accent text-accent-foreground">
            <Icon aria-hidden="true" className="size-5" />
          </span>
          <h2
            id={`${item.title.toLowerCase()}-placeholder-title`}
            className="mt-5 text-section font-semibold tracking-heading"
          >
            Nền tảng {item.title} đã sẵn sàng
          </h2>
          <p className="mt-2 text-sm leading-6 text-muted-foreground sm:text-base">
            Route, navigation và layout dùng chung đã được thiết lập. Chức năng nghiệp vụ của
            khu vực này sẽ được thiết kế và triển khai trong phase riêng.
          </p>
        </div>
      </section>
    </div>
  )
}

export { PlaceholderPage }
