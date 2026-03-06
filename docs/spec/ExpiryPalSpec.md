# ExpiryPal Specification

Version: v1.0 Baseline
Status: Authoritative

This document defines the **complete functional and architectural specification** for ExpiryPal.

All development must comply with this document.

If any implementation conflicts with this specification, **the specification is correct and the implementation must be corrected**.

If a user request conflicts with the **NON-GOALS** section, the request must be refused until the specification is explicitly updated.

---

# 1. PRODUCT DEFINITION

ExpiryPal is a **minimalist, privacy-first iOS application** designed to help users reduce food waste by tracking food expiry dates and sending local notifications.

The application intentionally prioritizes **simplicity, privacy, and reliability** over feature expansion.

## Core Principles

ExpiryPal must always remain:

* Offline-first
* No user accounts
* No cloud sync
* No analytics
* No tracking
* No ads
* No backend infrastructure
* No third-party SDKs
* One-time purchase (~2.99€)
* Open source (MIT license for code only)
* Internationalized (English and German)

---

# 2. TECHNOLOGY STACK

The application must only use the following frameworks:

* SwiftUI
* SwiftData
* UserNotifications
* XCTest

No other frameworks, SDKs, or dependencies are permitted unless approved via an **Architecture Decision Record (ADR)**.

---

# 3. APPLICATION ARCHITECTURE

The architecture follows:

**MVVM + Repository + Services**

## Architectural Layers

### Models

Persistent SwiftData entities.

### Repositories

Responsible for data persistence and retrieval.

Repositories abstract SwiftData access from the rest of the system.

### Services

Responsible for wrapping system APIs such as notifications and time.

Services must never contain persistence logic.

### ViewModels

Contain business logic and orchestrate services and repositories.

### Views

SwiftUI UI layer only.

Views must contain **no business logic**.

---

## Strict Architectural Rules

Views:

* must NOT access SwiftData
* must NOT call system APIs

ViewModels:

* must NOT access SwiftData directly

Repositories:

* contain persistence logic only
* must not contain UI logic

Services:

* wrap system APIs only
* must not contain persistence logic

Dependencies must be **injected via initializer**.

Forbidden:

* global mutable state
* custom singletons

---

# 4. DATA MODEL

## FoodItem

Fields:

id: UUID
name: String
expiryDate: Date
location: StorageLocation
quantity: Double?
note: String?
status: ItemStatus
createdAt: Date
updatedAt: Date

### Invariants

* name must be trimmed
* name must not be empty
* active items appear only in Dashboard
* consumed and discarded items appear only in Archive
* active items must be sorted by expiryDate ascending

---

## Enums

### StorageLocation

fridge
freezer
pantry

### ItemStatus

active
consumed
discarded

---

## AppSettings

Fields:

notificationsEnabled: Bool
notifyDaysBefore: Int (default 3)
notifyOneDayBefore: Bool
notifyOnDay: Bool
notificationTime: DateComponents (default 09:00 local)

Constraints:

Exactly **one AppSettings record must exist** in the database.

---

# 5. SCREEN STRUCTURE

The following screens must exist in version 1.

## Dashboard

Displays grouped active items:

Today
Next 3 Days
Later
All Active

Items must appear in chronological order.

---

## Add Item Screen

Allows creation of a FoodItem.

Required inputs:

* name
* expiry date
* storage location

Optional inputs:

* quantity
* note

Validation must occur before saving.

---

## Edit Item Screen

Allows modification of an existing FoodItem.

Updating expiry date must trigger notification rescheduling.

---

## Archive Screen

Displays non-active items:

* consumed
* discarded

Archive entries must never appear in the Dashboard.

---

## Settings Screen

Allows configuration of notification behavior.

Settings include:

* enable notifications
* notify 3 days before
* notify 1 day before
* notify on expiry day
* notification time

---

# 6. DATE SEGMENTATION

Items must be segmented using the following rules.

Assume:

