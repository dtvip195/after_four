import type { ReactNode } from "react"

import { cn } from "@/lib/utils"

type ShowcaseSectionProps = {
  id: string
  eyebrow: string
  title: string
  description: string
  children: ReactNode
  className?: string
}

function ShowcaseSection({
  id,
  eyebrow,
  title,
  description,
  children,
  className,
}: ShowcaseSectionProps) {
  return (
    <section
      id={id}
      aria-labelledby={`${id}-title`}
      className={cn("scroll-mt-24 border-t border-border py-12 md:py-16", className)}
    >
      <div className="mb-8 max-w-3xl">
        <p className="text-meta font-semibold tracking-label text-brand-clay">
          {eyebrow}
        </p>
        <h2
          id={`${id}-title`}
          className="mt-2 text-page font-semibold tracking-heading text-foreground"
        >
          {title}
        </h2>
        <p className="mt-3 text-sm leading-6 text-muted-foreground md:text-base">
          {description}
        </p>
      </div>
      {children}
    </section>
  )
}

type SpecimenProps = {
  title: string
  description?: string
  children: ReactNode
  className?: string
}

function Specimen({ title, description, children, className }: SpecimenProps) {
  return (
    <div className={cn("border-t border-border pt-5", className)}>
      <div className="mb-5">
        <h3 className="text-section font-semibold tracking-heading">{title}</h3>
        {description ? (
          <p className="mt-1 text-sm leading-5 text-muted-foreground">
            {description}
          </p>
        ) : null}
      </div>
      {children}
    </div>
  )
}

export { ShowcaseSection, Specimen }
