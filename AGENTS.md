# AGENTS.md

ExpiryPal Repository Constitution

This file defines the non-negotiable operating rules for any agent working in this repository.
If any instruction conflicts with this file, this file wins.

Agents must refuse requests that violate scope and cite the relevant section.

---

# 1. Authority Order

Use this precedence order.

1. `AGENTS.md`
2. `docs/spec/ExpiryPalSpec.md`
3. `docs/decisions/` ADRs
4. `.codex/ARCHITECTURE_GUARDS.md`
5. `.codex/WORKFLOW.md`
6. supporting reference docs such as:
   - `docs/architecture.md`
   - `docs/data-model.md`
   - `docs/notifications.md`
   - `docs/testing.md`
   - `docs/release/checklist.md`
   - `docs/features/`
7. code comments

If documentation conflicts with code, update documentation first, then update code.

---

# 2. Product Definition

ExpiryPal is a minimalist, privacy-first iOS app that helps users reduce food waste by tracking food expiry dates and sending local notifications.

The product must remain:
- offline-first
- no accounts
- no tracking
- no analytics
- no ads
- no backend
- no third-party SDKs
- paid app (~2.99€)
- open source for code only (MIT)
- internationalized in English and German only

Detailed product behavior lives in `docs/spec/ExpiryPalSpec.md`.

---

# 3. Allowed Stack

Only these Apple frameworks may be used unless an ADR explicitly approves otherwise:
- SwiftUI
- SwiftData
- UserNotifications
- XCTest

---

# 4. Scope Lock

The v1 scope is defined by `docs/spec/ExpiryPalSpec.md`.

Allowed screens:
- Dashboard
- Add Item
- Edit Item
- Archive
- Settings

Hard-blocked non-goals for v1 include:
- barcode scanning
- OCR
- widgets
- iCloud sync
- backend sync
- analytics
- sharing
- recipes
- categories
- AI features
- statistics
- subscriptions
- in-app purchases
- ads
- additional languages beyond English and German

If a request implies any of these:
1. refuse the request
2. cite `NON-GOALS (HARD BLOCK FOR V1)` from the spec or this file
3. stop until the specification is explicitly updated

---

# 5. Hard Operating Rules

- Treat repository documentation as authoritative.
- Do not introduce product scope that is not already documented.
- Do not add dependencies, frameworks, SDKs, or services outside the allowed stack unless approved by ADR.
- Do not bypass architecture rules in the name of speed.
- Do not treat release work as feature work.
- Do not silently reinterpret ambiguous scope; stop and escalate.

---

# 6. Required Reads By Task Type

For all tasks:
- `AGENTS.md`
- relevant sections of `docs/spec/ExpiryPalSpec.md`

For code changes:
- `.codex/WORKFLOW.md`
- `.codex/ARCHITECTURE_GUARDS.md`

For release, audit, stability, TestFlight, or App Store work:
- `.codex/RELEASE_MODE.md`
- `docs/testing.md`
- `docs/release/checklist.md`

For review work:
- `.codex/REVIEW_CHECKLIST.md`

---

# 7. Architecture Summary

ExpiryPal uses:
- MVVM + Repository + Services

Structural enforcement lives in `.codex/ARCHITECTURE_GUARDS.md`.
Detailed product rules stay in the spec.

---

# 8. Internationalization Summary

Supported languages:
- English
- German

Hard rules:
- all user-facing text must be localized
- no hardcoded UI strings
- all keys must exist in both language files
- date formatting must use the system locale

Detailed localization rules stay in the spec.

---

# 9. Privacy Summary

ExpiryPal must guarantee:
- data stored locally only
- local notifications only
- no tracking
- no analytics
- no third-party SDKs

`PRIVACY.md` must match the implementation exactly.

---

# 10. Change Protocol Summary

Every change must follow this order:
1. update documentation
2. add or update tests when behavior changes
3. implement code
4. run validation
5. update `CHANGELOG.md` when behavior or release state changes

Detailed execution and handoffs live in `.codex/WORKFLOW.md`.

---

# 11. Definition Of Done

A task is done only if:
- the project builds without warnings
- all required tests pass
- documentation is updated
- `CHANGELOG.md` is updated when required
- no dead code remains
- all relevant strings are localized in English and German

Release tasks must additionally satisfy `.codex/RELEASE_MODE.md`.

---

# 12. Scope Enforcement

If a request violates scope:
- refuse the request
- reference the relevant section
- wait for specification changes before proceeding
