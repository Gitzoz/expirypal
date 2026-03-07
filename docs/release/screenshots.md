# Screenshot Shot List

## Capture Device Sets
- 6.7-inch iPhone design master
- 6.1-inch iPhone design master

## Submission Device Sets
- 6.7-inch: `1290 x 2796`
- 6.5-inch: `1242 x 2688`
- 5.5-inch: `1242 x 2208`

## English Screens
1. Dashboard populated with Today, Next 3 Days, and Later items
2. Add Item form with clean default state
3. Edit Item view with an existing item
4. Archive populated with consumed and discarded examples
5. Settings with notifications enabled and a non-default reminder schedule

## German Screens
1. Dashboard localized in German with no English fallback
2. Add Item localized in German
3. Edit Item localized in German
4. Archive localized in German
5. Settings localized in German

## Demo Data Guidance
- Use realistic food names: Milk, Yogurt, Spinach, Bread, Soup, Frozen Berries
- Include fridge, freezer, and pantry locations
- Include at least one archived consumed item and one discarded item
- Keep notes short and believable

## Capture Workflow
1. Run `scripts/check-release-screenshots.sh`
2. Review generated images in `release-assets/screenshots/`
3. Review composed store assets in `release-assets/store-composed/`
4. Review submission exports in `release-assets/store-submission/`
5. Retake only if product copy, seeded data, or visual design changes
6. Review for clipping, inconsistent dates, raw localization keys, and stray debug content

## Quality Gate Rules
- Screenshot export is only valid if the screenshot-scene UI assertions pass first.
- Any screenshot showing raw localization keys, untranslated fallback, or stale styling must block commit/release work until regenerated.
- Exported screenshots must be regenerated after user-visible style changes.
- Composed App Store screenshots must be regenerated from the current raw export and approved as part of release readiness.
- Raw screenshot scenes must keep their in-app navigation titles legible on first glance; the export may not depend on faint large-title rendering for screen identification.
- Submission exports must be regenerated from the current composed masters and validated at exact target pixel sizes.

## Automated Scenes
- `dashboard`
- `addItem`
- `editItem`
- `archive`
- `settings`
- `dashboard` in German
- `addItem` in German
- `editItem` in German
- `archive` in German
- `settings` in German

## Store Composition Rules
- Final store assets are composed from the raw simulator captures, not captured manually.
- Composition must keep the raw screenshot intact inside a marketing frame:
  - strong headline
  - short supporting line
  - icon-backed brand context
  - shared background/palette
- Final composed assets must preserve the original device screenshot dimensions for each class.
- The screenshot image inside the composed frame must preserve its own aspect ratio; composition may crop or pad, but it may not stretch the screen vertically or horizontally.
- Scene-specific framing may crop empty lower space, but must not hide the core action shown in the screen.
- Composition should avoid excessive empty area inside the framed screenshot; form, archive, and settings scenes should crop to the active content and use a tight device frame so the visible product UI, not the empty lower canvas, dominates the card.
- Raw captures should still read cleanly on their own before composition, especially for modal screens such as Add Item and Edit Item.
- Submission exports are derived from the composed masters:
  - 6.7-inch and 6.5-inch exports come from the 6.7-inch master set
  - 5.5-inch exports come from the 6.1-inch master set to reduce vertical crop loss
- Submission export may crop the poster canvas to match the target aspect ratio, but it may not distort the composition or stretch the embedded device screenshot.

## English Story Order
1. Dashboard: `Track food before it expires`
2. Add Item: `Add items in seconds`
3. Edit Item: `Update dates and status fast`
4. Archive: `Keep consumed items organized`
5. Settings: `Local reminders. No cloud. No tracking.`

## German Story Order
1. Dashboard: `Lebensmittel vor dem Ablauf sehen`
2. Add Item: `Einträge in Sekunden anlegen`
3. Edit Item: `Daten und Status schnell anpassen`
4. Archive: `Verbrauchtes ordentlich ablegen`
5. Settings: `Lokale Erinnerungen. Kein Tracking.`
