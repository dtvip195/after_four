import { useMemo, useState } from "react"
import { Layers3, SearchX } from "lucide-react"

import type { FloorId } from "@/app/components/floor-options"
import { Badge } from "@/components/ui/badge"
import { TableCard } from "@/features/pos/components/table-card"
import { TableFilters } from "@/features/pos/components/table-filters"
import { TablePreview } from "@/features/pos/components/table-preview"
import { posDemoTablesByFloor } from "@/features/pos/data/pos-demo-data"
import type { PosDemoTableStatusFilter } from "@/features/pos/types/pos"

type FloorWorkspaceProps = {
  idPrefix: string
  selectedFloor: FloorId
  selectedFloorLabel: string
}

function FloorWorkspace({
  idPrefix,
  selectedFloor,
  selectedFloorLabel,
}: FloorWorkspaceProps) {
  const titleId = `${idPrefix}-floor-workspace-title`
  const [searchQuery, setSearchQuery] = useState("")
  const [statusFilter, setStatusFilter] = useState<PosDemoTableStatusFilter>("all")
  const [selectedTableId, setSelectedTableId] = useState<string>()
  const floorTables = posDemoTablesByFloor[selectedFloor]

  const filteredTables = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLocaleLowerCase("vi")

    return floorTables.filter((table) => {
      const matchesQuery =
        normalizedQuery.length === 0 ||
        table.code.toLocaleLowerCase("vi").includes(normalizedQuery) ||
        table.label.toLocaleLowerCase("vi").includes(normalizedQuery)
      const matchesStatus = statusFilter === "all" || table.status === statusFilter

      return matchesQuery && matchesStatus
    })
  }, [floorTables, searchQuery, statusFilter])

  const selectedTable = floorTables.find((table) => table.id === selectedTableId)

  function resetFilters() {
    setSearchQuery("")
    setStatusFilter("all")
  }

  function toggleTable(tableId: string) {
    setSelectedTableId((currentTableId) =>
      currentTableId === tableId ? undefined : tableId
    )
  }

  return (
    <section aria-labelledby={titleId} className="flex h-full min-h-0 flex-col bg-card">
      <header className="border-b p-4">
        <div className="flex items-start justify-between gap-3">
          <div className="min-w-0">
            <p className="text-meta font-semibold tracking-label text-brand-clay">TABLE WORKSPACE</p>
            <h2 id={titleId} className="mt-1 text-section font-semibold">
              Không gian bàn
            </h2>
          </div>
          <Badge variant="outline" className="rounded-lg">
            Trạng thái đề xuất
          </Badge>
        </div>
        <div className="mt-3 flex flex-wrap items-center gap-x-3 gap-y-1 text-sm">
          <span className="flex items-center gap-2 font-medium">
            <Layers3 aria-hidden="true" className="size-4 text-brand-clay" />
            {selectedFloorLabel}
          </span>
          <span className="text-muted-foreground" aria-label={`${floorTables.length} bàn minh họa`}>
            {floorTables.length} bàn minh họa
          </span>
        </div>
        <p className="mt-2 text-xs leading-5 text-muted-foreground">
          Số lượng, vị trí và trạng thái chỉ dùng để đánh giá giao diện.
        </p>
      </header>

      <div className="min-h-0 flex-1 overflow-y-auto p-4">
        <TableFilters
          idPrefix={idPrefix}
          searchQuery={searchQuery}
          statusFilter={statusFilter}
          onReset={resetFilters}
          onSearchQueryChange={setSearchQuery}
          onStatusFilterChange={setStatusFilter}
        />

        <p className="mt-3 text-xs text-muted-foreground" aria-live="polite">
          {filteredTables.length} / {floorTables.length} bàn đang hiển thị
        </p>

        <div className="mt-3 grid min-w-0 gap-4 md:grid-cols-[minmax(0,1fr)_15rem] xl:grid-cols-1">
          <div className="min-w-0">
            {filteredTables.length > 0 ? (
              <div className="grid min-w-0 grid-cols-2 gap-3 sm:grid-cols-3 md:grid-cols-2">
                {filteredTables.map((table) => (
                  <TableCard
                    key={table.id}
                    table={table}
                    isSelected={selectedTableId === table.id}
                    onSelect={toggleTable}
                  />
                ))}
              </div>
            ) : (
              <div
                role="status"
                className="flex min-h-44 flex-col items-center justify-center rounded-xl border border-dashed bg-muted/30 p-4 text-center"
              >
                <SearchX aria-hidden="true" className="size-6 text-muted-foreground" />
                <h3 className="mt-3 text-sm font-semibold">Không tìm thấy bàn minh họa</h3>
                <p className="mt-1 text-xs leading-5 text-muted-foreground">
                  Thử từ khóa khác hoặc đặt lại bộ lọc.
                </p>
              </div>
            )}
          </div>

          <div className="min-w-0 xl:order-first">
            <TablePreview
              floorLabel={selectedFloorLabel}
              table={selectedTable}
              onClear={() => setSelectedTableId(undefined)}
            />
          </div>
        </div>
      </div>
    </section>
  )
}

export { FloorWorkspace }
