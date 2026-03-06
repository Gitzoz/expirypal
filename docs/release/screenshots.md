# Screenshot Shot List

## Device Sets
- 6.7-inch iPhone
- 6.1-inch iPhone

## English Screens
1. Dashboard populated with Today, Next 3 Days, and Later items
2. Add Item form with clean default state
3. Edit Item view with an existing item
4. Archive populated with consumed and discarded examples
5. Settings with notifications enabled and a non-default reminder schedule

## German Screen
1. Dashboard localized in German with no English fallback

## Demo Data Guidance
- Use realistic food names: Milk, Yogurt, Spinach, Bread, Soup, Frozen Berries
- Include fridge, freezer, and pantry locations
- Include at least one archived consumed item and one discarded item
- Keep notes short and believable

## Capture Workflow
1. Run `scripts/check-release-screenshots.sh`
2. Review generated images in `release-assets/screenshots/`
3. Review composed store assets in `release-assets/store-composed/`
3. Retake only if product copy, seeded data, or visual design changes
4. Review for clipping, inconsistent dates, raw localization keys, and stray debug content

## Quality Gate Rules
- Screenshot export is only valid if the screenshot-scene UI assertions pass first.
- Any screenshot showing raw localization keys, untranslated fallback, or stale styling must block commit/release work until regenerated.
- Exported screenshots must be regenerated after user-visible style changes.
- Composed App Store screenshots must be regenerated from the current raw export and approved as part of release readiness.
- Raw screenshot scenes must keep their in-app navigation titles legible on first glance; the export may not depend on faint large-title rendering for screen identification.

## Automated Scenes
- `dashboard`
- `addItem`
- `editItem`
- `archive`
- `settings`
- `dashboard` in German

## Store Composition Rules
- Final store assets are composed from the raw simulator captures, not captured manually.
- Composition must keep the raw screenshot intact inside a marketing frame:
  - strong headline
  - short supporting line
  - icon-backed brand context
  - shared background/palette
- Final composed assets must preserve the original device screenshot dimensions for each class.
- Scene-specific framing may crop empty lower space, but must not hide the core action shown in the screen.
- Raw captures should still read cleanly on their own before composition, especially for modal screens such as Add Item and Edit Item.

## English Story Order
1. Dashboard: `Track food before it expires`
2. Add Item: `Add items in seconds`
3. Edit Item: `Update dates and status fast`
4. Archive: `Keep consumed items organized`
5. Settings: `Local reminders. No cloud. No tracking.`
