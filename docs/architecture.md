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
