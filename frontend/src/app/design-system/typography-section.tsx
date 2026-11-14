import { ShowcaseSection, Specimen } from "@/app/design-system/showcase-section"

const weights = [
  ["Regular", "font-normal", "400"],
  ["Medium", "font-medium", "500"],
  ["Semibold", "font-semibold", "600"],
  ["Bold", "font-bold", "700"],
] as const

function TypographySection() {
  return (
    <ShowcaseSection
      id="typography"
      eyebrow="B · Typography"
      title="Tiếng Việt rõ ràng, số liệu quét nhanh"
      description="Be Vietnam Pro đảm nhiệm toàn bộ UI. Geist Mono chỉ xuất hiện ở tiền, thời gian, mã và dữ liệu dạng cột."
    >
      <div className="grid gap-10">
        <Specimen title="Be Vietnam Pro weights">
          <div className="grid gap-px overflow-hidden rounded-xl border bg-border md:grid-cols-2">
            {weights.map(([name, weightClass, value]) => (
              <div key={name} className="bg-card p-5">
                <div className="flex items-baseline justify-between gap-4">
                  <p className={`${weightClass} text-section`}>{name}</p>
                  <span className="numeric-data text-xs text-muted-foreground">
                    {value}
                  </span>
                </div>
                <p className={`mt-3 ${weightClass}`}>
                  Cà phê phin, sữa đặc và một buổi chiều yên tĩnh.
                </p>
              </div>
            ))}
          </div>
        </Specimen>

        <div className="grid gap-10 xl:grid-cols-[1.25fr_0.75fr]">
          <Specimen
            title="Type hierarchy"
            description="Scale semantic dùng cho vùng vận hành và quản trị."
          >
            <div className="space-y-6 rounded-xl border bg-card p-5 sm:p-6">
              <div>
                <p className="text-meta font-semibold tracking-label text-brand-clay">
                  DISPLAY · 32/40
                </p>
                <p className="mt-2 text-display font-bold tracking-heading">
                  AFTER FOUR
                </p>
              </div>
              <div>
                <p className="text-meta text-muted-foreground">PAGE · 24/32</p>
                <p className="mt-1 text-page font-semibold tracking-heading">
                  Quản lý vận hành quán cafe
                </p>
              </div>
              <div>
                <p className="text-meta text-muted-foreground">SECTION · 18/26</p>
                <p className="mt-1 text-section font-semibold">
                  Tổng doanh thu hôm nay
                </p>
              </div>
              <div>
                <p className="text-meta text-muted-foreground">BODY · 16/24</p>
                <p className="mt-1 text-body">
                  AFTER FOUR – Specialty Coffee. Giao diện cần đủ ấm để dễ chịu
                  trong ca làm dài, đồng thời đủ rõ để nhân viên đọc nhanh khi
                  quán đông khách.
                </p>
              </div>
              <div>
                <p className="text-label font-medium">Label · 14/20</p>
                <p className="mt-1 text-meta text-muted-foreground">
                  Caption · 12/16 chỉ dành cho metadata phụ.
                </p>
              </div>
            </div>
          </Specimen>

          <Specimen
            title="Geist Mono data"
            description="Tabular numerals giữ cột tiền và thời gian thẳng hàng."
          >
            <dl className="overflow-hidden rounded-xl border bg-card">
              {[
                ["Doanh thu", "1.250.000 ₫"],
                ["Thời gian", "08:30 – 21:45"],
                ["Mã đơn", "#AF-000128"],
                ["Bàn mẫu", "B-012"],
              ].map(([label, value]) => (
                <div
                  key={label}
                  className="flex items-center justify-between gap-4 border-b px-4 py-3 last:border-b-0"
                >
                  <dt className="text-sm text-muted-foreground">{label}</dt>
                  <dd className="numeric-data text-right text-sm font-semibold">
                    {value}
                  </dd>
                </div>
              ))}
            </dl>
          </Specimen>
        </div>

        <Specimen
          title="Long-form Vietnamese"
          description="Kiểm tra dấu, line-height và khả năng đọc ở độ dài thực tế."
        >
          <p className="max-w-3xl text-body text-muted-foreground">
            Một hệ thống vận hành tốt cần giúp người dùng nhận biết thông tin
            quan trọng mà không phải đọc lại nhiều lần. Những chi tiết như thời
            gian chờ, tổng tiền và trạng thái hệ thống phải giữ vị trí ổn định,
            sử dụng ngôn ngữ ngắn gọn và không phụ thuộc duy nhất vào màu sắc.
          </p>
        </Specimen>
      </div>
    </ShowcaseSection>
  )
}

export { TypographySection }
