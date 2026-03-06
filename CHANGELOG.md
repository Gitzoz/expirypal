# Changelog

## Unreleased
- Added Edit Item, Archive, Settings, and local notification scheduling documentation.
- Added `AppSettings` persistence with an enforced single-record repository boundary.
- Added Edit Item, Archive, and Settings screens with MVVM + Repository + Services wiring.
- Added local notification scheduling with stable identifiers, cancel-before-reschedule behavior, and settings-driven resync.
- Added repository update/status-transition APIs and archive queries for active vs non-active item flows.
- Added unit coverage for app settings persistence, edit behavior, notification scheduling, and settings behavior.
- Added UI coverage for Edit Item, Archive, and Settings flows.
- Updated Dashboard to avoid duplicate active item rendering and support edit/archive actions cleanly.
- Added a GitHub Pages-ready static landing/docs site under `docs/site/`.
- Added a deterministic Pages validation script in `scripts/check-pages.sh`.
- Added a GitHub Actions workflow for Pages deployment from repository-managed static files.
- Added public docs governance for the Pages site, including a feature doc and ADR.
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
