# .codex/WORKFLOW.md
# ExpiryPal Codex Workflow
Status: Authoritative
Scope: All AI agents and contributors working in this repository

This document defines how work is performed in the ExpiryPal repository.

It enforces coordination while maintaining strict compliance with:
- AGENTS.md
- docs/spec/ExpiryPalSpec.md
- .codex/ARCHITECTURE_GUARDS.md

If any workflow step conflicts with AGENTS.md or the specification, the specification takes precedence.

----------------------------------------------------------------

## 1. Operating Principles

- Optimize for correctness and compliance over speed.
- Enforce strict v1 scope control; refuse non-goal requests.
- Keep architecture deterministic and testable.
- Preserve privacy guarantees (local-only, no tracking/analytics/SDKs).

----------------------------------------------------------------

## 2. Mandatory Change Protocol (Hard Gate)

Every change must follow this order. No exceptions.

1) Read relevant spec sections
   - AGENTS.md
   - docs/spec/ExpiryPalSpec.md
   - .codex/ARCHITECTURE_GUARDS.md

2) Confirm scope
   - If the task implies any NON-GOALS: refuse, cite “NON-GOALS (HARD BLOCK FOR V1)”, stop.

3) Update docs (docs-first)
   - Update the relevant doc(s) before code:
     - docs/features/
     - docs/architecture.md
     - docs/data-model.md
     - docs/notifications.md
     - docs/testing.md
     - docs/decisions/ (ADR when required)

4) Add or update tests (tests-before-logic)
   - Add/update XCTest unit tests for logic changes.
   - Add/update XCTest UI tests for user flows and localization.

5) Implement code
   - Follow MVVM + Repository + Services boundaries.
   - Use dependency injection via initializer only.
   - No hardcoded UI strings (I18n rules).

6) Run tests locally
   - scripts/test.sh must pass.

7) Update CHANGELOG
   - Required for any user-visible behavior change.
   - Optional for pure refactors (unless otherwise specified by spec/docs).

----------------------------------------------------------------

## 3. Role System (Execution Contexts)

Roles are operational responsibilities, not permanent assignments.
Agents may switch roles within a task.

### 3.1 Spec Guardian (Authority: Highest)
Responsibilities:
- Enforce AGENTS.md and docs/spec/ExpiryPalSpec.md.
- Block scope violations (NON-GOALS).
- Validate privacy guarantees and allowed tech stack.
- Verify repo structure and required files.

Stop conditions:
- Any scope violation
- Any forbidden dependency/framework/SDK
- Any privacy regression

### 3.2 Architecture Engineer
Responsibilities:
- Enforce MVVM + Repository + Services separation.
- Enforce DI (initializer injection) and no global mutable state.
- Own ADRs for architecture/tooling changes.
- Ensure Clock abstraction is used for time-dependent logic.

Triggers:
- Changes touching Models/Data/Services/ViewModels
- Notification scheduling system
- Date segmentation logic
- AppSettings semantics

### 3.3 iOS Feature Engineer
Responsibilities:
- Implement SwiftUI Views and ViewModels for allowed features.
- Ensure Views are UI-only and call ViewModel actions.
- Ensure localization is complete for user-facing strings.

### 3.4 Persistence Engineer
Responsibilities:
- SwiftData Models and Repository implementations.
- Queries, sorting, invariants.
- Exactly-one AppSettings record rule.

Owns:
- ExpiryPal/Models
- ExpiryPal/Data

### 3.5 Notification Systems Engineer
Responsibilities:
- Local notification scheduling, cancellation, rescheduling rules.
- Stable identifier scheme.
- Localization of notification content.

Owns:
- ExpiryPal/Services (notification-related)
- docs/notifications.md

### 3.6 Localization Engineer
Responsibilities:
- Enforce: no hardcoded UI strings.
- Maintain en/de parity for every localization key.
- Ensure at least one UI test runs under German locale and proves no English fallback.

Owns:
- ExpiryPal/Resources/en.lproj/Localizable.strings
- ExpiryPal/Resources/de.lproj/Localizable.strings

### 3.7 QA & Test Engineer
Responsibilities:
- Maintain XCTest unit test coverage for logic layers (target >= 80%).
- Maintain UI tests for required flows and German localization scenario.
- Prevent fabricated tests; tests must exercise real behavior.

Owns:
- ExpiryPalTests
- ExpiryPalUITests

### 3.8 Documentation Steward
Responsibilities:
- Enforce docs-first protocol.
- Update feature docs and reference docs.
- Ensure docs and implementation match.
- Update CHANGELOG for user-visible changes.

Owns:
- docs/
- CHANGELOG

----------------------------------------------------------------

## 4. Multi-Agent Collaboration Model

For non-trivial work, split responsibilities across roles/threads:

1) Spec Guardian: validate scope + constraints
2) Architecture Engineer: define compliant approach + any ADR need
3) Feature Engineer: implement UI + ViewModels
4) Persistence Engineer: update repositories/models as needed
5) Notification Engineer: update scheduling/content rules as needed
6) Localization Engineer: add/validate en+de keys and UI tests
7) QA Engineer: add/maintain unit+UI tests; ensure coverage expectations
8) Documentation Steward: finalize docs + changelog

Small tasks may be done by one agent, but must still pass all gates.

----------------------------------------------------------------

## 5. Isolation and Branching

Preferred: Git worktrees (one per agent thread).
Fallback: dedicated branches.

Branch naming:
- codex/<area>/<short-description>

Examples:
- codex/feature/add-item
- codex/tests/date-segmentation
- codex/i18n/settings-strings
- codex/notifications/idempotent-reschedule

----------------------------------------------------------------

## 6. Review Gate Checklist (Pre-Merge)

Scope:
- No NON-GOALS features.
- No backend, analytics, tracking, ads, or third-party SDKs.

Architecture:
- Views do not access SwiftData or system APIs.
- ViewModels do not access SwiftData directly.
- Repositories contain persistence only (no UI logic).
- Services contain system API logic only (no persistence).
- DI via initializer; no global mutable state; no custom singletons.

Localization:
- No hardcoded user-facing strings.
- Every new key exists in both en and de files.
- German UI test passes and shows German strings (no English fallback).

Notifications:
- Stable identifiers preserved.
- Cancel-before-schedule, idempotent.
- Skip past triggers.
- Cancel/reschedule rules enforced.
- Notification content localized.

Quality:
- scripts/test.sh passes.
- No build warnings.
- No dead code.
- Docs updated (and match behavior).
- CHANGELOG updated when user-visible behavior changed.

----------------------------------------------------------------

## 7. Commands

Run tests:
- scripts/test.sh

Any additional scripts must be deterministic and dependency-minimal.

----------------------------------------------------------------

## 8. Stop-and-Escalate Rules

If uncertain about scope, invariants, date segmentation, notification rules, or i18n:
- Stop implementation.
- Consult AGENTS.md and docs/spec/ExpiryPalSpec.md.
- Propose the smallest compliant option or require a docs/spec update first.

No speculative behavior.