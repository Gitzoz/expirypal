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

## StorageLocation
- fridge
- freezer
- pantry

## ItemStatus
- active
- consumed
- discarded