startOfToday
startOfTomorrow

## Today

expiryDate >= startOfToday
expiryDate < startOfTomorrow

## Next 3 Days

expiryDate >= startOfTomorrow
expiryDate < startOfToday + 4 days

## Later

expiryDate >= startOfToday + 4 days

---

## Overdue Handling

Items with expiryDate < startOfToday must still appear in the **Today section**.

---

# 7. CLOCK ABSTRACTION

Business logic must never call `Date()` directly.

A clock abstraction must be used.

```
protocol Clock {
    var now: Date { get }
}
```

Implementations:

SystemClock
TestClock

All services and ViewModels must use injected Clock instances.

---

# 8. NOTIFICATION SYSTEM

Notifications are **local only**.

Each FoodItem generates up to three notifications.

## Notification Identifiers

fooditem.<UUID>.d3
fooditem.<UUID>.d1
fooditem.<UUID>.d0

---

## Notification Timing

Possible triggers:

3 days before expiry
1 day before expiry
on expiry day

Trigger time must use **AppSettings.notificationTime**.

---

## Scheduling Rules

Scheduling must be **idempotent**.

Before scheduling new notifications:

Existing notifications for the item must be cancelled.

Rules:

* Past triggers must be skipped
* Notifications must be cancelled when item status changes
* Notifications must be rescheduled when settings change
* Notifications must be cancelled when notifications are disabled

Notification content must be localized.

---

# 9. INTERNATIONALIZATION

Supported languages:

English (base)
German

All user-facing text must be localized.

Hardcoded UI strings are forbidden.

---

## Localization Structure

ExpiryPal/Resources/en.lproj/Localizable.strings
ExpiryPal/Resources/de.lproj/Localizable.strings

---

## Localization Rules

Every key must exist in both languages.

Missing keys are not allowed.

Date formatting must use the system locale.

---

# 10. TESTING REQUIREMENTS

Testing must use **XCTest only**.

Unit tests must cover:

* date segmentation logic
* validation rules
* notification scheduling logic
* ViewModel behavior
* repository queries

UI tests must cover:

* adding items
* editing items
* marking items consumed
* marking items discarded
* changing notification settings
* German localization scenario

Business logic layers must reach **≥80% test coverage**.

---

# 11. PROJECT STRUCTURE

The repository must follow this structure.

```
ExpiryPal/
  App/
  Models/
  Data/
  Services/
  ViewModels/
  Views/
  Utilities/
  Theme/
  Screens/
  Resources/
    en.lproj/
    de.lproj/

ExpiryPalTests/
ExpiryPalUITests/

docs/
  index.md
  architecture.md
  data-model.md
  notifications.md
  testing.md
  features/
  decisions/
```

---

# 12. DOCUMENTATION DISCIPLINE

Documentation is authoritative.

Priority order:

1. ADRs (docs/decisions)
2. Architecture / data model / notifications
3. feature documentation
4. code comments

If documentation and code conflict:

Documentation must be updated first.

Every feature document must contain:

Goal
Non-goals
User behavior
Implementation summary
Tests
Localization notes

---

# 13. CHANGE PROTOCOL

All changes must follow this order:

1. Update documentation
2. Add or update tests
3. Implement code
4. Run tests
5. Update CHANGELOG

---

# 14. DEFINITION OF DONE

A change is complete only if:

* The project builds without warnings
* All tests pass
* Documentation is updated
* CHANGELOG updated
* No dead code remains
* All new strings localized in English and German

---

# 15. PRIVACY GUARANTEES

ExpiryPal guarantees:

* All user data stored locally
* No tracking
* No analytics
* No third-party SDKs
* Notifications are local only

The `PRIVACY` document must accurately reflect the implementation.

---

# 16. BRAND LICENSE

The MIT license applies to source code only.

The ExpiryPal name, logo, and branding assets are **not covered by the MIT license**.

Brand assets remain proprietary unless explicitly granted.
