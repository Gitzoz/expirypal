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
- non-active items are fetched separately for Archive queries.

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

## AppSettings
- `notificationsEnabled: Bool`
- `notifyDaysBefore: Int`
- `notifyOneDayBefore: Bool`
- `notifyOnDay: Bool`
- `notificationHour: Int`
- `notificationMinute: Int`

Invariants:
- exactly one `AppSettings` record exists
- defaults are `notificationsEnabled = true`, `notifyDaysBefore = 3`, `notifyOneDayBefore = true`, `notifyOnDay = true`
- default notification time is 09:00 local time

Persistence:
- `AppSettings` is stored locally with SwiftData.
- Settings repository is responsible for load-or-create semantics while preserving a single record.
