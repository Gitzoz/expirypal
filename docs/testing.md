# Testing

Use XCTest only.

## Dashboard Coverage
- Date segmentation boundaries (Today / Next 3 Days / Later)
- Overdue item handling (treated as Today)
- Active-item filtering
- Ascending sort by expiryDate
- German localization scenario with no English fallback on dashboard UI

## Add Item Coverage
- Validation for trimmed non-empty name
- Repository create/query behavior with SwiftData
- ViewModel save success and validation failure
- UI flow for adding an item and seeing it on Dashboard

## Edit and Archive Coverage
- Validation for editing existing items
- Repository update and status transition behavior
- Active/archive query separation
- UI flow for editing an item from Dashboard
- UI flow for marking an item consumed or discarded and seeing it move to Archive

## Settings and Notification Coverage
- Exactly-one `AppSettings` repository behavior
- Settings ViewModel default loading and persistence
- Notification scheduling identifiers and trigger dates
- Notification cancel/reschedule rules for settings changes and status changes
- UI flow for changing notification settings

## Pages Validation

The public GitHub Pages site is validated with deterministic repository checks rather than browser automation.

Validation scope:
- required static site files exist
- key internal links point to valid site pages or repository docs
- no external scripts, analytics, tracking, or remote assets are referenced

Out of scope:
- visual regression testing
- browser-specific layout snapshots
- third-party uptime checks
