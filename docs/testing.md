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
