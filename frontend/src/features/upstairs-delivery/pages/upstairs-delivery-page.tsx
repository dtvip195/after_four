import { ArrowUpFromLine, Info } from "lucide-react"
import { useMemo, useState } from "react"

import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Badge } from "@/components/ui/badge"
import { DeliveryDetail } from "@/features/upstairs-delivery/components/delivery-detail"
import { DeliveryFilters } from "@/features/upstairs-delivery/components/delivery-filters"
import { DeliveryQueueGroup } from "@/features/upstairs-delivery/components/delivery-queue-group"
import {
  deliveryDemoStatuses,
  getDeliveryDemoStatusLabel,
} from "@/features/upstairs-delivery/data/delivery-demo-data"
import { useDemoDeliveryQueue } from "@/features/upstairs-delivery/hooks/use-demo-delivery-queue"
import { useMediaQuery } from "@/features/upstairs-delivery/hooks/use-media-query"
import type {
  DeliveryDemoStatus,
  DeliveryDemoStatusFilter,
} from "@/features/upstairs-delivery/types/upstairs-delivery"

function UpstairsDeliveryPage() {
  const { orders, updateStatus } = useDemoDeliveryQueue()
  const [searchQuery, setSearchQuery] = useState("")
  const [statusFilter, setStatusFilter] = useState<DeliveryDemoStatusFilter>("all")
  const [selectedOrderId, setSelectedOrderId] = useState<string>()
  const [detailOpen, setDetailOpen] = useState(false)
  const [updateMessage, setUpdateMessage] = useState("")
  const isDesktop = useMediaQuery("(min-width: 1280px)")

  const normalizedQuery = searchQuery.trim().toLocaleLowerCase("vi")
  const visibleStatuses = statusFilter === "all"
    ? deliveryDemoStatuses
    : deliveryDemoStatuses.filter((status) => status.id === statusFilter)
  const filteredOrders = useMemo(
    () => orders.filter((order) =>
      normalizedQuery.length === 0 ||
      order.code.toLocaleLowerCase("vi").includes(normalizedQuery) ||
      order.tableCode.toLocaleLowerCase("vi").includes(normalizedQuery)
    ),
    [normalizedQuery, orders]
  )
  const selectedOrder = orders.find((order) => order.id === selectedOrderId)

  function resetFilters() {
    setSearchQuery("")
    setStatusFilter("all")
  }

  function selectOrder(orderId: string) {
    setSelectedOrderId(orderId)
    setDetailOpen(true)
  }

  function closeDetail() {
    setSelectedOrderId(undefined)
    setDetailOpen(false)
  }

  function changeSelectedOrderStatus(status: DeliveryDemoStatus) {
    if (!selectedOrder) return
    updateStatus(selectedOrder.id, status)
    setUpdateMessage(`${selectedOrder.code} đã chuyển sang ${getDeliveryDemoStatusLabel(status)} trong dữ liệu demo.`)
  }

  return (
    <div className="min-w-0">
      <header className="flex flex-col gap-4 border-b pb-5 sm:flex-row sm:items-end sm:justify-between">
        <div className="min-w-0">
          <p className="text-meta font-bold tracking-label text-brand-clay">OPERATIONS PROTOTYPE</p>
          <h1 className="mt-1 text-page font-semibold tracking-heading sm:text-display">Upstairs Delivery</h1>
          <p className="mt-2 max-w-3xl text-sm leading-6 text-muted-foreground sm:text-base">
            Theo dõi nhanh các đơn minh họa cần đưa bằng thang máy lên tầng 2. Trạng thái và thời điểm chưa phải quy trình vận hành chính thức.
          </p>
        </div>
        <Badge variant="outline" className="min-h-target self-start rounded-lg sm:self-auto">
          <ArrowUpFromLine aria-hidden="true" />
          Chỉ local demo
        </Badge>
      </header>

      <Alert className="mt-5">
        <Info aria-hidden="true" />
        <AlertTitle>Route đánh giá độc lập</AlertTitle>
        <AlertDescription>
          Chưa gắn Upstairs Delivery vào POS hoặc Kitchen navigation. Mọi mã đơn, bàn, thời gian và sản phẩm bên dưới đều là fixture.
        </AlertDescription>
      </Alert>

      <div className="mt-5">
        <DeliveryFilters
          searchQuery={searchQuery}
          statusFilter={statusFilter}
          onReset={resetFilters}
          onSearchQueryChange={setSearchQuery}
          onStatusFilterChange={setStatusFilter}
        />
      </div>

      <p className="mt-3 text-sm text-muted-foreground" aria-live="polite">
        {filteredOrders.length} / {orders.length} đơn demo khớp tìm kiếm
      </p>
      <p className="sr-only" role="status" aria-live="polite">{updateMessage}</p>

      <div className="mt-4 grid min-w-0 gap-5 xl:grid-cols-[minmax(0,1fr)_22rem] xl:items-start">
        <section aria-label="Delivery Queue" className="min-w-0">
          <div className="grid min-w-0 gap-4 lg:grid-cols-3">
            {visibleStatuses.map((status) => (
              <DeliveryQueueGroup
                key={status.id}
                orders={filteredOrders.filter((order) => order.status === status.id)}
                selectedOrderId={selectedOrderId}
                status={status.id}
                onSelect={selectOrder}
              />
            ))}
          </div>
        </section>

        <DeliveryDetail
          isDesktop={isDesktop}
          open={detailOpen}
          order={selectedOrder}
          onClose={closeDetail}
          onConfirmDelivered={() => changeSelectedOrderStatus("delivered")}
          onOpenChange={(open) => {
            setDetailOpen(open)
            if (!open) setSelectedOrderId(undefined)
          }}
          onStatusChange={changeSelectedOrderStatus}
        />
      </div>
    </div>
  )
}

export { UpstairsDeliveryPage }
