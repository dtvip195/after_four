import { useState } from "react"

import { deliveryDemoOrders } from "@/features/upstairs-delivery/data/delivery-demo-data"
import type {
  DeliveryDemoOrder,
  DeliveryDemoStatus,
} from "@/features/upstairs-delivery/types/upstairs-delivery"

function useDemoDeliveryQueue() {
  const [orders, setOrders] = useState<DeliveryDemoOrder[]>(deliveryDemoOrders)

  function updateStatus(orderId: string, status: DeliveryDemoStatus) {
    setOrders((currentOrders) =>
      currentOrders.map((order) =>
        order.id === orderId ? { ...order, status } : order
      )
    )
  }

  return { orders, updateStatus }
}

export { useDemoDeliveryQueue }
