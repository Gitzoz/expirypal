# App Store Connect Checklist

Use this file as the copy-paste source when the Apple Developer account is fully active.

## App Record

- Name: `ExpiryPal`
- Platform: `iOS`
- Primary language: `English (U.S.)` or your preferred English locale
- Bundle ID: match Xcode exactly
- SKU: `expirypal-ios-1`

## App Information

- Subtitle: `Food Expiry Tracker`
- Category: `Food & Drink`
- Secondary category: optional, leave empty unless needed
- Content rights: confirm you own the content and branding

## URLs

- Support URL: `https://github.com/Gitzoz/expirypal`
- Marketing URL: `https://gitzoz.github.io/expirypal/`
- Privacy Policy URL: `https://gitzoz.github.io/expirypal/privacy.html`

## Promotional Text

`Track expiry dates, reduce food waste, and get local reminders. No account, no ads, no tracking.`

## Description

`ExpiryPal is a minimalist iOS app for reducing food waste without giving up your privacy.

Use ExpiryPal to:
- add food items with an expiry date and storage location
- see what expires today, in the next 3 days, or later
- edit items as plans change
- archive consumed or discarded items
- control local reminder timing in Settings

ExpiryPal is intentionally small:
- no accounts
- no analytics
- no ads
- no backend
- no cloud sync
- English and German localization

Your data stays on your device. Notifications are scheduled locally.

ExpiryPal is a one-time purchase:
- no subscription
- no upsells
- no locked premium tier
- one focused app with the full feature set included`

## Keywords

`food expiry, food waste, expiry tracker, kitchen tracker, food reminder, pantry, fridge, freezer`

## Pricing

- Paid app
- Target price: about `€2.99`
- Choose the matching Apple price tier in App Store Connect

## Screenshots

Upload from:
- `release-assets/store-submission/6.7-inch/`
- `release-assets/store-submission/6.5-inch/`
- `release-assets/store-submission/5.5-inch/`

Recommended screen order:
1. Dashboard
2. Add Item
3. Edit Item
4. Archive
5. Settings

## App Privacy

Expected answers based on the current implementation:
- no tracking
- no analytics
- no accounts
- no backend
- local-only data storage
- local-only notifications
- no third-party SDKs

Cross-check against:
- `PRIVACY.md`
- `ExpiryPal/Resources/PrivacyInfo.xcprivacy`

## Build Metadata

- Version: `1.0`
- Build: `1`

## Final Pre-Submit Check

- upload and attach the processed build
- verify pricing and availability
- verify screenshots are attached
- verify URLs are live
- verify privacy answers match the app
- start internal TestFlight before App Review submission
