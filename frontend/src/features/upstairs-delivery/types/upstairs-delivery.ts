type DeliveryDemoStatus = "waiting" | "delivering" | "delivered"
type DeliveryDemoStatusFilter = DeliveryDemoStatus | "all"

type DeliveryDemoItem = {
  id: string
  name: string
  quantity: number
}

type DeliveryDemoOrder = {
  id: string
  code: string
  tableCode: string
  floorLabel: "Tầng 2"
  createdAtLabel: string
  items: DeliveryDemoItem[]
  note: string
  status: DeliveryDemoStatus
}

type DeliveryDemoStatusOption = {
  id: DeliveryDemoStatus
  label: string
  description: string
}

export type {
  DeliveryDemoItem,
  DeliveryDemoOrder,
  DeliveryDemoStatus,
  DeliveryDemoStatusFilter,
  DeliveryDemoStatusOption,
}
