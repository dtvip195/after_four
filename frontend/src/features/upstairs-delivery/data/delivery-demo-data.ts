import type {
  DeliveryDemoOrder,
  DeliveryDemoStatusOption,
} from "@/features/upstairs-delivery/types/upstairs-delivery"

const deliveryDemoStatuses: DeliveryDemoStatusOption[] = [
  {
    id: "waiting",
    label: "Chờ chuẩn bị",
    description: "Nhãn minh họa cho đơn đang chờ xử lý.",
  },
  {
    id: "delivering",
    label: "Đang giao",
    description: "Nhãn minh họa cho đơn đang được đưa lên tầng 2.",
  },
  {
    id: "delivered",
    label: "Đã giao",
    description: "Nhãn minh họa cho đơn đã được xác nhận tại giao diện.",
  },
]

const deliveryDemoOrders: DeliveryDemoOrder[] = [
  {
    id: "delivery-demo-201",
    code: "AF-D201",
    tableCode: "T2-03",
    floorLabel: "Tầng 2",
    createdAtLabel: "16:04",
    status: "waiting",
    note: "Đặt ở đầu bàn, tránh làm phiền khách đang họp.",
    items: [
      { id: "delivery-demo-201-latte", name: "Latte", quantity: 2 },
      { id: "delivery-demo-201-peach-tea", name: "Peach Tea", quantity: 1 },
    ],
  },
  {
    id: "delivery-demo-202",
    code: "AF-D202",
    tableCode: "T2-05",
    floorLabel: "Tầng 2",
    createdAtLabel: "16:08",
    status: "waiting",
    note: "",
    items: [{ id: "delivery-demo-202-espresso", name: "Espresso", quantity: 1 }],
  },
  {
    id: "delivery-demo-203",
    code: "AF-D203",
    tableCode: "T2-01",
    floorLabel: "Tầng 2",
    createdAtLabel: "16:11",
    status: "waiting",
    note: "Giao cùng hai ly nước lọc demo.",
    items: [
      { id: "delivery-demo-203-cappuccino", name: "Cappuccino", quantity: 1 },
      { id: "delivery-demo-203-cacao", name: "Cacao", quantity: 1 },
    ],
  },
  {
    id: "delivery-demo-204",
    code: "AF-D204",
    tableCode: "T2-04",
    floorLabel: "Tầng 2",
    createdAtLabel: "16:13",
    status: "delivering",
    note: "Khách ngồi gần cửa sổ.",
    items: [
      { id: "delivery-demo-204-americano", name: "Americano", quantity: 2 },
      { id: "delivery-demo-204-sparkling", name: "Sparkling Water", quantity: 1 },
    ],
  },
  {
    id: "delivery-demo-205",
    code: "AF-D205",
    tableCode: "T2-02",
    floorLabel: "Tầng 2",
    createdAtLabel: "15:52",
    status: "delivered",
    note: "",
    items: [{ id: "delivery-demo-205-milk-tea", name: "Milk Tea", quantity: 1 }],
  },
  {
    id: "delivery-demo-206",
    code: "AF-D206",
    tableCode: "T2-06",
    floorLabel: "Tầng 2",
    createdAtLabel: "15:57",
    status: "delivered",
    note: "Ghi chú giao hàng minh họa đã hoàn tất.",
    items: [
      { id: "delivery-demo-206-latte", name: "Latte", quantity: 1 },
      { id: "delivery-demo-206-cacao", name: "Cacao", quantity: 2 },
    ],
  },
]

function getDeliveryDemoStatusLabel(status: DeliveryDemoOrder["status"]) {
  return deliveryDemoStatuses.find((item) => item.id === status)?.label ?? status
}

function getDeliveryDemoTotalQuantity(order: DeliveryDemoOrder) {
  return order.items.reduce((total, item) => total + item.quantity, 0)
}

export {
  deliveryDemoOrders,
  deliveryDemoStatuses,
  getDeliveryDemoStatusLabel,
  getDeliveryDemoTotalQuantity,
}
