import { ShowcaseSection, Specimen } from "@/app/design-system/showcase-section"
import { Checkbox } from "@/components/ui/checkbox"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { RadioGroup, RadioGroupItem } from "@/components/ui/radio-group"
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectLabel,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select"
import { Switch } from "@/components/ui/switch"
import { Textarea } from "@/components/ui/textarea"

function FieldMessage({
  id,
  children,
  error = false,
}: {
  id: string
  children: string
  error?: boolean
}) {
  return (
    <p
      id={id}
      role={error ? "alert" : undefined}
      className={error ? "text-xs text-destructive" : "text-xs text-muted-foreground"}
    >
      {children}
    </p>
  )
}

function FormsSection() {
  return (
    <ShowcaseSection
      id="forms"
      eyebrow="D · Form controls"
      title="Label thật, lỗi gần field, touch area đủ rộng"
      description="Các ví dụ dùng nội dung gần nghiệp vụ cafe nhưng chỉ để kiểm tra UI. Tab qua từng control để đánh giá focus ring thật."
    >
      <div className="grid gap-10">
        <div className="grid gap-10 xl:grid-cols-2">
          <Specimen title="Input states">
            <div className="grid gap-5">
              <div className="grid gap-2">
                <Label htmlFor="showcase-default-input">Tên hiển thị</Label>
                <Input
                  id="showcase-default-input"
                  className="min-h-target bg-card lg:min-h-control"
                  placeholder="Ví dụ: Quầy pha chế"
                  aria-describedby="default-input-help"
                />
                <FieldMessage id="default-input-help">
                  Label không được thay bằng placeholder.
                </FieldMessage>
              </div>

              <div className="grid gap-2">
                <Label htmlFor="showcase-focus-input">Focus preview</Label>
                <Input
                  id="showcase-focus-input"
                  defaultValue="AFTER FOUR"
                  className="min-h-target border-ring bg-card ring-3 ring-ring/50 lg:min-h-control"
                  aria-describedby="focus-input-help"
                />
                <FieldMessage id="focus-input-help">
                  Preview trực quan; focus thật vẫn hoạt động bằng bàn phím.
                </FieldMessage>
              </div>

              <div className="grid gap-2">
                <Label htmlFor="showcase-error-input">Mã tham chiếu</Label>
                <Input
                  id="showcase-error-input"
                  defaultValue="AF 128"
                  className="min-h-target bg-card lg:min-h-control"
                  aria-invalid="true"
                  aria-describedby="error-input-message"
                />
                <FieldMessage id="error-input-message" error>
                  Mã chỉ được chứa chữ, số và dấu gạch ngang.
                </FieldMessage>
              </div>

              <div className="grid gap-2">
                <Label htmlFor="showcase-disabled-input">Disabled</Label>
                <Input
                  id="showcase-disabled-input"
                  defaultValue="Không thể chỉnh sửa"
                  className="min-h-target lg:min-h-control"
                  disabled
                />
              </div>
            </div>
          </Specimen>

          <Specimen title="Textarea & Select">
            <div className="grid gap-5">
              <div className="grid gap-2">
                <Label htmlFor="showcase-textarea">Ghi chú minh họa</Label>
                <Textarea
                  id="showcase-textarea"
                  className="min-h-28 resize-y bg-card"
                  placeholder="Nội dung tiếng Việt dài hơn để kiểm tra line-height."
                  aria-describedby="textarea-help"
                />
                <FieldMessage id="textarea-help">
                  Không dùng placeholder làm hướng dẫn duy nhất.
                </FieldMessage>
              </div>

              <div className="grid gap-2">
                <Label htmlFor="showcase-select">Khu vực minh họa</Label>
                <Select defaultValue="ground">
                  <SelectTrigger
                    id="showcase-select"
                    className="min-h-target w-full bg-card lg:min-h-control"
                  >
                    <SelectValue placeholder="Chọn khu vực" />
                  </SelectTrigger>
                  <SelectContent>
                    <SelectGroup>
                      <SelectLabel>Khu vực mẫu</SelectLabel>
                      <SelectItem value="ground">Tầng 1 · mẫu</SelectItem>
                      <SelectItem value="upper">Tầng 2 · mẫu</SelectItem>
                    </SelectGroup>
                  </SelectContent>
                </Select>
              </div>

              <div className="grid gap-2">
                <Label htmlFor="showcase-select-disabled">Disabled Select</Label>
                <Select disabled>
                  <SelectTrigger
                    id="showcase-select-disabled"
                    className="min-h-target w-full lg:min-h-control"
                  >
                    <SelectValue placeholder="Không khả dụng" />
                  </SelectTrigger>
                </Select>
              </div>
            </div>
          </Specimen>
        </div>

        <div className="grid gap-10 xl:grid-cols-3">
          <Specimen title="Checkbox">
            <div className="grid gap-3">
              <label className="flex min-h-target cursor-pointer items-center gap-3 rounded-lg border bg-card px-3">
                <Checkbox defaultChecked aria-describedby="checkbox-help" />
                <span className="text-sm font-medium">In biên nhận mẫu</span>
              </label>
              <FieldMessage id="checkbox-help">
                Label mở rộng vùng chạm của checkbox.
              </FieldMessage>
              <label className="flex min-h-target items-center gap-3 rounded-lg border bg-muted px-3 opacity-60">
                <Checkbox disabled />
                <span className="text-sm">Tùy chọn bị khóa</span>
              </label>
            </div>
          </Specimen>

          <Specimen title="Radio Group">
            <RadioGroup
              defaultValue="comfortable"
              aria-label="Mật độ giao diện minh họa"
            >
              {[
                ["comfortable", "Thoải mái"],
                ["compact", "Gọn"],
                ["disabled", "Chưa khả dụng"],
              ].map(([value, label], index) => (
                <div
                  key={value}
                  className="flex min-h-target items-center gap-3 rounded-lg border bg-card px-3"
                >
                  <RadioGroupItem
                    id={"density-" + value}
                    value={value}
                    disabled={index === 2}
                  />
                  <Label htmlFor={"density-" + value} className="flex-1">
                    {label}
                  </Label>
                </div>
              ))}
            </RadioGroup>
          </Specimen>

          <Specimen title="Switch">
            <div className="grid gap-3">
              <label className="flex min-h-target cursor-pointer items-center justify-between gap-4 rounded-lg border bg-card px-3">
                <span className="text-sm font-medium">Âm thanh minh họa</span>
                <Switch defaultChecked aria-label="Bật âm thanh minh họa" />
              </label>
              <label className="flex min-h-target items-center justify-between gap-4 rounded-lg border bg-muted px-3 opacity-60">
                <span className="text-sm">Tùy chọn bị khóa</span>
                <Switch disabled aria-label="Tùy chọn bị khóa" />
              </label>
            </div>
          </Specimen>
        </div>
      </div>
    </ShowcaseSection>
  )
}

export { FormsSection }
