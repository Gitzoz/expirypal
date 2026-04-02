# .codex/RELEASE_MODE.md
# ExpiryCue Release Mode
Status: Mandatory For Release, Audit, Stability, TestFlight, And App Store Work

Release mode is a stricter operating mode.
It is activated whenever the task is about release preparation, stability, warning cleanup, audit work, TestFlight, App Store submission, screenshots, privacy verification, or final QA.

---

## 1. Hard Bans

When release mode is active:
- no new features
- no product scope expansion
- no UI redesigns
- no speculative architecture changes
- no dependency additions unless already approved by ADR

Only these categories are allowed:
- bug fixes
- warning cleanup
- crash-safety work
- data-integrity fixes
- test hardening
- localization audit
- privacy audit
- release assets
- metadata and submission preparation

---

## 2. Required Reads

Before making release-mode changes, read:
- `AGENTS.md`
- `docs/spec/ExpiryCueSpec.md`
- `.codex/WORKFLOW.md`
- `.codex/REVIEW_CHECKLIST.md`
- `docs/testing.md`
- `docs/release/checklist.md`

Read `.codex/ARCHITECTURE_GUARDS.md` if code changes are involved.

---

## 3. Required Validation

For release-critical code or asset changes, the minimum gate is:
- `./scripts/test.sh`
- `./scripts/check-release-screenshots.sh` when screenshots or store assets are relevant
- any additional deterministic validation required by the touched area

A task is not release-ready until the required validation has passed from the current worktree.

---

## 4. Final Visual Gate

For screenshot or store-asset work, the Reviewer / Release Engineer must inspect:
- `release-assets/screenshots/`
- `release-assets/store-composed/`
- `release-assets/store-submission/`

Required visual checks:
- no raw localization keys
- no English fallback in German assets
- no clipped or stale UI
- no stretched or squashed screenshots
- legible captions and titles
- consistent palette and branding
- no excessive dead space that weakens the composition

---

## 5. Environment Failure Handling

Classify failures correctly.

Possible classes:
- product defect
- test defect
- environment defect

Examples of environment defects:
- broken simulator state
- ambiguous destination selection
- CoreSimulator service failure
- Xcode toolchain instability

Do not silently work around those failures.
State them clearly and contain them.

---

## 6. Simulator Concurrency Rule

Do not run multiple simulator-driving jobs at the same time against the same simulator or destination class.
Serialize:
- UI tests
- screenshot-scene tests
- screenshot exports

Release-mode QA work must prefer stable, serialized validation over faster parallel runs.

---

## 7. Required Output

At the end of release-mode work, report:
- what changed
- what was validated
- what remains for release operations outside the repo
- any residual risks or environment issues
