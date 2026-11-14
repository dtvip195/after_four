import { CheckCircle2, CircleAlert, CircleX, Info } from "lucide-react"

import { ColorSwatchGrid } from "@/app/design-system/color-swatch-grid"
import {
  brandColors,
  semanticColors,
  statusColors,
} from "@/app/design-system/showcase-data"
import {
  ShowcaseSection,
  Specimen,
} from "@/app/design-system/showcase-section"

const spacingSteps = [1, 2, 3, 4, 5, 6, 8, 10, 12, 16] as const

const statusExamples = [
  {
    label: "Thành công",
    className: "bg-success text-success-foreground",
    icon: CheckCircle2,
  },
  {
    label: "Cần chú ý",
    className: "bg-warning text-warning-foreground",
    icon: CircleAlert,
  },
  {
    label: "Có lỗi",
    className: "bg-error text-error-foreground",
    icon: CircleX,
  },
  {
    label: "Thông tin",
    className: "bg-information text-information-foreground",
    icon: Info,
  },
] as const

function BrandTokensSection() {
  return (
    <ShowcaseSection
      id="tokens"
      eyebrow="A · Brand & design tokens"
      title="Một nền tảng ấm, rõ và có kỷ luật"
      description="Mọi swatch dưới đây đọc trực tiếp CSS custom property tại runtime. HEX là giá trị triển khai ban đầu để owner đánh giá, chưa phải màu thương hiệu chính thức."
    >
      <div className="grid gap-10">
        <Specimen
          title="Brand palette"
          description="Màu nhận diện; Clay chỉ dùng cho điểm nhấn có chủ đích."
        >
          <ColorSwatchGrid tokens={brandColors} />
        </Specimen>

        <Specimen
          title="Semantic palette"
          description="Component nên dùng semantic token thay vì raw brand color."
        >
          <ColorSwatchGrid tokens={semanticColors} />
        </Specimen>

        <Specimen
          title="Status palette"
          description="Ví dụ trung tính để kiểm tra contrast; không phải mapping trạng thái bàn hoặc đơn hàng."
        >
          <div className="grid gap-5">
            <ColorSwatchGrid tokens={statusColors} />
            <div className="flex flex-wrap gap-3">
              {statusExamples.map(({ label, className, icon: Icon }) => (
                <span
                  key={label}
                  className={`inline-flex min-h-10 items-center gap-2 rounded-lg px-3 text-sm font-semibold ${className}`}
                >
                  <Icon aria-hidden="true" className="size-4" />
                  {label}
                </span>
              ))}
            </div>
          </div>
        </Specimen>

        <div className="grid gap-10 xl:grid-cols-2">
          <Specimen
            title="Spacing scale"
            description="Base 4px; control 40px, preferred target 44px và touch target 48px."
          >
            <div className="grid gap-3">
              {spacingSteps.map((step) => (
                <div key={step} className="grid grid-cols-[3rem_1fr_4rem] items-center gap-3">
                  <span className="numeric-data text-xs text-muted-foreground">
                    {step}
                  </span>
                  <div
                    className="h-3 max-w-full rounded-sm bg-brand-clay"
                    style={{ width: `calc(var(--spacing) * ${step})` }}
                  />
                  <span className="numeric-data text-right text-xs text-muted-foreground">
                    {step * 4}px
                  </span>
                </div>
              ))}
            </div>
          </Specimen>

          <Specimen
            title="Radius, border & shadow"
            description="Border và khoảng trắng tạo hierarchy; shadow chỉ dành cho elevation."
          >
            <div className="grid grid-cols-2 gap-4 sm:grid-cols-4">
              {[
                ["4px", "rounded-sm"],
                ["6px", "rounded-md"],
                ["8px", "rounded-lg"],
                ["12px", "rounded-xl"],
              ].map(([label, radius]) => (
                <div key={label}>
                  <div className={`h-16 border-2 border-input bg-card ${radius}`} />
                  <p className="numeric-data mt-2 text-center text-xs text-muted-foreground">
                    {label}
                  </p>
                </div>
              ))}
            </div>
            <div className="mt-6 grid gap-4 sm:grid-cols-3">
              <div className="rounded-lg border bg-card p-4">
                <p className="text-sm font-medium">Border</p>
                <p className="mt-1 text-xs text-muted-foreground">1px divider</p>
              </div>
              <div className="rounded-lg border bg-card p-4 shadow-sm">
                <p className="text-sm font-medium">Subtle</p>
                <p className="mt-1 text-xs text-muted-foreground">shadow-sm</p>
              </div>
              <div className="rounded-lg bg-card p-4 shadow-md ring-1 ring-foreground/10">
                <p className="text-sm font-medium">Elevated</p>
                <p className="mt-1 text-xs text-muted-foreground">shadow-md</p>
              </div>
            </div>
          </Specimen>
        </div>

        <Specimen
          title="Focus ring"
          description="Dùng phím Tab để kiểm tra focus thật. Preview bên cạnh giữ ring hiển thị để so sánh."
        >
          <div className="flex flex-wrap items-center gap-4">
            <button
              type="button"
              className="min-h-target rounded-lg border border-input bg-card px-4 text-sm font-medium outline-none focus-visible:border-ring focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background"
            >
              Tab để focus
            </button>
            <div className="min-h-target rounded-lg border border-ring bg-card px-4 py-3 text-sm font-medium ring-2 ring-ring ring-offset-2 ring-offset-background">
              Focus preview
            </div>
          </div>
        </Specimen>
      </div>
    </ShowcaseSection>
  )
}

export { BrandTokensSection }
