# Architecture

ExpiryPal uses MVVM + Repository + Services.

Dependency flow:
Views -> ViewModels -> Repositories/Services/Clock -> SwiftData Models

Rules:
- Views do not access SwiftData or system APIs.
- ViewModels do not access SwiftData directly.
- Repositories handle persistence only.
- Services wrap system APIs only.
- Dependencies are injected via initializers.

## Current Composition

- `FoodItem` is persisted with SwiftData.
- `AppSettings` is persisted with SwiftData and accessed through a dedicated settings repository.
- `SwiftDataFoodItemRepository` owns item create, update, archive, and query persistence logic.
- `SwiftDataAppSettingsRepository` owns the exactly-one settings record contract.
- `DashboardViewModel` reads active items from the repository and applies date segmentation with the injected `Clock`.
- `AddItemViewModel` and `EditItemViewModel` own item-form validation and persistence orchestration through repositories.
- `ArchiveViewModel` reads non-active items from the repository.
- `SettingsViewModel` loads and saves notification preferences through the settings repository.
- `NotificationSchedulingService` wraps `UserNotifications` and is invoked by ViewModels after item or settings changes.
- `ExpiryPalApp` builds the composition root and injects repositories, services, and `Clock` through `AppContainer`.
- `AppContainer` is responsible for deterministic SwiftData bootstrap, including the persistent store location and safe fallback behavior for release-stability fixes.

## Visual System Boundary

- Styling tokens and reusable view modifiers live in the UI layer only.
- Visual styling must not leak into ViewModels, Repositories, or Services.
- The app, public Pages site, and release assets should share the same brand palette derived from the app icon:
  - evergreen
  - warm sand
  - amber accent
- Consistency is required across app surfaces, but architectural boundaries remain unchanged.
