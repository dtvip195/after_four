const cashSuggestionStepsVnd = [50000, 100000, 200000, 500000] as const

function parseVndInput(value: string) {
  const normalizedValue = value.trim()

  if (!/^\d+$/.test(normalizedValue)) {
    return undefined
  }

  const amount = Number(normalizedValue)
  return Number.isSafeInteger(amount) ? amount : undefined
}

function getCashChangeVnd(receivedAmountVnd: number, subtotalVnd: number) {
  return receivedAmountVnd >= subtotalVnd
    ? receivedAmountVnd - subtotalVnd
    : undefined
}

function getCashSuggestionsVnd(subtotalVnd: number) {
  const suggestions = [
    subtotalVnd,
    ...cashSuggestionStepsVnd.map(
      (step) => Math.ceil(subtotalVnd / step) * step
    ),
  ]

  return [...new Set(suggestions)].filter((amount) => amount > 0).slice(0, 4)
}

export { getCashChangeVnd, getCashSuggestionsVnd, parseVndInput }
