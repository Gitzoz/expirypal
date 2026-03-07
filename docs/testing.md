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

## Coverage Focus
- Business-logic coverage is tracked primarily across `Data`, `Services`, `ViewModels`, and `Utilities`.
- Release-preparation coverage work should prefer targeted branch tests for persistence updates, status transitions, scheduling rules, and no-op service behavior over adding new scope.
- The 80% target applies to business-logic layers rather than SwiftUI view rendering internals.
- Release-phase validation must also cover:
  - Release configuration compilation without product-source warnings
  - model/bootstrap safety for SwiftData startup paths
  - repository behavior that can differ between Debug and Release compilation

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

## Visual Consistency Validation

- Visual polish changes must not remove accessibility identifiers used by UI tests.
- App styling work should be validated by rerunning the existing user-flow UI tests rather than adding snapshot tooling.
- Public site styling changes must continue to pass `scripts/check-pages.sh` and must not introduce remote assets or tracking code.

## Release Screenshot Quality Gate

- Release screenshots are part of the quality gate, not a manual afterthought.
- Before a release-facing commit:
  - screenshot-scene UI assertions must pass
  - the automated screenshot export must be regenerated from the current build
  - composed store assets must be regenerated from the raw export
  - required screenshot files must exist for both device classes
- Screenshot-scene validation must catch:
  - raw localization keys such as `location.fridge`
  - English fallback in German screenshots
  - missing interpolated values for settings labels and dates
  - stale or missing exported files
- Screenshot-scene validation should also verify that raw screenshot-mode screens expose clear, localized titles for Add Item, Edit Item, Archive, and Settings.
- Repository test scripts must target a unique simulator UDID rather than an ambiguous device name when multiple runtimes expose the same simulator model.
