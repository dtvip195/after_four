import {
  CheckCircle2,
  CircleAlert,
  CircleX,
  Info,
  LoaderCircle,
  MoreHorizontal,
} from "lucide-react"

import { ShowcaseSection, Specimen } from "@/app/design-system/showcase-section"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Progress } from "@/components/ui/progress"
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
} from "@/components/ui/tooltip"

const feedbackItems = [
  {
    title: "Thao tác hoàn tất",
    description: "Đây là thông báo success minh họa, không phải trạng thái nghiệp vụ.",
    className: "border-success-foreground/25 bg-success text-success-foreground",
    icon: CheckCircle2,
  },
  {
    title: "Cần kiểm tra",
    description: "Warning có text và icon để không phụ thuộc duy nhất vào màu.",
    className: "border-warning-foreground/25 bg-warning text-warning-foreground",
    icon: CircleAlert,
  },
  {
    title: "Không thể tiếp tục",
    description: "Error message nói rõ tình trạng và cần có hướng phục hồi.",
    className: "border-error-foreground/25 bg-error text-error-foreground",
    icon: CircleX,
  },
  {
    title: "Thông tin hệ thống",
    description: "Information dùng cho nội dung trung tính, không cạnh tranh primary action.",
    className:
      "border-information-foreground/25 bg-information text-information-foreground",
    icon: Info,
  },
] as const

function FeedbackSection() {
  return (
    <ShowcaseSection
      id="feedback"
      eyebrow="E · Feedback & status"
      title="Tín hiệu có nhãn, icon và độ ưu tiên rõ"
      description="Các status dưới đây là semantic feedback tổng quát. Chúng chưa quyết định vocabulary hoặc mapping trạng thái bàn và đơn hàng."
    >
      <div className="grid gap-10">
        <Specimen title="Badges">
          <div className="flex flex-wrap gap-3">
            <Badge>Default</Badge>
            <Badge variant="secondary">Secondary</Badge>
            <Badge variant="outline">Outline</Badge>
            <Badge variant="destructive">Destructive</Badge>
            <Badge className="border-transparent bg-success text-success-foreground">
              <CheckCircle2 aria-hidden="true" />
              Success
            </Badge>
            <Badge className="border-transparent bg-warning text-warning-foreground">
              <CircleAlert aria-hidden="true" />
              Warning
            </Badge>
            <Badge aria-disabled="true" className="opacity-50">
              Disabled
            </Badge>
          </div>
        </Specimen>

        <Specimen title="Alerts">
          <div className="grid gap-4 lg:grid-cols-2">
            {feedbackItems.map(
              ({ title, description, className, icon: Icon }) => (
                <Alert key={title} className={className}>
                  <Icon aria-hidden="true" />
                  <AlertTitle>{title}</AlertTitle>
                  <AlertDescription>{description}</AlertDescription>
                </Alert>
              )
            )}
          </div>
        </Specimen>

        <div className="grid gap-10 xl:grid-cols-2">
          <Specimen
            title="Tooltip"
            description="Tooltip bổ sung giải thích trên desktop; icon button vẫn có accessible name."
          >
            <Tooltip>
              <TooltipTrigger asChild>
                <Button
                  variant="outline"
                  size="icon"
                  className="size-target"
                  aria-label="Mở thêm tùy chọn minh họa"
                >
                  <MoreHorizontal aria-hidden="true" />
                </Button>
              </TooltipTrigger>
              <TooltipContent>Mở thêm tùy chọn</TooltipContent>
            </Tooltip>
          </Specimen>

          <Specimen title="Progress & loading">
            <div className="grid gap-5">
              <div>
                <div className="mb-2 flex items-center justify-between gap-4 text-sm">
                  <span className="font-medium">Tiến trình minh họa</span>
                  <span className="numeric-data text-muted-foreground">68%</span>
                </div>
                <Progress value={68} aria-label="Tiến trình minh họa 68 phần trăm" />
              </div>
              <Alert aria-live="polite">
                <LoaderCircle aria-hidden="true" className="animate-spin" />
                <AlertTitle>Đang tải dữ liệu mẫu</AlertTitle>
                <AlertDescription>
                  Loading giữ một thông điệp ổn định và không nhấp nháy liên tục.
                </AlertDescription>
              </Alert>
            </div>
          </Specimen>
        </div>
      </div>
    </ShowcaseSection>
  )
}

export { FeedbackSection }
