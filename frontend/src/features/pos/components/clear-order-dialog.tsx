import { useState } from "react"
import { Trash2 } from "lucide-react"

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

type ClearOrderDialogProps = {
  onClear: () => void
}

function ClearOrderDialog({ onClear }: ClearOrderDialogProps) {
  const [open, setOpen] = useState(false)

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogTrigger asChild>
        <Button type="button" variant="ghost" className="min-h-target text-destructive">
          <Trash2 aria-hidden="true" />
          Xóa toàn bộ
        </Button>
      </DialogTrigger>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Xóa toàn bộ đơn demo?</DialogTitle>
          <DialogDescription>
            Thao tác này chỉ xóa local order state. Menu, bàn và dữ liệu fixture không bị ảnh hưởng.
          </DialogDescription>
        </DialogHeader>
        <DialogFooter>
          <DialogClose asChild>
            <Button type="button" variant="outline" className="min-h-target">
              Giữ lại
            </Button>
          </DialogClose>
          <Button
            type="button"
            variant="destructive"
            className="min-h-target"
            onClick={() => {
              onClear()
              setOpen(false)
            }}
          >
            Xóa toàn bộ sản phẩm
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

export { ClearOrderDialog }
