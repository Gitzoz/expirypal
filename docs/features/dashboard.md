# Dashboard Feature

## Goal
Provide a single dashboard showing active food items segmented by expiry urgency.

## Non-goals
- Add/Edit/Archive/Settings flows
- Notifications UI changes
- Any non-v1 features listed in AGENTS.md

## User behavior
- Dashboard shows active items only.
- Segments are: Today, Next 3 Days, Later, All Active.
- Overdue items appear in Today.
- Active items are sorted by expiryDate ascending.

## Implementation summary
- `DashboardViewModel` loads active items from repository.
- Segmentation uses injected `Clock` and calendar day boundaries.
- `DashboardView` renders localized section headers and rows.

## Tests
- Unit tests for segmentation boundaries and overdue behavior.
- Unit tests for active filtering and sorting.
- UI test under German locale checks dashboard strings with no English fallback.

## Localization notes
- All dashboard text uses `Localizable.strings` keys.
- Every key exists in both English and German files.
