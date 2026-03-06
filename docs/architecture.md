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
- `SwiftDataFoodItemRepository` owns create/query persistence logic for items.
- `DashboardViewModel` reads active items from the repository and applies date segmentation with the injected `Clock`.
- `AddItemViewModel` owns form validation and save orchestration through the repository.
- `ExpiryPalApp` builds the composition root and injects dependencies through `AppContainer`.
