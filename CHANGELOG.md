# Changelog

## Unreleased
- Added Dashboard feature baseline with MVVM + Repository + Services scaffolding.
- Added Dashboard segmentation logic (Today, Next 3 Days, Later, All Active) with overdue mapped to Today.
- Added English and German dashboard localization keys.
- Added dashboard unit tests and German localization UI test scaffold.
- Added SwiftData-backed `FoodItem` persistence through `SwiftDataFoodItemRepository`.
- Added Add Item documentation, view model, view, and dashboard sheet navigation.
- Added English and German localization keys for the Add Item flow and storage locations.
- Added Add Item unit/UI tests, including blank optional quantity coverage.
- Tightened `FoodItem` invariants to normalize names and reject invalid persisted enum raw values.
- Added baseline governance and architecture documentation required by repository workflow.
