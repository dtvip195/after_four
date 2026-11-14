import type { FloorId } from "@/app/components/floor-options"
import type {
  PosDemoCategory,
  PosDemoProduct,
  PosDemoTable,
  PosDemoTableStatus,
} from "@/features/pos/types/pos"

const posDemoCategories: PosDemoCategory[] = [
  { id: "coffee", label: "Coffee" },
  { id: "tea", label: "Tea" },
  { id: "non-coffee", label: "Non-coffee" },
  { id: "other", label: "Other" },
]

const posDemoProducts: PosDemoProduct[] = [
  {
    id: "demo-espresso",
    name: "Espresso",
    categoryId: "coffee",
    unitPriceVnd: 45000,
    description: "Mô tả minh họa cho một ly espresso cô đọng, dùng để đánh giá bố cục chi tiết.",
  },
  {
    id: "demo-americano",
    name: "Americano",
    categoryId: "coffee",
    unitPriceVnd: 50000,
    description: "Mô tả minh họa cho cà phê pha cùng nước nóng; chưa phải nội dung menu chính thức.",
  },
  {
    id: "demo-cappuccino",
    name: "Cappuccino",
    categoryId: "coffee",
    unitPriceVnd: 55000,
    description: "Mô tả minh họa cho sản phẩm cà phê sữa, không đại diện công thức hoặc định lượng.",
  },
  {
    id: "demo-latte",
    name: "Latte",
    categoryId: "coffee",
    unitPriceVnd: 58000,
    description: "Mô tả minh họa cho latte, chỉ phục vụ kiểm tra hierarchy và trải nghiệm chọn món.",
  },
  {
    id: "demo-milk-tea",
    name: "Milk Tea",
    categoryId: "tea",
    unitPriceVnd: 52000,
    description: "Mô tả minh họa cho trà sữa; thành phần và cách pha chưa được xác nhận.",
  },
  {
    id: "demo-peach-tea",
    name: "Peach Tea",
    categoryId: "tea",
    unitPriceVnd: 48000,
    description: "Mô tả minh họa cho trà đào, không đại diện nguyên liệu hoặc công thức thật.",
  },
  {
    id: "demo-cacao",
    name: "Cacao",
    categoryId: "non-coffee",
    unitPriceVnd: 54000,
    description: "Mô tả minh họa cho đồ uống cacao thuộc nhóm không cà phê.",
  },
  {
    id: "demo-sparkling",
    name: "Sparkling Water",
    categoryId: "other",
    unitPriceVnd: 35000,
    description: "Mô tả minh họa cho một sản phẩm thuộc nhóm khác; giá chưa được phê duyệt.",
  },
]

function getPosDemoCategoryLabel(categoryId: PosDemoProduct["categoryId"]) {
  return posDemoCategories.find((category) => category.id === categoryId)?.label ?? categoryId
}

const posDemoTableStatuses: Array<{
  id: PosDemoTableStatus
  label: string
}> = [
  { id: "ready", label: "Sẵn sàng" },
  { id: "serving", label: "Đang phục vụ" },
  { id: "attention", label: "Cần chú ý" },
]

const posDemoTablesByFloor: Record<FloorId, PosDemoTable[]> = {
  "floor-1": [
    { id: "demo-floor-1-table-01", code: "T1-01", label: "Bàn mẫu 01", status: "ready" },
    { id: "demo-floor-1-table-02", code: "T1-02", label: "Bàn mẫu 02", status: "serving" },
    { id: "demo-floor-1-table-03", code: "T1-03", label: "Bàn mẫu 03", status: "attention" },
    { id: "demo-floor-1-table-04", code: "T1-04", label: "Bàn mẫu 04", status: "ready" },
    { id: "demo-floor-1-table-05", code: "T1-05", label: "Bàn mẫu 05", status: "serving" },
    { id: "demo-floor-1-table-06", code: "T1-06", label: "Bàn mẫu 06", status: "ready" },
  ],
  "floor-2": [
    { id: "demo-floor-2-table-01", code: "T2-01", label: "Bàn mẫu 01", status: "serving" },
    { id: "demo-floor-2-table-02", code: "T2-02", label: "Bàn mẫu 02", status: "ready" },
    { id: "demo-floor-2-table-03", code: "T2-03", label: "Bàn mẫu 03", status: "ready" },
    { id: "demo-floor-2-table-04", code: "T2-04", label: "Bàn mẫu 04", status: "attention" },
    { id: "demo-floor-2-table-05", code: "T2-05", label: "Bàn mẫu 05", status: "serving" },
  ],
}

export {
  posDemoCategories,
  posDemoProducts,
  posDemoTablesByFloor,
  posDemoTableStatuses,
  getPosDemoCategoryLabel,
}
