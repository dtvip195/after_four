import { ArrowLeft, Coffee } from "lucide-react"

import { BrandTokensSection } from "@/app/design-system/brand-tokens-section"
import { ButtonsSection } from "@/app/design-system/buttons-section"
import { FeedbackSection } from "@/app/design-system/feedback-section"
import { FormsSection } from "@/app/design-system/forms-section"
import { PosPreviewSection } from "@/app/design-system/pos-preview-section"
import { PrimitivesSection } from "@/app/design-system/primitives-section"
import { sectionLinks } from "@/app/design-system/showcase-data"
import { TypographySection } from "@/app/design-system/typography-section"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"

function DesignSystemPage() {
  return (
    <main className="min-h-svh bg-background text-foreground">
      <header className="border-b bg-card">
        <div className="mx-auto max-w-[90rem] px-4 py-6 sm:px-6 lg:px-8">
          <div className="flex flex-col gap-6 lg:flex-row lg:items-end lg:justify-between">
            <div>
              <a
                href="/dashboard"
                className="inline-flex min-h-target items-center gap-2 rounded-lg text-sm font-medium text-muted-foreground outline-none hover:text-foreground focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2"
              >
                <ArrowLeft aria-hidden="true" className="size-4" />
                Application shell
              </a>
              <div className="mt-8 flex items-start gap-4">
                <div className="flex size-12 shrink-0 items-center justify-center rounded-xl bg-primary text-primary-foreground">
                  <Coffee aria-hidden="true" className="size-6" />
                </div>
                <div>
                  <div className="flex flex-wrap items-center gap-2">
                    <p className="text-meta font-bold tracking-label text-brand-clay">
                      AFTER FOUR
                    </p>
                    <Badge variant="outline">Internal playground</Badge>
                  </div>
                  <h1 className="mt-2 text-display font-bold tracking-heading">
                    Component Showcase
                  </h1>
                  <p className="mt-3 max-w-2xl text-sm leading-6 text-muted-foreground md:text-base">
                    Kiểm tra design token, typography và UI primitive trước khi
                    xây POS Application Shell.
                  </p>
                </div>
              </div>
            </div>
            <div className="rounded-lg border border-warning-foreground/20 bg-warning px-4 py-3 text-sm text-warning-foreground lg:max-w-sm">
              HEX hiện tại là giá trị khởi đầu để review, chưa phải màu thương
              hiệu chính thức.
            </div>
          </div>

          <nav aria-label="Điều hướng trong Showcase" className="mt-8 flex flex-wrap gap-2">
            {sectionLinks.map(([href, label]) => (
              <Button
                key={href}
                variant="outline"
                size="sm"
                className="min-h-target px-3"
                asChild
              >
                <a href={`#${href}`}>{label}</a>
              </Button>
            ))}
          </nav>
        </div>
      </header>

      <div className="mx-auto max-w-[90rem] px-4 sm:px-6 lg:px-8">
        <BrandTokensSection />
        <TypographySection />
        <ButtonsSection />
        <FormsSection />
        <FeedbackSection />
        <PrimitivesSection />
        <PosPreviewSection />
      </div>

      <footer className="border-t bg-card">
        <div className="mx-auto flex max-w-[90rem] flex-col gap-2 px-4 py-8 text-sm text-muted-foreground sm:px-6 md:flex-row md:items-center md:justify-between lg:px-8">
          <p>AFTER FOUR · Design system playground</p>
          <p>Phase 3.2.3 · Internal development only</p>
        </div>
      </footer>
    </main>
  )
}

export { DesignSystemPage }
