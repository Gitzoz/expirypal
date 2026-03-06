# Archive Feature

## Goal
Display all non-active food items in a dedicated archive screen.

## Non-goals
- Advanced filtering or search
- Undo history beyond direct item editing
- Any features listed in AGENTS.md under `NON-GOALS (HARD BLOCK FOR V1)`

## User behavior
- Archive shows consumed and discarded items only.
- Archived items never appear in Dashboard.
- Users can open an archived item and update its details.
- Archive is automatically refreshed after status changes.
- Archive rows should make status and storage location easy to scan.

## Implementation summary
- `ArchiveViewModel` loads non-active items from repository queries.
- `ArchiveView` displays consumed and discarded items in a dedicated tab.
- Repository queries enforce the active/archive split.

## Tests
- Repository tests for fetching only non-active items.
- UI test for moving an item to Archive and verifying it is removed from Dashboard.

## Localization notes
- Archive labels, empty states, and status descriptions must be localized in English and German.
