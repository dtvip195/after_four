import { Coffee, LoaderCircle, Plus, Trash2 } from "lucide-react"

import { ShowcaseSection, Specimen } from "@/app/design-system/showcase-section"
import { Button } from "@/components/ui/button"

function ButtonsSection() {
  return (
    <ShowcaseSection
      id="buttons"
      eyebrow="C · Buttons"
      title="Hành động rõ, emphasis có giới hạn"
      description="Mỗi vùng chỉ nên có một primary action nổi bật. Các trạng thái hover và focus có thể kiểm tra trực tiếp bằng pointer hoặc bàn phím."
    >
      <div className="grid gap-10">
        <Specimen title="Variants">
          <div className="flex flex-wrap items-center gap-3">
            <Button className="min-h-target px-4">Primary</Button>
            <Button variant="secondary" className="min-h-target px-4">
              Secondary
            </Button>
            <Button variant="outline" className="min-h-target px-4">
              Outline
            </Button>
            <Button variant="ghost" className="min-h-target px-4">
              Ghost
            </Button>
            <Button variant="destructive" className="min-h-target px-4">
              <Trash2 aria-hidden="true" />
              Destructive
            </Button>
          </div>
        </Specimen>

        <div className="grid gap-10 xl:grid-cols-2">
          <Specimen
            title="Sizes"
            description="xs/sm dành cho desktop density; touch contexts dùng target 44–48px."
          >
            <div className="flex flex-wrap items-end gap-3">
              <Button size="xs">Extra small</Button>
              <Button size="sm">Small</Button>
              <Button size="default">Default</Button>
              <Button size="lg" className="min-h-touch px-5">
                Touch
              </Button>
            </div>
          </Specimen>

          <Specimen title="Icon actions">
            <div className="flex flex-wrap items-center gap-3">
              <Button size="icon" className="size-target" aria-label="Thêm mục">
                <Plus aria-hidden="true" />
              </Button>
              <Button
                size="icon"
                variant="secondary"
                className="size-target"
                aria-label="Mở công cụ cafe"
              >
                <Coffee aria-hidden="true" />
              </Button>
              <Button variant="outline" className="min-h-target px-4">
                <Coffee aria-hidden="true" />
                Có icon
              </Button>
            </div>
          </Specimen>
        </div>

        <Specimen title="Disabled & loading">
          <div className="flex flex-wrap items-center gap-3">
            <Button disabled className="min-h-target px-4">
              Disabled
            </Button>
            <Button
              disabled
              aria-busy="true"
              className="min-h-target px-4"
            >
              <LoaderCircle aria-hidden="true" className="animate-spin" />
              Đang xử lý
            </Button>
            <p className="w-full text-sm text-muted-foreground">
              Loading giữ nguyên kích thước control và khóa thao tác lặp.
            </p>
          </div>
        </Specimen>
      </div>
    </ShowcaseSection>
  )
}

export { ButtonsSection }
