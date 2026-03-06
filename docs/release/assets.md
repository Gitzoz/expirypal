# Asset Checklist

## Required Before Submission
- App icon set for iPhone
- 6.7-inch iPhone screenshots
- 6.1-inch iPhone screenshots
- Optional promotional graphic for repository/site updates

## Screenshot Plan

Recommended screenshots:
1. Dashboard with multiple upcoming items
2. Add Item form
3. Edit Item flow
4. Archive view
5. Settings with local notification controls
6. German-localized dashboard

Detailed shot list:
- [Screenshot Shot List](screenshots.md)

Automated generation:
- Use `scripts/generate-store-screenshots.sh` to build, install, launch scene-specific screenshot states, and capture output into `release-assets/screenshots/`.
- The automated flow uses deterministic in-app screenshot mode rather than manual UI driving.
- Use `scripts/check-release-screenshots.sh` as the release gate wrapper so validation runs before export.
- Use `scripts/generate-store-compositions.sh` to convert raw captures into App Store-ready composed assets under `release-assets/store-composed/`.

## Screenshot Rules
- Use realistic but non-personal demo data
- Keep dates plausible and readable
- Avoid placeholder lorem ipsum
- Ensure no simulator chrome is visible in final store assets
- Capture both empty and populated states only if they help explain the product
- Final store compositions must add headline/subheadline context so the set explains the app quickly in App Store browsing.

## App Icon Rules
- Keep the icon simple and legible at small sizes
- Prefer fewer, bolder shapes over decorative detail
- Make the app purpose understandable at first glance: food + date tracking
- Avoid text in the icon
- Ensure the icon does not depend on gradients so subtle they disappear at small scale
- Respect the proprietary branding rule for the ExpiryPal name and assets

## Visual Direction
- Use the existing app icon as the brand anchor for release assets.
- Prefer the shared ExpiryPal palette:
  - evergreen for structure
  - warm sand for backgrounds and surfaces
  - amber for emphasis only
- Screenshots, site graphics, and any release visuals should feel like one product family rather than separate one-off treatments.

Current repo assets:
- App icon catalog target: `ExpiryPal/Assets.xcassets/AppIcon.appiconset/`
- Icon source files: `docs/release/icon-source/`
