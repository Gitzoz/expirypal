# .codex/ARCHITECTURE_GUARDS.md
# ExpiryCue Architecture Guards
Status: Mandatory Enforcement

This file defines non-negotiable architectural constraints.
If code violates these guards, it must be corrected before merging.

----------------------------------------------------------------

## 1. Architecture Overview

Architecture: MVVM + Repository + Services

Allowed dependency flow:

Views -> ViewModels -> (Repositories, Services, Clock) -> SwiftData Models

Services wrap system APIs (e.g., UserNotifications). Repositories wrap persistence (SwiftData).

----------------------------------------------------------------

## 2. Forbidden Dependencies (Hard Rules)

### 2.1 Views MUST NOT
- import SwiftData
- access persistence / repositories directly
- call system APIs (including UserNotifications)
- contain business logic (segmentation, validation, scheduling, etc.)

Views MAY
- render state
- bind inputs
- call ViewModel intents/actions
- display localized strings

### 2.2 ViewModels MUST NOT
- access SwiftData directly (no ModelContext usage)
- query SwiftData directly
- call SwiftUI types for business logic decisions

ViewModels MUST
- use repositories for data access
- use services for system API access
- use injected Clock for time logic
- contain business logic (validation, segmentation orchestration)

### 2.3 Repositories MUST NOT
- contain UI logic
- reference Views or ViewModels
- call UserNotifications or other system APIs (except SwiftData persistence APIs)

Repositories MUST
- encapsulate SwiftData queries and persistence operations
- enforce persistence-level constraints (e.g., exactly one AppSettings record)
- provide predictable query semantics (sorting, filtering)

### 2.4 Services MUST NOT
- persist data (no SwiftData access)
- contain UI logic
- contain cross-domain business rules unrelated to the system API they wrap

Services MUST
- wrap system APIs (e.g., scheduling local notifications)
- be deterministic given inputs (and injected Clock if time-related)

----------------------------------------------------------------

## 3. Dependency Injection (DI) Guards

Hard rules:
- All dependencies injected via initializer.
- No global mutable state.
- No custom singletons.

Forbidden patterns:
- static shared instances
- service locator globals
- hidden global caches

Allowed patterns:
- init(repository:..., service:..., clock:...)
- explicit composition root in App layer

----------------------------------------------------------------

## 4. Clock Rule (No Date() in Business Logic)

Business logic MUST NOT call Date().

Define and use:
- protocol Clock { var now: Date { get } }
- SystemClock
- TestClock

Clock must be injected into:
- ViewModels that do date segmentation or validation logic tied to "now"
- notification scheduling logic
- any service that makes decisions based on current time

----------------------------------------------------------------

## 5. Date Segmentation Guards (Authoritative)

Use injected Clock.now and calendar start-of-day boundaries.

Definitions:
- startOfToday = start of day for Clock.now
- startOfTomorrow = startOfToday + 1 day

Buckets:
- Today: expiryDate >= startOfToday AND expiryDate < startOfTomorrow
- Next 3 Days: expiryDate >= startOfTomorrow AND expiryDate < startOfToday + 4 days
- Later: expiryDate >= startOfToday + 4 days
- Overdue (expiryDate < startOfToday): treat as Today

No alternative segmentation logic is allowed without spec update.

----------------------------------------------------------------

## 6. Data Model Guards

### 6.1 Enums
StorageLocation:
- fridge
- freezer
- pantry

ItemStatus:
- active
- consumed
- discarded

### 6.2 FoodItem Invariants
- name must be trimmed
- name must be non-empty
- active items appear only in Dashboard
- non-active items appear only in Archive
- active lists sorted by expiryDate ascending

### 6.3 AppSettings
Fields:
- notificationsEnabled
- notifyDaysBefore (default 3)
- notifyOneDayBefore
- notifyOnDay
- notificationTime (default 09:00 local)

Constraint:
- Exactly one AppSettings record must exist.

Repositories must enforce the “exactly one settings record” rule.

----------------------------------------------------------------

## 7. Notification System Guards

### 7.1 Stable Identifiers (must not change)
- fooditem.<UUID>.d3
- fooditem.<UUID>.d1
- fooditem.<UUID>.d0

### 7.2 Rules (must be enforced)
- Idempotent scheduling (safe to call repeatedly)
- Cancel before scheduling
- Skip past triggers
- Cancel on status change (consumed/discarded)
- Reschedule on settings change
- Cancel all if notifications disabled
- Notification content must be localized (en + de)

No background sync. No remote notifications.

----------------------------------------------------------------

## 8. Localization Guards (en + de only)

Hard rules:
- No hardcoded user-facing UI strings.
- All strings must be localized via Localizable.strings.
- Every key must exist in both languages.
- Missing keys are not allowed.

Required paths:
- ExpiryCue/Resources/en.lproj/Localizable.strings
- ExpiryCue/Resources/de.lproj/Localizable.strings

Must localize:
- Buttons, titles, labels, errors, empty states, alerts
- Settings labels
- Notification titles/bodies

Date formatting:
- Use system locale; no hardcoded date formats.

Testing:
- At least one UI test must run under German locale and prove no English fallback appears.

----------------------------------------------------------------

## 9. Allowed Frameworks Guard

Allowed only:
- SwiftUI
- SwiftData
- UserNotifications
- XCTest

Any addition requires an ADR in docs/decisions and explicit approval.

----------------------------------------------------------------

## 10. “Red Flag” Examples (Reject in Review)

Reject changes that include any of:
- Text("Some English") in Views (unless using localization)
- import SwiftData inside Views
- ModelContext usage inside ViewModels
- Date() used inside ViewModels/Services for decisions
- new dependency/framework without ADR
- missing German localization for any new key
- notification identifiers changed or non-idempotent scheduling
