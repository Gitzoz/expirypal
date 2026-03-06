# Add Item Feature

## Goal
Allow users to create a new food item with the required fields defined in the specification.

## Non-goals
- Editing existing items
- Archive/status transitions
- Notification scheduling UI
- Any features listed in AGENTS.md under `NON-GOALS (HARD BLOCK FOR V1)`

## User behavior
- Users can open the Add Item screen from Dashboard.
- Users must provide a non-empty trimmed name.
- Users must provide an expiry date.
- Users must select a storage location.
- Quantity and note remain optional.
- Saving a valid item persists it locally and returns the user to Dashboard.

## Implementation summary
- `AddItemViewModel` owns form state and validation.
- `FoodItemRepository` persists the new item.
- `DashboardViewModel` reloads active items after dismissal of the Add Item screen.
- Persistence uses SwiftData only through the repository layer.

## Tests
- Unit tests for validation and successful save behavior.
- Repository tests for local persistence and active-item sorting.
- UI test that adds an item and verifies it appears on Dashboard.

## Localization notes
- All form labels, actions, and validation errors are stored in `Localizable.strings`.
- English and German keys must remain in parity.
