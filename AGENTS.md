# AGENTS.md

ExpiryPal Repository Guardrails

This file defines the **non-negotiable operating rules** for any AI agent working in the ExpiryPal repository.

If any instruction conflicts with these rules, **this file takes precedence**.

Agents must **refuse tasks that violate scope** and cite the relevant section.

---

# PRODUCT DEFINITION

ExpiryPal is a **minimalist, privacy-first iOS application** that helps users reduce food waste by tracking food expiry dates and sending local notifications.

The product must remain:

* Offline-first
* No accounts
* No tracking
* No analytics
* No ads
* No backend
* No third-party SDKs
* Paid app (~2.99€)
* Open source (MIT for code only)
* Internationalized (English + German)

Any proposal that violates these constraints must be refused.

---

# ALLOWED TECH STACK

Only the following frameworks may be used:

* SwiftUI
* SwiftData
* UserNotifications
* XCTest

No additional frameworks, libraries, SDKs, or services are allowed unless approved through an ADR.

---

# MVP FUNCTIONAL SCOPE (STRICT)

FoodItem fields:

* id: UUID
* name: String (required, trimmed, non-empty)
* expiryDate: Date (required)
* location: StorageLocation (fridge | freezer | pantry)
* quantity: Double?
* note: String?
* status: ItemStatus (active | consumed | discarded)
* createdAt: Date
* updatedAt: Date

Required screens:

* Dashboard
* Add Item
* Edit Item
* Archive
* Settings

Notifications:

* 3 days before expiry
* 1 day before expiry
* On expiry day
* Local notifications only
* Globally configurable

---

# NON-GOALS (HARD BLOCK FOR V1)

The following features are explicitly forbidden in v1:

* Barcode scanning
* OCR
* Widgets
* iCloud sync
* Backend sync
* Analytics
* Sharing
* Recipes
* Categories
* AI features
* Statistics
* Subscriptions
* In-app purchases
* Ads
* Additional languages beyond English and German

If a request implies any of these features:

1. Refuse the request.
2. Cite **“NON-GOALS (HARD BLOCK FOR V1)”**.
3. Continue only after the specification is explicitly updated.

---

# INTERNATIONALIZATION RULES

Supported languages:

* English (base)
* German

Requirements:

* All user-facing text must be localized.
* No hardcoded UI strings are allowed.
* Use `Localizable.strings`.

Required structure:

ExpiryPal/Resources/en.lproj/Localizable.strings
ExpiryPal/Resources/de.lproj/Localizable.strings

Every key must exist in both languages.

Date formatting must use the system locale.

Tests must include at least one scenario where the device language is German and no English fallback appears.

---

# ARCHITECTURE

Architecture must follow:

MVVM + Repository + Services

Layers:

Models
Repositories
Services
ViewModels
Views

Hard separation rules:

Views

* must not access SwiftData
* must not call system APIs

ViewModels

* must not access SwiftData directly

Repositories

* contain data persistence logic only

Services

* wrap system APIs only

Dependencies must be injected via initializer.

Forbidden:

* global mutable state
* custom singletons

---

# DATA MODEL RULES

Enums:

StorageLocation

* fridge
* freezer
* pantry

ItemStatus

* active
* consumed
* discarded

FoodItem invariants:

* name must be trimmed and non-empty
* active items appear only in Dashboard
* non-active items appear only in Archive
* active lists sorted ascending by expiryDate

AppSettings:

* notificationsEnabled
* notifyDaysBefore (default 3)
* notifyOneDayBefore
* notifyOnDay
* notificationTime (default 09:00 local)

Exactly one AppSettings record must exist.

---

# DATE SEGMENTATION

Today

expiryDate >= startOfToday
expiryDate < startOfTomorrow

Next 3 Days

expiryDate >= startOfTomorrow
expiryDate < startOfToday + 4 days

Later

expiryDate >= startOfToday + 4 days

Overdue items are treated as Today.

---

# CLOCK RULE

Business logic must not call `Date()` directly.

A clock abstraction must be used:

protocol Clock {
var now: Date { get }
}

Implementations:

SystemClock
TestClock

All time logic must use the injected clock.

---

# NOTIFICATION RULES

Stable identifiers:

fooditem.<UUID>.d3
fooditem.<UUID>.d1
fooditem.<UUID>.d0

Scheduling rules:

* Scheduling must be idempotent.
* Existing notifications must be cancelled before rescheduling.
* Past triggers must be skipped.
* Notifications cancelled when item status changes.
* Notifications rescheduled when settings change.
* Notifications cancelled when notifications disabled.

Notification content must be localized.

---

# TESTING REQUIREMENTS

Unit tests must cover:

* Date segmentation
* Validation
* Notification scheduling logic
* ViewModel behavior
* Repository queries

UI tests must cover:

* Add item
* Edit item
* Mark consumed or discarded
* Change settings
* German localization scenario

Use XCTest only.

Target:

Minimum 80% coverage for business logic layers.

---

# DOCUMENTATION DISCIPLINE

Documentation is authoritative.

Priority order:

1. Architecture Decision Records (docs/decisions)
2. Architecture / Data Model / Notifications docs
3. Feature documentation
4. Code comments

If code and docs conflict:

Update documentation first, then update code.

Every feature document must contain:

* Goal
* Non-goals
* User behavior
* Implementation summary
* Tests
* Localization notes (if applicable)

Undocumented behavior is not allowed.

---

# CHANGE PROTOCOL

For every change:

1. Update documentation
2. Add or update tests
3. Implement code
4. Run tests
5. Update CHANGELOG

Definition of Done:

* Project builds without warnings
* All tests pass
* Documentation updated
* CHANGELOG updated
* No dead code
* All strings localized in English and German

---

# PRIVACY REQUIREMENTS

The project must guarantee:

* Data stored locally only
* No tracking
* No analytics
* No third-party SDKs
* Notifications are local only

The PRIVACY document must accurately reflect the implementation.

---

# BRAND LICENSE

The MIT license applies to source code only.

The ExpiryPal name, logo, and branding assets are **not covered by the MIT license** and remain proprietary unless explicitly granted.

---

# SCOPE ENFORCEMENT

Agents must enforce this specification strictly.

If a request violates scope:

* Refuse the request
* Reference the relevant section
* Await a specification update before proceeding
