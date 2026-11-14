import { Coffee, Minus, Plus, ReceiptText } from "lucide-react"

import { sampleProducts } from "@/app/design-system/showcase-data"
import { ShowcaseSection } from "@/app/design-system/showcase-section"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"

const tablePreviews = [
  ["Bàn mẫu 01", "2 khách"],
  ["Bàn mẫu 02", "4 khách"],
  ["Bàn mẫu 03", "Trống"],
  ["Bàn mẫu 04", "2 khách"],
] as const

function PosPreviewSection() {
  return (
    <ShowcaseSection
      id="preview"
      eyebrow="G · POS UI preview"
      title="Một lát cắt nhỏ, không phải POS Application Shell"
      description="Khu vực này chỉ ghép component với static data để owner đánh giá density, hierarchy và touch sizing. Không có workflow gọi món, thanh toán hoặc mapping trạng thái nghiệp vụ."
    >
      <div className="overflow-hidden rounded-xl border bg-card shadow-sm">
        <div className="flex flex-col gap-3 border-b p-4 sm:flex-row sm:items-center sm:justify-between">
          <div>
            <div className="flex items-center gap-2">
              <Coffee aria-hidden="true" className="size-5 text-primary" />
              <h3 className="font-semibold">POS composition preview</h3>
            </div>
            <p className="mt-1 text-sm text-muted-foreground">
              Static specimen · vocabulary chưa được phê duyệt
            </p>
          </div>
          <Badge variant="outline">Không phải màn hình vận hành</Badge>
        </div>

        <div className="grid xl:grid-cols-[0.75fr_1.15fr_1fr]">
          <div className="border-b p-4 xl:border-r xl:border-b-0">
            <p className="mb-3 text-sm font-semibold">Thẻ bàn minh họa</p>
            <div className="grid grid-cols-2 gap-3">
              {tablePreviews.map(([name, detail], index) => (
                <button
                  key={name}
                  type="button"
                  className={
                    index === 0
                      ? "min-h-24 rounded-lg border-2 border-brand-clay bg-accent p-3 text-left outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                      : "min-h-24 rounded-lg border border-input bg-background p-3 text-left outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
                  }
                >
                  <span className="block text-sm font-semibold">{name}</span>
                  <span className="mt-1 block text-xs text-muted-foreground">
                    {detail}
                  </span>
                  <span className="mt-3 block text-xs font-medium">
                    {index === 0 ? "Đang chọn · UI state" : "Static preview"}
                  </span>
                </button>
              ))}
            </div>
          </div>

          <div className="border-b p-4 xl:border-r xl:border-b-0">
            <p className="mb-3 text-sm font-semibold">Sản phẩm minh họa</p>
            <div className="grid gap-3 sm:grid-cols-3 xl:grid-cols-1 2xl:grid-cols-2">
              {sampleProducts.map((product) => (
                <Card key={product.name} size="sm" className="shadow-none">
                  <CardHeader>
                    <CardTitle className="text-sm">{product.name}</CardTitle>
                  </CardHeader>
                  <CardContent>
                    <p className="text-xs text-muted-foreground">{product.note}</p>
                    <p className="numeric-data mt-3 text-sm font-semibold">
                      {product.price}
                    </p>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>

          <div className="flex min-w-0 flex-col p-4">
            <div className="mb-3 flex items-center gap-2">
              <ReceiptText aria-hidden="true" className="size-4 text-primary" />
              <p className="text-sm font-semibold">Đơn mẫu</p>
            </div>
            <div className="rounded-lg border">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Mục</TableHead>
                    <TableHead className="w-20 text-center">SL</TableHead>
                    <TableHead className="text-right">Giá</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  <TableRow>
                    <TableCell>Cà phê sữa</TableCell>
                    <TableCell>
                      <div className="flex items-center justify-center gap-1">
                        <Button
                          size="icon-xs"
                          variant="ghost"
                          className="size-target"
                          aria-label="Giảm số lượng minh họa"
                        >
                          <Minus aria-hidden="true" />
                        </Button>
                        <span className="numeric-data min-w-5 text-center">1</span>
                        <Button
                          size="icon-xs"
                          variant="ghost"
                          className="size-target"
                          aria-label="Tăng số lượng minh họa"
                        >
                          <Plus aria-hidden="true" />
                        </Button>
                      </div>
                    </TableCell>
                    <TableCell className="numeric-data text-right">
                      45.000 ₫
                    </TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell>Matcha latte</TableCell>
                    <TableCell className="numeric-data text-center">1</TableCell>
                    <TableCell className="numeric-data text-right">
                      62.000 ₫
                    </TableCell>
                  </TableRow>
                </TableBody>
              </Table>
            </div>
            <div className="mt-auto pt-5">
              <div className="flex items-end justify-between gap-4 border-t pt-4">
                <div>
                  <p className="text-xs text-muted-foreground">Tổng minh họa</p>
                  <p className="numeric-data mt-1 text-xl font-bold">
                    107.000 ₫
                  </p>
                </div>
                <Button disabled className="min-h-touch px-5">
                  Chỉ preview
                </Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </ShowcaseSection>
  )
}

export { PosPreviewSection }
