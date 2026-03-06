# Data Model

## FoodItem
- id: UUID
- name: String
- expiryDate: Date
- location: StorageLocation
- quantity: Double?
- note: String?
- status: ItemStatus
- createdAt: Date
- updatedAt: Date

Invariants:
- `name` is trimmed before persistence.
- `name` must not be empty after trimming.
- active items are fetched in ascending `expiryDate` order.
- non-active items are excluded from Dashboard queries.

## StorageLocation
- fridge
- freezer
- pantry

## ItemStatus
- active
- consumed
- discarded

## Persistence

- `FoodItem` is stored locally with SwiftData.
- Repository APIs are responsible for enforcing persistence rules and validation failures returned from save operations.
