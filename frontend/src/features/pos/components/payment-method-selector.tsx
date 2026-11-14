import { Banknote, Landmark, QrCode } from "lucide-react"

import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import { posDemoPaymentMethods } from "@/features/pos/data/payment-demo-data"
import type { PosDemoPaymentMethod } from "@/features/pos/types/pos"

const paymentMethodIcons = {
  cash: Banknote,
  "bank-transfer": Landmark,
  qr: QrCode,
} satisfies Record<PosDemoPaymentMethod, typeof Banknote>

type PaymentMethodSelectorProps = {
  selectedMethod: PosDemoPaymentMethod | undefined
  onMethodChange: (method: PosDemoPaymentMethod) => void
}

function PaymentMethodSelector({
  selectedMethod,
  onMethodChange,
}: PaymentMethodSelectorProps) {
  return (
    <fieldset>
      <legend className="text-sm font-semibold">Phương thức thanh toán demo</legend>
      <RadioGroup
        className="mt-3 grid gap-2 sm:grid-cols-3 lg:grid-cols-1"
        aria-label="Phương thức thanh toán demo"
        value={selectedMethod ?? ""}
        onValueChange={(value) => onMethodChange(value as PosDemoPaymentMethod)}
      >
        {posDemoPaymentMethods.map((method) => {
          const Icon = paymentMethodIcons[method.id]

          return (
            <Label
              key={method.id}
              htmlFor={`payment-method-${method.id}`}
              className="group flex min-h-touch cursor-pointer items-start gap-3 rounded-lg border bg-card p-3 transition-colors has-data-checked:border-brand-coffee has-data-checked:bg-brand-coffee/5 has-focus-visible:ring-3 has-focus-visible:ring-ring/50"
            >
              <RadioGroupItem
                id={`payment-method-${method.id}`}
                value={method.id}
                className="mt-0.5"
              />
              <span className="min-w-0">
                <span className="flex items-center gap-2 font-semibold">
                  <Icon aria-hidden="true" className="size-4 text-brand-clay" />
                  {method.label}
                </span>
                <span className="mt-1 block text-xs leading-5 font-normal text-muted-foreground">
                  {method.description}
                </span>
              </span>
            </Label>
          )
        })}
      </RadioGroup>
    </fieldset>
  )
}

export { PaymentMethodSelector }
