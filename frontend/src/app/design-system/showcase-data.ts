export type ColorToken = {
  name: string
  variable: `--${string}`
  purpose: string
}

export const brandColors: readonly ColorToken[] = [
  { name: "Coffee Brown", variable: "--brand-coffee", purpose: "Primary brand" },
  { name: "Warm White", variable: "--brand-warm-white", purpose: "App canvas" },
  { name: "Beige", variable: "--brand-beige", purpose: "Secondary surface" },
  { name: "Charcoal", variable: "--brand-charcoal", purpose: "Main foreground" },
  { name: "Clay", variable: "--brand-clay", purpose: "Restrained highlight" },
]

export const semanticColors: readonly ColorToken[] = [
  { name: "Background", variable: "--background", purpose: "Application canvas" },
  { name: "Foreground", variable: "--foreground", purpose: "Primary text" },
  { name: "Card", variable: "--card", purpose: "Independent surface" },
  {
    name: "Card foreground",
    variable: "--card-foreground",
    purpose: "Text on card",
  },
  { name: "Popover", variable: "--popover", purpose: "Overlay surface" },
  {
    name: "Popover foreground",
    variable: "--popover-foreground",
    purpose: "Text on overlay",
  },
  { name: "Primary", variable: "--primary", purpose: "Primary action" },
  {
    name: "Primary foreground",
    variable: "--primary-foreground",
    purpose: "Text on primary",
  },
  { name: "Secondary", variable: "--secondary", purpose: "Secondary action" },
  {
    name: "Secondary foreground",
    variable: "--secondary-foreground",
    purpose: "Text on secondary",
  },
  { name: "Muted", variable: "--muted", purpose: "Low-emphasis surface" },
  {
    name: "Muted foreground",
    variable: "--muted-foreground",
    purpose: "Secondary text",
  },
  { name: "Accent", variable: "--accent", purpose: "Hover and selection" },
  {
    name: "Accent foreground",
    variable: "--accent-foreground",
    purpose: "Text on accent",
  },
  { name: "Border", variable: "--border", purpose: "Subtle divider" },
  { name: "Input", variable: "--input", purpose: "Control boundary" },
  { name: "Ring", variable: "--ring", purpose: "Keyboard focus" },
  { name: "Destructive", variable: "--destructive", purpose: "Destructive action" },
  {
    name: "Destructive foreground",
    variable: "--destructive-foreground",
    purpose: "Text on destructive",
  },
]

export const statusColors: readonly ColorToken[] = [
  { name: "Success surface", variable: "--success", purpose: "Generic success" },
  {
    name: "Success foreground",
    variable: "--success-foreground",
    purpose: "Text on success",
  },
  { name: "Warning surface", variable: "--warning", purpose: "Generic attention" },
  {
    name: "Warning foreground",
    variable: "--warning-foreground",
    purpose: "Text on warning",
  },
  { name: "Error surface", variable: "--error", purpose: "Generic error" },
  {
    name: "Error foreground",
    variable: "--error-foreground",
    purpose: "Text on error",
  },
  {
    name: "Information surface",
    variable: "--information",
    purpose: "System information",
  },
  {
    name: "Information foreground",
    variable: "--information-foreground",
    purpose: "Text on information",
  },
]

export const sampleOrders = [
  { id: "#AF-000128", time: "09:42", label: "Mẫu A", amount: "125.000 ₫" },
  { id: "#AF-000129", time: "09:47", label: "Mẫu B", amount: "86.000 ₫" },
  { id: "#AF-000130", time: "09:51", label: "Mẫu C", amount: "214.000 ₫" },
] as const

export const sampleProducts = [
  { name: "Cà phê sữa", note: "Mẫu sản phẩm", price: "45.000 ₫" },
  { name: "Cold brew cam", note: "Mẫu sản phẩm", price: "58.000 ₫" },
  { name: "Matcha latte", note: "Mẫu sản phẩm", price: "62.000 ₫" },
] as const

export const sectionLinks = [
  ["tokens", "Tokens"],
  ["typography", "Typography"],
  ["buttons", "Buttons"],
  ["forms", "Forms"],
  ["feedback", "Feedback"],
  ["primitives", "Primitives"],
  ["preview", "POS preview"],
] as const
