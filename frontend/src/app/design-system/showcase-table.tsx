import { sampleOrders } from "@/app/design-system/showcase-data"
import { Badge } from "@/components/ui/badge"
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

function ShowcaseTable() {
  return (
    <Tabs defaultValue="rows">
      <TabsList className="min-h-target" aria-label="Trạng thái dữ liệu bảng">
        <TabsTrigger className="min-h-target px-3" value="rows">
          Có dữ liệu
        </TabsTrigger>
        <TabsTrigger className="min-h-target px-3" value="empty">
          Trống
        </TabsTrigger>
      </TabsList>
      <TabsContent value="rows" className="mt-4">
        <div className="rounded-xl border bg-card">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead className="min-w-36">Mã tham chiếu</TableHead>
                <TableHead>Thời gian</TableHead>
                <TableHead>Nhãn minh họa</TableHead>
                <TableHead className="text-right">Giá trị</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {sampleOrders.map((order) => (
                <TableRow key={order.id}>
                  <TableCell className="numeric-data font-semibold">
                    {order.id}
                  </TableCell>
                  <TableCell className="numeric-data">{order.time}</TableCell>
                  <TableCell>
                    <Badge variant="outline">{order.label}</Badge>
                  </TableCell>
                  <TableCell className="numeric-data text-right font-semibold">
                    {order.amount}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </TabsContent>
      <TabsContent value="empty" className="mt-4">
        <div className="rounded-xl border bg-card">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Mã tham chiếu</TableHead>
                <TableHead>Thời gian</TableHead>
                <TableHead>Nhãn</TableHead>
                <TableHead className="text-right">Giá trị</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              <TableRow>
                <TableCell colSpan={4} className="h-28 text-center">
                  <p className="font-medium">Chưa có dữ liệu mẫu</p>
                  <p className="mt-1 text-sm text-muted-foreground">
                    Empty state nằm trong cấu trúc bảng và không dùng màu làm tín hiệu.
                  </p>
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </div>
      </TabsContent>
    </Tabs>
  )
}

export { ShowcaseTable }
