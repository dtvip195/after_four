import { ArrowLeft, FileQuestion } from "lucide-react"
import { Link } from "react-router"

import { Button } from "@/components/ui/button"

function NotFoundPage() {
  return (
    <div>
      <header className="border-b pb-6">
        <p className="text-meta font-bold tracking-label text-brand-clay">APPLICATION SHELL</p>
        <h1 className="mt-2 text-page font-semibold tracking-heading sm:text-display">
          Không tìm thấy trang
        </h1>
        <p className="mt-2 max-w-2xl text-sm leading-6 text-muted-foreground sm:text-base">
          Đường dẫn này chưa thuộc cấu trúc điều hướng của AFTER FOUR.
        </p>
      </header>

      <section className="py-10 md:py-14" aria-labelledby="not-found-title">
        <div className="max-w-xl border-l-2 border-brand-clay pl-5 sm:pl-6">
          <span className="flex size-11 items-center justify-center rounded-xl bg-accent text-accent-foreground">
            <FileQuestion aria-hidden="true" className="size-5" />
          </span>
          <h2 id="not-found-title" className="mt-5 text-section font-semibold tracking-heading">
            Hãy quay lại Dashboard
          </h2>
          <p className="mt-2 text-sm leading-6 text-muted-foreground">
            Chọn một destination trong navigation hoặc trở về route mặc định.
          </p>
          <Button asChild className="mt-5 min-h-target">
            <Link to="/dashboard">
              <ArrowLeft aria-hidden="true" />
              Về Dashboard
            </Link>
          </Button>
        </div>
      </section>
    </div>
  )
}

export { NotFoundPage }
