const floorOptions = [
  { value: "floor-1", label: "Tầng 1" },
  { value: "floor-2", label: "Tầng 2" },
] as const

type FloorId = (typeof floorOptions)[number]["value"]

function isFloorId(value: string): value is FloorId {
  return floorOptions.some((floor) => floor.value === value)
}

function getFloorLabel(floorId: FloorId) {
  return floorOptions.find((floor) => floor.value === floorId)?.label ?? "Tầng 1"
}

export { floorOptions, getFloorLabel, isFloorId }
export type { FloorId }
