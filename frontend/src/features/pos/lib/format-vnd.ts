const vndNumberFormatter = new Intl.NumberFormat("vi-VN", {
  maximumFractionDigits: 0,
})

function formatVnd(amount: number) {
  return `${vndNumberFormatter.format(amount)} ₫`
}

export { formatVnd }
