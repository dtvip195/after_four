import { AlertTriangle } from "lucide-react"

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Button } from "@/components/ui/button"
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogFooter,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog"
import { posDemoPaymentMethods } from "@/features/pos/data/payment-demo-data"
import { formatVnd } from "@/features/pos/lib/format-vnd"
import type { PosDemoPaymentMethod } from "@/features/pos/types/pos"

type PaymentConfirmationDialogProps = {
  changeVnd: number | undefined
  method: PosDemoPaymentMethod
  open: boolean
  receivedAmountVnd: number | undefined
  subtotalVnd: number
  onConfirm: () => void
  onOpenChange: (open: boolean) => void
}

function PaymentConfirmationDialog({
  changeVnd,
  method,
  open,
  receivedAmountVnd,
  subtotalVnd,
  onConfirm,
  onOpenChange,
}: PaymentConfirmationDialogProps) {
  const methodLabel = posDemoPaymentMethods.find((item) => item.id === method)?.label ?? method

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="sm:max-w-md">
        <DialogHeader>
          <DialogTitle>Xác nhận thanh toán demo</DialogTitle>
          <DialogDescription>
            Kiểm tra lại thông tin mô phỏng trước khi xác nhận trạng thái giao diện.
          </DialogDescription>
        </DialogHeader>

        <dl className="grid gap-3 rounded-xl border bg-muted/20 p-4 text-sm">
          <div className="flex justify-between gap-4">
            <dt className="text-muted-foreground">Phương thức</dt>
            <dd className="font-semibold">{methodLabel}</dd>
          </div>
          <div className="flex justify-between gap-4">
            <dt className="text-muted-foreground">Tạm tính demo</dt>
            <dd className="numeric-data font-semibold">{formatVnd(subtotalVnd)}</dd>
          </div>
          {method === "cash" && receivedAmountVnd !== undefined && changeVnd !== undefined && (
            <>
              <div className="flex justify-between gap-4">
                <dt className="text-muted-foreground">Khách đưa</dt>
                <dd className="numeric-data font-semibold">{formatVnd(receivedAmountVnd)}</dd>
              </div>
              <div className="flex justify-between gap-4 border-t pt-3">
                <dt className="font-semibold">Tiền thừa dự kiến</dt>
                <dd className="numeric-data font-bold text-brand-coffee">{formatVnd(changeVnd)}</dd>
              </div>
            </>
          )}
        </dl>

        <Alert>
          <AlertTriangle aria-hidden="true" />
          <AlertTitle>Chỉ xác nhận trạng thái demo</AlertTitle>
          <AlertDescription>
            Thao tác này không nhận tiền, gửi request, in hóa đơn hoặc hoàn tất đơn thật.
          </AlertDescription>
        </Alert>

        <DialogFooter>
          <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
            Quay lại Payment UI
          </Button>
          <Button type="button" onClick={onConfirm}>
            Xác nhận thanh toán demo
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

export { PaymentConfirmationDialog }
