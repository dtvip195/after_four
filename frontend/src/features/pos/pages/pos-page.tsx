import { useMemo, useState } from "react"
import { useOutletContext } from "react-router"

import type { AppShellOutletContext } from "@/app/layout/app-shell"
import { Badge } from "@/components/ui/badge"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { FloorWorkspace } from "@/features/pos/components/floor-workspace"
import { MenuWorkspace } from "@/features/pos/components/menu-workspace"
import { OrderPanel } from "@/features/pos/components/order-panel"
import { PaymentDialog } from "@/features/pos/components/payment-dialog"
import { ProductDetailDialog } from "@/features/pos/components/product-detail-dialog"
import { posDemoProducts } from "@/features/pos/data/pos-demo-data"
import { useDemoOrder } from "@/features/pos/hooks/use-demo-order"
import type { PosDemoCategoryFilter } from "@/features/pos/types/pos"

function PosPage() {
  const { selectedFloor, selectedFloorLabel } = useOutletContext<AppShellOutletContext>()
  const [searchQuery, setSearchQuery] = useState("")
  const [categoryFilter, setCategoryFilter] = useState<PosDemoCategoryFilter>("all")
  const [selectedProductId, setSelectedProductId] = useState<string>()
  const [paymentOpen, setPaymentOpen] = useState(false)
  const [paymentSessionId, setPaymentSessionId] = useState(0)
  const {
    orderLines,
    addProduct,
    clearOrder,
    decreaseQuantity,
    increaseQuantity,
    removeProduct,
    updateNote,
  } = useDemoOrder()

  const filteredProducts = useMemo(() => {
    const normalizedQuery = searchQuery.trim().toLocaleLowerCase("vi")

    return posDemoProducts.filter((product) => {
      const matchesCategory =
        categoryFilter === "all" || product.categoryId === categoryFilter
      const matchesSearch =
        normalizedQuery.length === 0 ||
        product.name.toLocaleLowerCase("vi").includes(normalizedQuery)

      return matchesCategory && matchesSearch
    })
  }, [categoryFilter, searchQuery])

  const selectedProduct = posDemoProducts.find((product) => product.id === selectedProductId)
  const openPayment = () => {
    setPaymentSessionId((sessionId) => sessionId + 1)
    setPaymentOpen(true)
  }

  return (
    <div className="min-w-0">
      <header className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
        <div className="min-w-0">
          <p className="text-meta font-bold tracking-label text-brand-clay">POS WORKSPACE</p>
          <h1 className="mt-1 text-page font-semibold tracking-heading sm:text-display">POS</h1>
          <p className="mt-1 max-w-2xl text-sm leading-6 text-muted-foreground">
            Bản xem trước bố cục bán hàng; mọi bàn, sản phẩm, giá và dòng đơn đều là dữ liệu minh họa.
          </p>
        </div>
        <Badge variant="outline" className="rounded-lg self-start sm:self-auto">
          Không có nghiệp vụ thật
        </Badge>
      </header>

      <Tabs defaultValue="menu" className="mt-5 min-w-0 gap-3 md:hidden">
        <TabsList className="min-h-touch w-full md:hidden" aria-label="Khu vực POS">
          <TabsTrigger value="tables" className="min-h-target">
            Bàn
          </TabsTrigger>
          <TabsTrigger value="menu" className="min-h-target">
            Menu
          </TabsTrigger>
          <TabsTrigger value="order" className="min-h-target">
            Đơn
          </TabsTrigger>
        </TabsList>

        <div className="min-w-0 overflow-hidden rounded-xl border bg-card">
          <TabsContent
            value="tables"
            className="m-0 min-h-[30rem] min-w-0"
          >
            <FloorWorkspace
              key={selectedFloor}
              idPrefix="mobile-pos"
              selectedFloor={selectedFloor}
              selectedFloorLabel={selectedFloorLabel}
            />
          </TabsContent>
          <TabsContent
            value="menu"
            className="m-0 min-h-[40rem] min-w-0"
          >
            <MenuWorkspace
              categoryFilter={categoryFilter}
              idPrefix="mobile-pos"
              products={filteredProducts}
              searchQuery={searchQuery}
              selectedProductId={selectedProductId}
              onCategoryChange={setCategoryFilter}
              onProductSelect={setSelectedProductId}
              onSearchQueryChange={setSearchQuery}
            />
          </TabsContent>
          <TabsContent
            value="order"
            className="m-0 min-h-[34rem] min-w-0"
          >
            <OrderPanel
              idPrefix="mobile-pos"
              orderLines={orderLines}
              onClear={clearOrder}
              onDecrease={decreaseQuantity}
              onIncrease={increaseQuantity}
              onNoteChange={updateNote}
              onRemove={removeProduct}
              onCheckout={openPayment}
            />
          </TabsContent>
        </div>
      </Tabs>

      <div className="mt-5 hidden min-w-0 overflow-hidden rounded-xl border bg-card md:grid md:grid-cols-[minmax(0,1fr)_18rem] xl:h-[calc(100svh-14rem)] xl:min-h-[38rem] xl:max-h-[52rem] xl:grid-cols-[19rem_minmax(0,1fr)_20rem]">
        <div className="min-h-60 min-w-0 border-b md:col-span-2 xl:col-span-1 xl:min-h-0 xl:border-r xl:border-b-0">
          <FloorWorkspace
            key={selectedFloor}
            idPrefix="desktop-pos"
            selectedFloor={selectedFloor}
            selectedFloorLabel={selectedFloorLabel}
          />
        </div>
        <div className="min-h-[36rem] min-w-0 xl:min-h-0">
          <MenuWorkspace
            categoryFilter={categoryFilter}
            idPrefix="desktop-pos"
            products={filteredProducts}
            searchQuery={searchQuery}
            selectedProductId={selectedProductId}
            onCategoryChange={setCategoryFilter}
            onProductSelect={setSelectedProductId}
            onSearchQueryChange={setSearchQuery}
          />
        </div>
        <div className="min-h-[36rem] min-w-0 border-l xl:min-h-0">
          <OrderPanel
            idPrefix="desktop-pos"
            orderLines={orderLines}
            onClear={clearOrder}
            onDecrease={decreaseQuantity}
            onIncrease={increaseQuantity}
            onNoteChange={updateNote}
            onRemove={removeProduct}
            onCheckout={openPayment}
          />
        </div>
      </div>

      <ProductDetailDialog
        product={selectedProduct}
        onAddToOrder={(productId) => {
          addProduct(productId)
          setSelectedProductId(undefined)
        }}
        onOpenChange={(open) => {
          if (!open) {
            setSelectedProductId(undefined)
          }
        }}
      />
      <PaymentDialog
        key={paymentSessionId}
        open={paymentOpen}
        orderLines={orderLines}
        onOpenChange={setPaymentOpen}
      />
    </div>
  )
}

export { PosPage }
