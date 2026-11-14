import type { LucideIcon } from "lucide-react"
import {
  Armchair,
  BarChart3,
  BookOpen,
  ChefHat,
  ClipboardList,
  Coffee,
  LayoutDashboard,
  Package,
  ReceiptText,
  Settings,
  Tags,
  Users,
} from "lucide-react"

type NavigationItem = {
  title: string
  path: `/${string}`
  description: string
  icon: LucideIcon
}

type NavigationGroup = {
  label: string
  items: NavigationItem[]
}

const navigationGroups: NavigationGroup[] = [
  {
    label: "Overview",
    items: [
      {
        title: "Dashboard",
        path: "/dashboard",
        description: "Không gian tổng quan cho hoạt động của AFTER FOUR.",
        icon: LayoutDashboard,
      },
    ],
  },
  {
    label: "Operations",
    items: [
      {
        title: "POS",
        path: "/pos",
        description: "Điểm truy cập cho trải nghiệm bán hàng trong phase sau.",
        icon: ReceiptText,
      },
      {
        title: "Orders",
        path: "/orders",
        description: "Không gian theo dõi và quản lý đơn hàng trong tương lai.",
        icon: ClipboardList,
      },
      {
        title: "Tables",
        path: "/tables",
        description: "Không gian quản lý bàn và sơ đồ tầng trong tương lai.",
        icon: Armchair,
      },
      {
        title: "Kitchen",
        path: "/kitchen",
        description: "Không gian vận hành khu vực chuẩn bị món trong tương lai.",
        icon: ChefHat,
      },
    ],
  },
  {
    label: "Catalog",
    items: [
      {
        title: "Menu",
        path: "/menu",
        description: "Không gian quản lý danh mục đồ uống và sản phẩm.",
        icon: Coffee,
      },
      {
        title: "Categories",
        path: "/categories",
        description: "Không gian tổ chức nhóm sản phẩm trong tương lai.",
        icon: Tags,
      },
    ],
  },
  {
    label: "Management",
    items: [
      {
        title: "Inventory",
        path: "/inventory",
        description: "Không gian quản lý tồn kho trong phase nghiệp vụ sau.",
        icon: Package,
      },
      {
        title: "Recipes",
        path: "/recipes",
        description: "Không gian quản lý công thức trong phase nghiệp vụ sau.",
        icon: BookOpen,
      },
      {
        title: "Staff",
        path: "/staff",
        description: "Không gian quản lý nhân sự, chưa bao gồm xác thực.",
        icon: Users,
      },
      {
        title: "Reports",
        path: "/reports",
        description: "Không gian báo cáo sẽ được định nghĩa ở phase sau.",
        icon: BarChart3,
      },
      {
        title: "Settings",
        path: "/settings",
        description: "Không gian cấu hình ứng dụng trong tương lai.",
        icon: Settings,
      },
    ],
  },
]

const navigationItems = navigationGroups.flatMap((group) => group.items)

function findNavigationItem(pathname: string) {
  return navigationItems.find((item) => item.path === pathname)
}

export { findNavigationItem, navigationGroups, navigationItems }
export type { NavigationGroup, NavigationItem }
