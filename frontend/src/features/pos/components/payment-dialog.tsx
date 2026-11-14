import { CheckCircle2, CircleAlert, Info, ReceiptText } from "lucide-react"
import { useState } from "react"

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
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { PaymentConfirmationDialog } from "@/features/pos/components/payment-confirmation-dialog"
import { PaymentMethodSelector } from "@/features/pos/components/payment-method-selector"
import { PaymentOrderSummary } from "@/features/pos/components/payment-order-summary"
import { posDemoPaymentMethods } from "@/features/pos/data/payment-demo-data"
import { posDemoProducts } from "@/features/pos/data/pos-demo-data"
import { formatVnd } from "@/features/pos/lib/format-vnd"
import { getDemoOrderSummary } from "@/features/pos/lib/get-demo-order-summary"
import {
  getCashChangeVnd,
  getCashSuggestionsVnd,
  parseVndInput,
} from "@/features/pos/lib/payment-calculations"
import type {
  PosDemoOrderLine,
  PosDemoPaymentMethod,
} from "@/features/pos/types/pos"

type PaymentDialogProps = {
  open: boolean
  orderLines: PosDemoOrderLine[]
  onOpenChange: (open: boolean) => void
}

function PaymentDialog({ open, orderLines, onOpenChange }: PaymentDialogProps) {
  const [selectedMethod, setSelectedMethod] = useState<PosDemoPaymentMethod>()
  const [receivedAmountInput, setReceivedAmountInput] = useState("")
  const [showValidation, setShowValidation] = useState(false)
  const [confirmationOpen, setConfirmationOpen] = useState(false)
  const [isSuccessful, setIsSuccessful] = useState(false)
  const summary = getDemoOrderSummary(orderLines, posDemoProducts)
  const receivedAmountVnd = parseVndInput(receivedAmountInput)
  const changeVnd =
    receivedAmountVnd === undefined
      ? undefined
      : getCashChangeVnd(receivedAmountVnd, summary.subtotalVnd)
  const cashSuggestions = getCashSuggestionsVnd(summary.subtotalVnd)
  const methodLabel = posDemoPaymentMethods.find((item) => item.id === selectedMethod)?.label

  const cashValidationMessage = (() => {
    if (selectedMethod !== "cash" || !showValidation) return undefined
    if (receivedAmountInput.trim().length === 0) return "Nhập số tiền khách đưa để tiếp tục."
    if (receivedAmountVnd === undefined) return "Số tiền chỉ gồm chữ số và phải là số nguyên VND hợp lệ."
    if (receivedAmountVnd < summary.subtotalVnd) {
      return `Số tiền khách đưa còn thiếu ${formatVnd(summary.subtotalVnd - receivedAmountVnd)}.`
    }
    return undefined
  })()

  const handleMethodChange = (method: PosDemoPaymentMethod) => {
    setSelectedMethod(method)
    setReceivedAmountInput("")
    setShowValidation(false)
    setConfirmationOpen(false)
  }

  const handleContinue = () => {
    setShowValidation(true)

    if (!selectedMethod) return
    if (selectedMethod === "cash" && changeVnd === undefined) return

    setConfirmationOpen(true)
  }

  const handleConfirm = () => {
    setConfirmationOpen(false)
    setIsSuccessful(true)
  }

  return (
    <>
      <Dialog open={open} onOpenChange={onOpenChange}>
        <DialogContent
          showCloseButton={!confirmationOpen}
          className="max-h-[calc(100svh-1rem)] gap-0 overflow-y-auto p-0 sm:max-w-3xl"
        >
          {isSuccessful ? (
            <div className="p-5 sm:p-6">
              <div className="mx-auto flex size-12 items-center justify-center rounded-full bg-success/10 text-success">
                <CheckCircle2 aria-hidden="true" className="size-6" />
              </div>
              <DialogHeader className="mt-4 text-center">
                <DialogTitle className="text-page">Thanh toán demo thành công</DialogTitle>
                <DialogDescription>
                  Trạng thái này chỉ tồn tại trong Payment UI. Không có giao dịch tài chính thật.
                </DialogDescription>
              </DialogHeader>

              <dl className="mx-auto mt-5 grid max-w-md gap-3 rounded-xl border bg-muted/20 p-4 text-sm">
                <div className="flex justify-between gap-4">
                  <dt className="text-muted-foreground">Phương thức demo</dt>
                  <dd className="font-semibold">{methodLabel}</dd>
                </div>
                <div className="flex justify-between gap-4 border-t pt-3">
                  <dt className="font-semibold">Tạm tính đơn</dt>
                  <dd className="numeric-data font-bold text-brand-coffee">
                    {formatVnd(summary.subtotalVnd)}
                  </dd>
                </div>
              </dl>

              <Alert className="mx-auto mt-4 max-w-md">
                <Info aria-hidden="true" />
                <AlertTitle>Đơn vẫn được giữ nguyên</AlertTitle>
                <AlertDescription>
                  Prototype không tự xóa order, giải phóng bàn hoặc in hóa đơn.
                </AlertDescription>
              </Alert>

              <Button type="button" className="mt-5 min-h-touch w-full" onClick={() => onOpenChange(false)}>
                Quay lại đơn
              </Button>
            </div>
          ) : (
            <>
              <div className="border-b p-5 pr-12 sm:p-6 sm:pr-12">
                <DialogHeader>
                  <div className="flex items-center gap-2 text-brand-clay">
                    <ReceiptText aria-hidden="true" className="size-4" />
                    <span className="text-meta font-bold tracking-label">PAYMENT UI</span>
                  </div>
                  <DialogTitle className="text-page">Thanh toán demo</DialogTitle>
                  <DialogDescription>
                    Xem lại đơn và mô phỏng lựa chọn thanh toán. Không có giao dịch thật.
                  </DialogDescription>
                </DialogHeader>
              </div>

              <div className="grid min-w-0 gap-5 p-5 sm:p-6 lg:grid-cols-[minmax(0,0.9fr)_minmax(0,1.1fr)]">
                <PaymentOrderSummary orderLines={orderLines} subtotalVnd={summary.subtotalVnd} />

                <div className="min-w-0 space-y-5">
                  <PaymentMethodSelector
                    selectedMethod={selectedMethod}
                    onMethodChange={handleMethodChange}
                  />

                  {!selectedMethod && showValidation && (
                    <Alert variant="destructive">
                      <CircleAlert aria-hidden="true" />
                      <AlertTitle>Chưa chọn phương thức</AlertTitle>
                      <AlertDescription>Chọn một phương thức thanh toán demo để tiếp tục.</AlertDescription>
                    </Alert>
                  )}

                  {selectedMethod === "cash" && (
                    <section aria-labelledby="cash-payment-title" className="rounded-xl border p-4">
                      <h3 id="cash-payment-title" className="text-sm font-semibold">
                        Tiền mặt demo
                      </h3>
                      <p className="mt-1 text-xs text-muted-foreground">
                        Cần thanh toán: <span className="numeric-data font-semibold text-foreground">{formatVnd(summary.subtotalVnd)}</span>
                      </p>

                      <div className="mt-4 grid gap-2">
                        <Label htmlFor="received-amount-vnd">Số tiền khách đưa</Label>
                        <Input
                          id="received-amount-vnd"
                          inputMode="numeric"
                          autoComplete="off"
                          placeholder="Ví dụ: 100000"
                          value={receivedAmountInput}
                          aria-invalid={Boolean(cashValidationMessage)}
                          aria-describedby={cashValidationMessage ? "cash-payment-error" : "cash-payment-help"}
                          onChange={(event) => {
                            setReceivedAmountInput(event.target.value)
                            setShowValidation(true)
                          }}
                        />
                        <p id="cash-payment-help" className="text-xs text-muted-foreground">
                          Nhập số nguyên VND, không dùng dấu phân cách.
                        </p>
                      </div>

                      <div className="mt-3 flex flex-wrap gap-2" aria-label="Gợi ý tiền khách đưa">
                        {cashSuggestions.map((amount) => (
                          <Button
                            key={amount}
                            type="button"
                            variant="outline"
                            size="sm"
                            className="min-h-target"
                            aria-label={`Dùng số tiền ${formatVnd(amount)}`}
                            onClick={() => {
                              setReceivedAmountInput(String(amount))
                              setShowValidation(true)
                            }}
                          >
                            {formatVnd(amount)}
                          </Button>
                        ))}
                      </div>

                      {cashValidationMessage && (
                        <p id="cash-payment-error" role="alert" className="mt-3 text-sm font-medium text-destructive">
                          {cashValidationMessage}
                        </p>
                      )}

                      {changeVnd !== undefined && (
                        <div className="mt-4 flex items-end justify-between gap-4 border-t pt-4" aria-live="polite">
                          <span className="text-sm font-semibold">Tiền thừa dự kiến</span>
                          <span className="numeric-data text-lg font-bold text-brand-coffee">
                            {formatVnd(changeVnd)}
                          </span>
                        </div>
                      )}
                    </section>
                  )}

                  {(selectedMethod === "bank-transfer" || selectedMethod === "qr") && (
                    <Alert>
                      <Info aria-hidden="true" />
                      <AlertTitle>Hướng dẫn {methodLabel} mô phỏng</AlertTitle>
                      <AlertDescription>
                        Chưa có tài khoản, mã QR hoặc cổng thanh toán thật. Tiếp tục chỉ để xem luồng xác nhận UI.
                      </AlertDescription>
                    </Alert>
                  )}
                </div>
              </div>

              <DialogFooter className="mx-0 mb-0 px-5 py-4 sm:px-6">
                <Button type="button" variant="outline" onClick={() => onOpenChange(false)}>
                  Đóng
                </Button>
                <Button type="button" className="min-h-touch" onClick={handleContinue}>
                  Tiếp tục xác nhận
                </Button>
              </DialogFooter>
            </>
          )}
        </DialogContent>
      </Dialog>

      {selectedMethod && (
        <PaymentConfirmationDialog
          changeVnd={changeVnd}
          method={selectedMethod}
          open={confirmationOpen}
          receivedAmountVnd={receivedAmountVnd}
          subtotalVnd={summary.subtotalVnd}
          onConfirm={handleConfirm}
          onOpenChange={setConfirmationOpen}
        />
      )}
    </>
  )
}

export { PaymentDialog }
