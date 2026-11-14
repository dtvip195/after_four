import { Search, SlidersHorizontal } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { deliveryDemoStatuses } from "@/features/upstairs-delivery/data/delivery-demo-data"
import type { DeliveryDemoStatusFilter } from "@/features/upstairs-delivery/types/upstairs-delivery"

type DeliveryFiltersProps = {
  searchQuery: string
  statusFilter: DeliveryDemoStatusFilter
  onReset: () => void
  onSearchQueryChange: (query: string) => void
  onStatusFilterChange: (status: DeliveryDemoStatusFilter) => void
}

function DeliveryFilters({
  searchQuery,
  statusFilter,
  onReset,
  onSearchQueryChange,
  onStatusFilterChange,
}: DeliveryFiltersProps) {
  return (
    <div className="grid gap-3 rounded-xl border bg-card p-3 sm:grid-cols-[minmax(0,1fr)_13rem_auto] sm:items-end">
      <div className="min-w-0">
        <Label htmlFor="delivery-search">Tìm đơn hoặc bàn demo</Label>
        <div className="relative mt-2">
          <Search aria-hidden="true" className="absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted-foreground" />
          <Input
            id="delivery-search"
            type="search"
            className="min-h-target pl-9"
            placeholder="AF-D201 hoặc T2-03"
            value={searchQuery}
            onChange={(event) => onSearchQueryChange(event.target.value)}
          />
        </div>
      </div>

      <div>
        <Label htmlFor="delivery-status-filter">Lọc trạng thái demo</Label>
        <Select value={statusFilter} onValueChange={(value) => onStatusFilterChange(value as DeliveryDemoStatusFilter)}>
          <SelectTrigger id="delivery-status-filter" className="mt-2 min-h-target w-full" aria-label="Lọc trạng thái delivery demo">
            <SlidersHorizontal aria-hidden="true" />
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value="all">Tất cả trạng thái</SelectItem>
            {deliveryDemoStatuses.map((status) => (
              <SelectItem key={status.id} value={status.id}>{status.label}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>

      <Button type="button" variant="outline" className="min-h-target" onClick={onReset}>
        Đặt lại
      </Button>
    </div>
  )
}

export { DeliveryFilters }
