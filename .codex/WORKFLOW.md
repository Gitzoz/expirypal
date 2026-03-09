# .codex/WORKFLOW.md
# ExpiryPal Execution Workflow
Status: Authoritative
Scope: All agents and contributors working in this repository

This file defines how work is executed in ExpiryPal.
If workflow conflicts with `AGENTS.md` or the specification, the higher-authority document wins.

---

## 1. Operating Principles

- Optimize for correctness and compliance over speed.
- Use the smallest compliant change, not the most elaborate one.
- Keep role boundaries explicit.
- Prefer evidence over intent.
- For non-trivial tasks, operate as a 5-role team.

---

## 2. Mandatory Change Protocol

Every change follows this order.

1. Read the required authority docs.
2. Confirm scope before implementation.
3. Update documentation first.
4. Add or update tests when behavior changes.
5. Implement code.
6. Run validation.
7. Update `CHANGELOG.md` when behavior or release state changed.

No skipping and no reordering.

---

## 3. Task Modes

### 3.1 Minor Task
Use when:
- the change is small
- there is no architecture ambiguity
- there is no cross-layer design work
- there is no release risk

Default mode:
- single thread
- explicit reviewer pass before finalizing

### 3.2 Standard Task
Use when:
- the change affects a normal feature slice or bug fix
- docs, tests, and code all need attention
- multiple roles need input but the write set is still coherent

Default mode:
- 5-role collaboration in one working thread or one worktree

### 3.3 Cross-Cutting Task
Use when:
- the change touches multiple layers or subsystems
- architecture, persistence, tests, and release validation all matter

Default mode:
- 5-role collaboration
- use separate worktrees only if write ownership is cleanly disjoint

### 3.4 Release-Critical Task
Use when:
- the task affects build stability
- project structure changes
- persistence safety changes
- notifications, localization, privacy, or screenshots are involved
- the user asks for release, audit, stability, TestFlight, or App Store work

Default mode:
- activate `.codex/RELEASE_MODE.md`
- reviewer / release engineer is the final gate

---

## 4. Five Roles

### 4.1 Spec Guardian
Responsibility:
- enforce `AGENTS.md` and `docs/spec/ExpiryPalSpec.md`
- block scope drift
- state what is in scope and what is explicitly untouched

Required output for non-trivial tasks:
- scope contract
- non-goals check
- stop conditions

### 4.2 Architect
Responsibility:
- enforce `.codex/ARCHITECTURE_GUARDS.md`
- define allowed dependency path and forbidden shortcuts
- decide whether an ADR is required

Required output for non-trivial tasks:
- architecture note
- file-level boundary guidance
- risks to avoid

### 4.3 iOS Engineer
Responsibility:
- execute the change within approved scope and boundaries
- follow docs -> tests -> code -> validation
- keep implementation minimal and compliant

Required output:
- changed docs list
- changed tests list
- changed code paths
- validation run summary

### 4.4 QA Engineer
Responsibility:
- define what evidence is required before code is considered safe
- maintain test discipline
- classify failures correctly as product, test, or environment issues

Required output for non-trivial tasks:
- required test list
- likely regression list
- validation result summary

### 4.5 Reviewer / Release Engineer
Responsibility:
- review adversarially
- block weak, under-tested, or out-of-scope changes
- own release-facing readiness

Required output:
- findings first
- go / no-go decision
- residual risk summary

Reviewer must not be the primary implementer for a non-trivial task.

---

## 5. Mandatory Handoffs

For any standard, cross-cutting, or release-critical task:

1. Spec Guardian produces the scope contract.
2. Architect produces the architecture note.
3. QA Engineer defines the required evidence.
4. iOS Engineer performs the change.
5. Reviewer / Release Engineer performs the final blocking review.

If any handoff is missing, the task is not done.

---

## 6. Multi-Agent And Worktree Rules

Use one working thread when:
- the task is minor
- multiple agents would touch the same files
- coordination cost is higher than the task itself

Use multiple agents in one worktree when:
- the task is standard
- parallel thinking helps
- only one role is doing most of the editing

Use separate worktrees when:
- the task is cross-cutting or release-critical
- write ownership is disjoint
- interfaces are already understood

Recommended worktree ownership:
- iOS Engineer: `ExpiryPal/App`, `ExpiryPal/ViewModels`, `ExpiryPal/Views`
- Architect or implementation support: `ExpiryPal/Data`, `ExpiryPal/Models`, `ExpiryPal/Services`
- QA Engineer: `ExpiryPalTests`, `ExpiryPalUITests`, validation scripts
- Reviewer / Release Engineer: release docs, changelog, release assets, final validation notes

---

## 7. Validation Rules

Default validation:
- run the relevant tests for the change
- run `scripts/test.sh` for any substantial code change

Release-critical validation:
- follow `.codex/RELEASE_MODE.md`

Environment failures must be called out explicitly.
Do not mislabel simulator or toolchain instability as a product defect.

---

## 8. Reviewer Rules

The reviewer must:
- start with findings, not summary
- review the actual diff, not just the plan
- block on scope, architecture, localization, test, privacy, and release-gate failures
- use `.codex/REVIEW_CHECKLIST.md`

The reviewer may say:
- no-go: scope mismatch
- no-go: boundary violation
- no-go: insufficient test evidence
- no-go: release risk not contained

---

## 9. Concurrency Limits

Do not run simulator-driving jobs concurrently against the same simulator.
Examples:
- UI tests
- screenshot-scene tests
- automated screenshot exports

Release-mode QA work must serialize those jobs.

---

## 10. Stop And Escalate

Stop and escalate when:
- scope is ambiguous
- docs and code disagree materially
- architecture boundaries are unclear
- release validation is flaky and root cause is unknown
- a requested change implies a non-goal or new product scope

Do not guess. Use the smallest compliant interpretation or require a specification update.
