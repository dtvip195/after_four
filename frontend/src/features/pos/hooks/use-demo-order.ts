import { useState } from "react"

import type { PosDemoOrderLine } from "@/features/pos/types/pos"

function useDemoOrder() {
  const [orderLines, setOrderLines] = useState<PosDemoOrderLine[]>([])

  function addProduct(productId: string) {
    setOrderLines((currentLines) => {
      const existingLine = currentLines.find((line) => line.productId === productId)

      if (!existingLine) {
        return [...currentLines, { productId, quantity: 1, note: "" }]
      }

      return currentLines.map((line) =>
        line.productId === productId
          ? { ...line, quantity: line.quantity + 1 }
          : line
      )
    })
  }

  function increaseQuantity(productId: string) {
    setOrderLines((currentLines) =>
      currentLines.map((line) =>
        line.productId === productId
          ? { ...line, quantity: line.quantity + 1 }
          : line
      )
    )
  }

  function decreaseQuantity(productId: string) {
    setOrderLines((currentLines) =>
      currentLines.map((line) =>
        line.productId === productId
          ? { ...line, quantity: Math.max(1, line.quantity - 1) }
          : line
      )
    )
  }

  function removeProduct(productId: string) {
    setOrderLines((currentLines) =>
      currentLines.filter((line) => line.productId !== productId)
    )
  }

  function updateNote(productId: string, note: string) {
    setOrderLines((currentLines) =>
      currentLines.map((line) =>
        line.productId === productId ? { ...line, note } : line
      )
    )
  }

  function clearOrder() {
    setOrderLines([])
  }

  return {
    orderLines,
    addProduct,
    clearOrder,
    decreaseQuantity,
    increaseQuantity,
    removeProduct,
    updateNote,
  }
}

export { useDemoOrder }
