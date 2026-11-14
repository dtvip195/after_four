import type { MouseEventHandler } from "react"

import { navigationGroups } from "@/app/navigation/navigation-config"
import { NavigationItem } from "@/app/navigation/navigation-item"
import { cn } from "@/lib/utils"

type ApplicationNavigationProps = {
  mode: "mobile" | "responsive"
  onNavigate?: MouseEventHandler<HTMLAnchorElement>
}

function ApplicationNavigation({ mode, onNavigate }: ApplicationNavigationProps) {
  return (
    <nav aria-label="Điều hướng ứng dụng" className="grid gap-4">
      {navigationGroups.map((group, groupIndex) => (
        <div
          key={group.label}
          className={cn(
            "grid gap-1",
            groupIndex > 0 && mode === "responsive" && "md:border-t md:pt-4 lg:border-0 lg:pt-0"
          )}
        >
          <p
            className={cn(
              "px-3 text-meta font-semibold tracking-label text-muted-foreground",
              mode === "responsive" && "md:sr-only lg:not-sr-only"
            )}
          >
            {group.label}
          </p>
          <ul className="grid gap-1">
            {group.items.map((item) => (
              <li key={item.path}>
                <NavigationItem item={item} mode={mode} onNavigate={onNavigate} />
              </li>
            ))}
          </ul>
        </div>
      ))}
    </nav>
  )
}

export { ApplicationNavigation }
