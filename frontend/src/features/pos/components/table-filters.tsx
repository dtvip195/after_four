import { RotateCcw, Search } from "lucide-react"

import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { posDemoTableStatuses } from "@/features/pos/data/pos-demo-data"
import type { PosDemoTableStatusFilter } from "@/features/pos/types/pos"

type TableFiltersProps = {
  idPrefix: string
  searchQuery: string
  statusFilter: PosDemoTableStatusFilter
  onReset: () => void
  onSearchQueryChange: (value: string) => void
  onStatusFilterChange: (value: PosDemoTableStatusFilter) => void
}

function isTableStatusFilter(value: string): value is PosDemoTableStatusFilter {
  return value === "all" || posDemoTableStatuses.some((status) => status.id === value)
}

function TableFilters({
  idPrefix,
  searchQuery,
  statusFilter,
  onReset,
  onSearchQueryChange,
  onStatusFilterChange,
}: TableFiltersProps) {
  const searchId = `${idPrefix}-table-search`
  const hasFilters = searchQuery.length > 0 || statusFilter !== "all"

  return (
    <div className="grid min-w-0 gap-2 sm:grid-cols-[minmax(0,1fr)_11rem_auto] md:grid-cols-1 xl:grid-cols-1">
      <div className="min-w-0">
        <label htmlFor={searchId} className="sr-only">
          Tìm bàn minh họa
        </label>
        <div className="relative">
          <Search
            aria-hidden="true"
            className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted-foreground"
          />
          <Input
            id={searchId}
            type="search"
            value={searchQuery}
            className="min-h-target pl-9"
            placeholder="Tìm mã hoặc tên bàn"
            onChange={(event) => onSearchQueryChange(event.target.value)}
          />
        </div>
      </div>

      <Select
        value={statusFilter}
        onValueChange={(value) => {
          if (isTableStatusFilter(value)) {
            onStatusFilterChange(value)
          }
        }}
      >
        <SelectTrigger aria-label="Lọc trạng thái bàn minh họa" className="min-h-target w-full">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="all" className="min-h-target">
            Tất cả trạng thái
          </SelectItem>
          {posDemoTableStatuses.map((status) => (
            <SelectItem key={status.id} value={status.id} className="min-h-target">
              {status.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>

      <Button
        type="button"
        variant="ghost"
        className="min-h-target px-3"
        disabled={!hasFilters}
        onClick={onReset}
      >
        <RotateCcw aria-hidden="true" />
        Đặt lại
      </Button>
    </div>
  )
}

export { TableFilters }
