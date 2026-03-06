# Settings Feature

## Goal
Allow users to configure local notification behavior through a single persisted settings record.

## Non-goals
- Theme controls
- Account or sync preferences
- Any features listed in AGENTS.md under `NON-GOALS (HARD BLOCK FOR V1)`

## User behavior
- Users can enable or disable notifications globally.
- Users can enable or disable 3-day, 1-day, and expiry-day reminders.
- Users can set the notification delivery time.
- Saving settings persists locally and reschedules notifications for active items.
- Notification controls remain visible even when disabled globally, but non-toggle controls are visually disabled until notifications are re-enabled.

## Implementation summary
- `AppSettings` is persisted with SwiftData and enforced as exactly one record.
- `SettingsViewModel` loads, edits, and saves notification preferences.
- Saving settings triggers notification rescheduling through the notification scheduling service.

## Tests
- Repository tests for exactly-one-settings semantics.
- ViewModel tests for loading defaults and saving changes.
- UI test for changing settings and persisting the new state.

## Localization notes
- Settings labels, help text, and save actions must use English and German localization keys.
- The settings screen should explicitly communicate that notifications are local only.
