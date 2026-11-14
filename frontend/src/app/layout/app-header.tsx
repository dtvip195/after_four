import { Bell, ChevronDown, UserRound } from "lucide-react"

import type { FloorId } from "@/app/components/floor-options"
import { FloorSelector } from "@/app/components/floor-selector"
import { MobileNavigation } from "@/app/layout/mobile-navigation"
import { Button } from "@/components/ui/button"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"

type AppHeaderProps = {
  pageTitle: string
  selectedFloor: FloorId
  showFloorSelector?: boolean
  onFloorChange: (floor: FloorId) => void
}

function AppHeader({
  pageTitle,
  selectedFloor,
  showFloorSelector = true,
  onFloorChange,
}: AppHeaderProps) {
  return (
    <header className="sticky top-0 z-30 border-b bg-background/95 backdrop-blur-sm">
      <div className="flex min-h-16 items-center gap-3 px-4 sm:px-5 lg:px-8">
        <MobileNavigation />

        <div className="min-w-0 flex-1">
          <p className="hidden text-meta font-semibold tracking-label text-brand-clay sm:block">
            AFTER FOUR
          </p>
          <p className="truncate text-sm font-semibold sm:mt-0.5 sm:text-base">{pageTitle}</p>
        </div>

        {showFloorSelector && (
          <FloorSelector
            value={selectedFloor}
            onValueChange={onFloorChange}
            className="hidden md:flex"
          />
        )}

        <Button
          type="button"
          variant="ghost"
          size="icon"
          className="min-h-target min-w-target"
          aria-label="Thông báo — chưa khả dụng"
          disabled
        >
          <Bell aria-hidden="true" />
        </Button>

        <DropdownMenu>
          <DropdownMenuTrigger asChild>
            <Button
              type="button"
              variant="ghost"
              className="min-h-target gap-2 px-1.5 sm:px-2"
              aria-label="Mở menu người dùng"
            >
              <span className="flex size-8 items-center justify-center rounded-lg bg-secondary text-secondary-foreground">
                <UserRound aria-hidden="true" className="size-4" />
              </span>
              <ChevronDown aria-hidden="true" className="hidden size-4 text-muted-foreground sm:block" />
            </Button>
          </DropdownMenuTrigger>
          <DropdownMenuContent align="end" className="w-60">
            <DropdownMenuLabel>Chức năng người dùng</DropdownMenuLabel>
            <DropdownMenuSeparator />
            <DropdownMenuItem disabled className="min-h-target">
              Xác thực sẽ được triển khai sau
            </DropdownMenuItem>
          </DropdownMenuContent>
        </DropdownMenu>
      </div>

      {showFloorSelector && (
        <div className="border-t px-4 py-2 md:hidden">
          <FloorSelector value={selectedFloor} onValueChange={onFloorChange} />
        </div>
      )}
    </header>
  )
}

export { AppHeader }
