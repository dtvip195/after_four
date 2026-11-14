import { useState } from "react"
import { Coffee, Menu, Palette } from "lucide-react"
import { Link } from "react-router"

import { ApplicationNavigation } from "@/app/navigation/application-navigation"
import { Button } from "@/components/ui/button"
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet"

function MobileNavigation() {
  const [open, setOpen] = useState(false)

  return (
    <Sheet open={open} onOpenChange={setOpen}>
      <SheetTrigger asChild>
        <Button
          type="button"
          variant="outline"
          size="icon"
          className="min-h-target min-w-target md:hidden"
          aria-label="Mở điều hướng"
        >
          <Menu aria-hidden="true" />
        </Button>
      </SheetTrigger>
      <SheetContent
        side="left"
        className="w-[min(20rem,calc(100vw-2rem))] gap-0 p-0 sm:max-w-xs"
      >
        <SheetHeader className="border-b border-sidebar-border bg-sidebar text-left">
          <div className="flex items-center gap-3 pr-10">
            <span className="flex size-10 shrink-0 items-center justify-center rounded-xl bg-primary text-primary-foreground">
              <Coffee aria-hidden="true" className="size-5" />
            </span>
            <div>
              <SheetTitle>Điều hướng ứng dụng</SheetTitle>
              <SheetDescription>AFTER FOUR · Cafe management</SheetDescription>
            </div>
          </div>
        </SheetHeader>
        <div className="min-h-0 flex-1 overflow-y-auto px-3 py-5">
          <ApplicationNavigation mode="mobile" onNavigate={() => setOpen(false)} />
        </div>
        <div className="border-t border-sidebar-border p-3">
          <Button asChild variant="ghost" className="min-h-target w-full justify-start">
            <Link to="/design-system" onClick={() => setOpen(false)}>
              <Palette aria-hidden="true" />
              Design system
            </Link>
          </Button>
        </div>
      </SheetContent>
    </Sheet>
  )
}

export { MobileNavigation }
