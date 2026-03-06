# Privacy

## App Privacy Summary

ExpiryPal is a local-only iOS application.

Food item data and notification preferences are stored on device with SwiftData. The app does not create accounts, does not transmit data to a backend, and does not depend on third-party SDKs or remote services.

ExpiryPal does not use:
- tracking
- analytics
- advertising
- crash reporting services
- backend APIs
- cloud sync
- third-party SDKs

## Data Stored On Device

ExpiryPal stores the following data locally:
- food item names
- expiry dates
- storage locations
- optional quantities
- optional notes
- item status (`active`, `consumed`, `discarded`)
- timestamps for creation and updates
- notification preference settings

## Notifications

ExpiryPal uses local notifications only.

Notification scheduling is performed on device through Apple system APIs. Notification content is generated locally from the stored food item data and the user's local notification settings.

The app does not send notification data to any server.

## Network Use

The app itself does not require network access for its core behavior.

This repository may also publish a public GitHub Pages site that describes the product and links to the documentation. That site is informational only and separate from the app's runtime behavior.

## Public Website Summary

If the GitHub Pages site is published, it must remain:
- informational only
- free of account systems
- free of form submission or backend processing
- free of analytics, tracking pixels, ads, and third-party embeds
- limited to static HTML and CSS hosted by GitHub Pages

## Source of Truth

This document must stay aligned with the actual implementation in:
- `ExpiryPal/`
- `docs/notifications.md`
- `docs/architecture.md`
