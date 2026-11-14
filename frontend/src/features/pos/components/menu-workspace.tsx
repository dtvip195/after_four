import { Search } from "lucide-react"

import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { MenuProductCard } from "@/features/pos/components/menu-product-card"
import { posDemoCategories } from "@/features/pos/data/pos-demo-data"
import type {
  PosDemoCategoryFilter,
  PosDemoProduct,
} from "@/features/pos/types/pos"

type MenuWorkspaceProps = {
  idPrefix: string
  categoryFilter: PosDemoCategoryFilter
  products: PosDemoProduct[]
  searchQuery: string
  selectedProductId: string | undefined
  onCategoryChange: (category: PosDemoCategoryFilter) => void
  onProductSelect: (productId: string) => void
  onSearchQueryChange: (query: string) => void
}

function MenuWorkspace({
  categoryFilter,
  idPrefix,
  products,
  searchQuery,
  selectedProductId,
  onCategoryChange,
  onProductSelect,
  onSearchQueryChange,
}: MenuWorkspaceProps) {
  const titleId = `${idPrefix}-menu-workspace-title`
  const searchId = `${idPrefix}-menu-search`

  return (
    <section
      aria-labelledby={titleId}
      className="flex h-full min-h-0 flex-col bg-card"
    >
      <header className="border-b p-4">
        <div className="flex items-start justify-between gap-3">
          <div>
            <p className="text-meta font-semibold tracking-label text-brand-clay">MENU WORKSPACE</p>
            <h2 id={titleId} className="mt-1 text-section font-semibold">
              Chọn món minh họa
            </h2>
          </div>
          <Badge variant="outline" className="rounded-lg">
            Giá mẫu
          </Badge>
        </div>

        <div className="mt-4">
          <label htmlFor={searchId} className="text-sm font-medium">
            Tìm món minh họa
          </label>
          <div className="relative mt-2">
            <Search
              aria-hidden="true"
              className="pointer-events-none absolute top-1/2 left-3 size-4 -translate-y-1/2 text-muted-foreground"
            />
            <Input
              id={searchId}
              type="search"
              value={searchQuery}
              onChange={(event) => onSearchQueryChange(event.currentTarget.value)}
              placeholder="Ví dụ: Latte"
              className="min-h-target bg-background pl-9"
            />
          </div>
        </div>

        <div className="mt-3 flex flex-wrap gap-2" role="group" aria-label="Lọc danh mục minh họa">
          <Button
            type="button"
            variant={categoryFilter === "all" ? "secondary" : "ghost"}
            aria-pressed={categoryFilter === "all"}
            className="min-h-target px-3"
            onClick={() => onCategoryChange("all")}
          >
            Tất cả
          </Button>
          {posDemoCategories.map((category) => (
            <Button
              key={category.id}
              type="button"
              variant={categoryFilter === category.id ? "secondary" : "ghost"}
              aria-pressed={categoryFilter === category.id}
              className="min-h-target px-3"
              onClick={() => onCategoryChange(category.id)}
            >
              {category.label}
            </Button>
          ))}
        </div>
      </header>

      <div className="min-h-0 flex-1 overflow-y-auto p-4">
        <p className="mb-3 text-xs text-muted-foreground" aria-live="polite">
          {products.length} sản phẩm minh họa
        </p>
        {products.length > 0 ? (
          <div className="grid grid-cols-[repeat(auto-fit,minmax(min(100%,9.5rem),1fr))] gap-3">
            {products.map((product) => (
              <MenuProductCard
                key={product.id}
                product={product}
                isSelected={selectedProductId === product.id}
                onSelect={onProductSelect}
              />
            ))}
          </div>
        ) : (
          <div
            role="status"
            className="flex min-h-40 items-center justify-center rounded-xl border border-dashed p-5 text-center"
          >
            <div>
              <p className="text-sm font-semibold">Không có sản phẩm minh họa phù hợp</p>
              <p className="mt-1 text-xs text-muted-foreground">
                Thử từ khóa khác hoặc chọn lại danh mục.
              </p>
            </div>
          </div>
        )}
      </div>
    </section>
  )
}

export { MenuWorkspace }
