import type { MouseEventHandler } from "react"
import { NavLink } from "react-router"

import type { NavigationItem as NavigationItemType } from "@/app/navigation/navigation-config"
import { Tooltip, TooltipContent, TooltipTrigger } from "@/components/ui/tooltip"
import { cn } from "@/lib/utils"

type NavigationItemProps = {
  item: NavigationItemType
  mode: "mobile" | "responsive"
  onNavigate?: MouseEventHandler<HTMLAnchorElement>
}

function NavigationItem({ item, mode, onNavigate }: NavigationItemProps) {
  const Icon = item.icon
  const link = (
    <NavLink
      to={item.path}
      end
      aria-label={item.title}
      onClick={onNavigate}
      className={({ isActive }) =>
        cn(
          "relative flex min-h-target w-full items-center gap-3 rounded-lg px-3 text-sm font-medium outline-none transition-colors focus-visible:ring-2 focus-visible:ring-sidebar-ring focus-visible:ring-offset-2 focus-visible:ring-offset-sidebar",
          mode === "responsive" && "md:justify-center md:px-2 lg:justify-start lg:px-3",
          isActive
            ? "bg-sidebar-accent text-sidebar-accent-foreground"
            : "text-muted-foreground hover:bg-sidebar-accent/60 hover:text-sidebar-foreground"
        )
      }
    >
      {({ isActive }) => (
        <>
          <span
            aria-hidden="true"
            className={cn(
              "absolute inset-y-2 left-0 w-0.5 rounded-full bg-transparent",
              isActive && "bg-brand-clay"
            )}
          />
          <Icon aria-hidden="true" className="size-5 shrink-0" />
          <span className={cn(mode === "responsive" && "md:sr-only lg:not-sr-only")}>
            {item.title}
          </span>
        </>
      )}
    </NavLink>
  )

  if (mode === "mobile") {
    return link
  }

  return (
    <Tooltip>
      <TooltipTrigger asChild>{link}</TooltipTrigger>
      <TooltipContent side="right" className="lg:hidden">
        {item.title}
      </TooltipContent>
    </Tooltip>
  )
}

export { NavigationItem }
