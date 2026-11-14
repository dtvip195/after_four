import { Coffee, FileSearch, Settings2 } from "lucide-react"

import { OverlayDemos } from "@/app/design-system/overlay-demos"
import { ShowcaseSection, Specimen } from "@/app/design-system/showcase-section"
import { ShowcaseTable } from "@/app/design-system/showcase-table"
import { Button } from "@/components/ui/button"
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
  CommandShortcut,
} from "@/components/ui/command"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"

function PrimitivesSection() {
  return (
    <ShowcaseSection
      id="primitives"
      eyebrow="F · Containers & navigation primitives"
      title="Primitive thật, không sao chép component"
      description="Các component dưới đây là source shadcn/ui có thể chỉnh sửa trực tiếp. Interaction được giữ nhỏ và chỉ phục vụ kiểm tra design system."
    >
      <div className="grid gap-10">
        <div className="grid gap-10 xl:grid-cols-2">
          <Specimen title="Card">
            <Card>
              <CardHeader>
                <CardTitle>Card có boundary rõ</CardTitle>
                <CardDescription>
                  Chỉ dùng Card khi một khối thật sự độc lập về nội dung hoặc hành vi.
                </CardDescription>
                <CardAction>
                  <Button variant="ghost" size="sm" className="min-h-target">
                    Chi tiết
                  </Button>
                </CardAction>
              </CardHeader>
              <CardContent>
                <p className="text-sm leading-6 text-muted-foreground">
                  Phần lớn layout nên dùng alignment, spacing và divider trước khi
                  thêm card hoặc shadow.
                </p>
              </CardContent>
              <CardFooter className="border-t">
                <span className="text-xs text-muted-foreground">
                  Component specimen
                </span>
              </CardFooter>
            </Card>
          </Specimen>

          <Specimen title="Tabs">
            <Tabs defaultValue="overview">
              <TabsList className="min-h-target">
                <TabsTrigger className="min-h-target px-3" value="overview">
                  Tổng quan
                </TabsTrigger>
                <TabsTrigger className="min-h-target px-3" value="details">
                  Chi tiết
                </TabsTrigger>
                <TabsTrigger
                  className="min-h-target px-3"
                  value="disabled"
                  disabled
                >
                  Disabled
                </TabsTrigger>
              </TabsList>
              <TabsContent
                value="overview"
                className="mt-4 rounded-xl border bg-card p-5"
              >
                <p className="font-semibold">Nội dung tổng quan</p>
                <p className="mt-2 text-sm text-muted-foreground">
                  Tabs giữ context và không dùng màu đơn độc để biểu thị selected.
                </p>
              </TabsContent>
              <TabsContent
                value="details"
                className="mt-4 rounded-xl border bg-card p-5"
              >
                <p className="font-semibold">Nội dung chi tiết</p>
                <p className="mt-2 text-sm text-muted-foreground">
                  Keyboard navigation do Radix primitive quản lý.
                </p>
              </TabsContent>
            </Tabs>
          </Specimen>
        </div>

        <Specimen
          title="Table"
          description="Wrapper của Table cho phép horizontal scroll có chủ đích trên màn hình hẹp."
          className="min-w-0"
        >
          <ShowcaseTable />
        </Specimen>

        <div className="grid gap-10 xl:grid-cols-[0.8fr_1.2fr]">
          <Specimen
            title="Command"
            description="Quick find có empty state và keyboard-friendly items."
          >
            <Command className="min-h-72 rounded-xl border bg-card shadow-sm">
              <CommandInput placeholder="Tìm component…" />
              <CommandList>
                <CommandEmpty>Không tìm thấy component.</CommandEmpty>
                <CommandGroup heading="Showcase">
                  <CommandItem className="min-h-target">
                    <Coffee aria-hidden="true" />
                    Brand tokens
                    <CommandShortcut>⌘1</CommandShortcut>
                  </CommandItem>
                  <CommandItem className="min-h-target">
                    <FileSearch aria-hidden="true" />
                    Table specimen
                    <CommandShortcut>⌘2</CommandShortcut>
                  </CommandItem>
                </CommandGroup>
                <CommandSeparator />
                <CommandGroup heading="Khác">
                  <CommandItem className="min-h-target" disabled>
                    <Settings2 aria-hidden="true" />
                    Cấu hình chưa khả dụng
                  </CommandItem>
                </CommandGroup>
              </CommandList>
            </Command>
          </Specimen>

          <Specimen
            title="Dialog, Sheet, Drawer & Dropdown"
            description="Mở từng overlay để kiểm tra focus management, close behavior và responsive sizing."
          >
            <div className="rounded-xl border bg-card p-5">
              <OverlayDemos />
            </div>
          </Specimen>
        </div>
      </div>
    </ShowcaseSection>
  )
}

export { PrimitivesSection }
