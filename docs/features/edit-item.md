# Edit Item Feature

## Goal
Allow users to update an existing food item and change its active status through a dedicated edit screen.

## Non-goals
- Bulk editing
- Archive filtering controls beyond the baseline archive list
- Any features listed in AGENTS.md under `NON-GOALS (HARD BLOCK FOR V1)`

## User behavior
- Users can open an existing active item from Dashboard.
- Users can update name, expiry date, location, quantity, and note.
- Users can mark an item as consumed or discarded from the edit screen.
- Saving valid changes persists locally and returns the user to the previous screen.
- Marking an item consumed or discarded removes it from Dashboard and moves it to Archive.

## Implementation summary
- `EditItemViewModel` owns editable form state, validation, save, and status-transition intents.
- `FoodItemRepository` updates item fields and active/non-active status through explicit methods.
- `DashboardViewModel` reloads active items after edit dismissal.
- Notification rescheduling/cancellation is triggered through an injected notification scheduling service.

## Tests
- Unit tests for edit validation and successful updates.
- Repository tests for updating existing items and status transitions.
- UI test for editing an item and seeing Dashboard reflect the updated values.
- UI test for marking an item consumed or discarded.

## Localization notes
- All edit screen text, actions, and status buttons must use `Localizable.strings`.
- English and German keys must remain in parity.
