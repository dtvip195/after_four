type PosDemoCategoryId = "coffee" | "tea" | "non-coffee" | "other"
type PosDemoCategoryFilter = PosDemoCategoryId | "all"

type PosDemoCategory = {
  id: PosDemoCategoryId
  label: string
}

type PosDemoProduct = {
  id: string
  name: string
  categoryId: PosDemoCategoryId
  unitPriceVnd: number
  description: string
}

type PosDemoTableStatus = "ready" | "serving" | "attention"
type PosDemoTableStatusFilter = PosDemoTableStatus | "all"

type PosDemoTable = {
  id: string
  code: string
  label: string
  status: PosDemoTableStatus
}

type PosDemoOrderLine = {
  productId: string
  quantity: number
  note: string
}

type PosDemoPaymentMethod = "cash" | "bank-transfer" | "qr"

type PosDemoPaymentMethodOption = {
  id: PosDemoPaymentMethod
  label: string
  description: string
}

export type {
  PosDemoCategory,
  PosDemoCategoryFilter,
  PosDemoCategoryId,
  PosDemoOrderLine,
  PosDemoPaymentMethod,
  PosDemoPaymentMethodOption,
  PosDemoProduct,
  PosDemoTable,
  PosDemoTableStatus,
  PosDemoTableStatusFilter,
}
