import { useMemo } from "react"

import type { ColorToken } from "@/app/design-system/showcase-data"

function rgbToHex(color: string) {
  const channels = color.match(/\d+(?:\.\d+)?/g)?.slice(0, 3)

  if (!channels || channels.length !== 3) {
    return color
  }

  return `#${channels
    .map((channel) =>
      Math.round(Number(channel)).toString(16).padStart(2, "0")
    )
    .join("")
    .toUpperCase()}`
}

function resolveCssVariable(
  styles: CSSStyleDeclaration,
  variable: string,
  visited = new Set<string>()
): string {
  if (visited.has(variable)) {
    return variable
  }

  visited.add(variable)
  const value = styles.getPropertyValue(variable).trim()
  const reference = value.match(/^var\((--[^),\s]+)/)?.[1]

  if (reference) {
    return resolveCssVariable(styles, reference, visited)
  }

  return value.startsWith("#") ? value.toUpperCase() : rgbToHex(value)
}

function useResolvedCssColors(tokens: readonly ColorToken[]) {
  return useMemo(() => {
    const styles = window.getComputedStyle(document.documentElement)

    return Object.fromEntries(
      tokens.map(({ variable }) => [
        variable,
        resolveCssVariable(styles, variable),
      ])
    )
  }, [tokens])
}

type ColorSwatchGridProps = {
  tokens: readonly ColorToken[]
}

function ColorSwatchGrid({ tokens }: ColorSwatchGridProps) {
  const values = useResolvedCssColors(tokens)

  return (
    <div className="grid gap-px overflow-hidden rounded-xl border bg-border sm:grid-cols-2 xl:grid-cols-3">
      {tokens.map((token) => (
        <article key={token.variable} className="bg-card p-4">
          <div
            className="h-20 rounded-lg border border-foreground/10"
            style={{ backgroundColor: `var(${token.variable})` }}
          />
          <div className="mt-4 flex items-start justify-between gap-4">
            <div className="min-w-0">
              <h4 className="font-semibold">{token.name}</h4>
              <p className="mt-1 text-xs text-muted-foreground">{token.purpose}</p>
            </div>
            <div className="shrink-0 text-right">
              <p className="numeric-data text-sm font-semibold">
                {values[token.variable] ?? "…"}
              </p>
              <p className="mt-1 text-xs text-muted-foreground">
                {token.variable}
              </p>
            </div>
          </div>
        </article>
      ))}
    </div>
  )
}

export { ColorSwatchGrid }
