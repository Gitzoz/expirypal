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
