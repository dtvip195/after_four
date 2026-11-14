import { ChevronDown, Coffee, FileText, Settings2 } from "lucide-react"

import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogClose,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
  DialogTrigger,
} from "@/components/ui/dialog"
import {
  Drawer,
  DrawerClose,
  DrawerContent,
  DrawerDescription,
  DrawerFooter,
  DrawerHeader,
  DrawerTitle,
  DrawerTrigger,
} from "@/components/ui/drawer"
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Sheet,
  SheetClose,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/components/ui/sheet"

function OverlayDemos() {
  return (
    <div className="flex flex-wrap gap-3">
      <Dialog>
        <DialogTrigger asChild>
          <Button variant="outline" className="min-h-target px-4">
            Mở Dialog
          </Button>
        </DialogTrigger>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>Chỉnh nội dung mẫu</DialogTitle>
            <DialogDescription>
              Dialog kiểm tra focus trap, hierarchy và action alignment.
            </DialogDescription>
          </DialogHeader>
          <div className="grid gap-2">
            <Label htmlFor="dialog-name">Tên hiển thị</Label>
            <Input
              id="dialog-name"
              defaultValue="AFTER FOUR"
              className="min-h-target lg:min-h-control"
            />
          </div>
          <DialogFooter>
            <DialogClose asChild>
              <Button variant="outline" className="min-h-target">
                Hủy
              </Button>
            </DialogClose>
            <DialogClose asChild>
              <Button className="min-h-target">Lưu mẫu</Button>
            </DialogClose>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Sheet>
        <SheetTrigger asChild>
          <Button variant="outline" className="min-h-target px-4">
            Mở Sheet
          </Button>
        </SheetTrigger>
        <SheetContent className="w-full sm:max-w-md">
          <SheetHeader>
            <SheetTitle>Chi tiết minh họa</SheetTitle>
            <SheetDescription>
              Sheet giữ ngữ cảnh màn hình chính khi mở thông tin phụ.
            </SheetDescription>
          </SheetHeader>
          <div className="grid gap-4 px-4">
            <div className="rounded-lg border bg-muted p-4">
              <p className="text-sm font-semibold">AFTER FOUR</p>
              <p className="mt-1 text-sm text-muted-foreground">
                Nội dung tĩnh, không có workflow nghiệp vụ.
              </p>
            </div>
          </div>
          <SheetFooter>
            <SheetClose asChild>
              <Button className="min-h-target">Đóng Sheet</Button>
            </SheetClose>
          </SheetFooter>
        </SheetContent>
      </Sheet>

      <Drawer>
        <DrawerTrigger asChild>
          <Button variant="outline" className="min-h-target px-4">
            Mở Drawer
          </Button>
        </DrawerTrigger>
        <DrawerContent>
          <div className="mx-auto w-full max-w-lg">
            <DrawerHeader>
              <DrawerTitle>Hành động trên mobile</DrawerTitle>
              <DrawerDescription>
                Drawer kiểm tra thao tác chạm và nội dung ở cạnh dưới màn hình.
              </DrawerDescription>
            </DrawerHeader>
            <div className="px-4">
              <div className="rounded-lg border bg-muted p-4 text-sm">
                Đây chỉ là interaction demo, không phải bước thanh toán.
              </div>
            </div>
            <DrawerFooter>
              <Button className="min-h-touch">Xác nhận mẫu</Button>
              <DrawerClose asChild>
                <Button variant="outline" className="min-h-target">
                  Đóng
                </Button>
              </DrawerClose>
            </DrawerFooter>
          </div>
        </DrawerContent>
      </Drawer>

      <DropdownMenu>
        <DropdownMenuTrigger asChild>
          <Button variant="outline" className="min-h-target px-4">
            Thao tác khác
            <ChevronDown aria-hidden="true" />
          </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent className="w-56">
          <DropdownMenuLabel>Minh họa menu</DropdownMenuLabel>
          <DropdownMenuSeparator />
          <DropdownMenuItem>
            <Coffee aria-hidden="true" />
            Xem sản phẩm mẫu
          </DropdownMenuItem>
          <DropdownMenuItem>
            <FileText aria-hidden="true" />
            Xem ghi chú
          </DropdownMenuItem>
          <DropdownMenuItem disabled>
            <Settings2 aria-hidden="true" />
            Chưa khả dụng
          </DropdownMenuItem>
        </DropdownMenuContent>
      </DropdownMenu>
    </div>
  )
}

export { OverlayDemos }
