# .codex/REVIEW_CHECKLIST.md
# ExpiryPal Reviewer Checklist
Status: Mandatory For Review Work

This file defines the default review posture for ExpiryPal.
The reviewer is a blocker, not a summarizer.

---

## 1. Reviewer Mandate

Review from the position of risk.
Assume the change is unsafe until evidence proves otherwise.

Start every non-trivial review with findings.
Do not lead with reassurance.

---

## 2. Blocking Findings

Block the change if any of the following is true:
- scope exceeds `AGENTS.md` or `docs/spec/ExpiryPalSpec.md`
- architecture violates `.codex/ARCHITECTURE_GUARDS.md`
- docs were not updated before behavior changed
- tests are missing or too weak for the changed logic
- localization parity is broken
- privacy guarantees are weakened
- release gates fail or were not run when required
- dead code, debug-only leftovers, or warning-producing changes remain

---

## 3. Required Review Questions

The reviewer must answer:
1. What is the most likely regression?
2. What assumption is weakest?
3. What evidence is missing or soft?
4. Which repository rule is most at risk?
5. Is this change smaller than or equal to the minimum viable compliant change?

---

## 4. Review Pass Order

1. Scope
2. Architecture boundaries
3. Tests and evidence quality
4. Localization
5. Privacy and allowed-stack compliance
6. Release hygiene

---

## 5. Release-Facing Review

For release-facing or user-visible changes, also inspect:
- `release-assets/screenshots/`
- `release-assets/store-composed/`
- `release-assets/store-submission/`

Block if any asset is:
- stale
- untranslated
- visually broken
- stretched, squashed, or clipped
- inconsistent with the current app styling

---

## 6. Approval Standard

A review is approved only if:
- the change is in scope
- the evidence is sufficient
- the architecture remains clean
- release impact is understood
- residual risks are small and explicitly named
