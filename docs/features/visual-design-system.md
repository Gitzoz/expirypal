# Visual Design System

## Goal
Define a consistent visual language for the ExpiryCue app, public GitHub Pages site, and release assets using the existing app icon as the brand anchor.

## Non-goals
- Changing product scope or adding new screens
- Adding custom fonts, external assets, JavaScript, or third-party design dependencies
- Introducing visual behavior that changes business logic

## User behavior
- The app should feel visually consistent across Dashboard, Add Item, Edit Item, Archive, and Settings.
- The public site should look like the same product family as the app and icon.
- Release assets should follow the same palette and surface language instead of looking disconnected from the app.

## Implementation summary
- The icon palette is the source of truth:
  - evergreen structure
  - warm sand surfaces
  - restrained amber accents
- The icon itself should stay reduced and geometric so it reads at small App Store and Home Screen sizes.
- The icon concept should be literal enough to communicate food + date tracking on first glance, not only brand mood.
- The launch screen should be static and minimal:
  - warm sand background from the app palette
  - centered app logo from the repository icon source
  - no loading text, animation, or extra marketing copy
- SwiftUI screens use the same rounded-card and soft-background treatment across list and form flows.
- The public Pages site uses the same palette, rounded geometry, and icon-based branding anchor.
- Styling remains inside the View layer; ViewModels, Repositories, and Services are unchanged.

## Tests
- Continue running `scripts/test.sh` to ensure styling changes do not regress required flows.
- Continue running `scripts/check-pages.sh` to ensure the public site remains static, local-asset-only, and analytics-free.
- Localization parity tests remain the guardrail for any new user-facing copy introduced during polish.

## Localization notes
- Styling changes must not introduce hardcoded user-facing text.
- Any new app copy must be added to both `en` and `de` localization files before implementation is considered done.
