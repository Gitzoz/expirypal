# Release Checklist

## Product
- [ ] v1 scope matches `docs/spec/ExpiryPalSpec.md`
- [ ] No forbidden non-goal features are included
- [ ] English and German localization parity is maintained

## Build and Test
- [ ] `./scripts/test.sh` passes
- [ ] `./scripts/check-pages.sh` passes when site content changes
- [ ] Business-logic coverage remains at or above the repository target

## Privacy
- [ ] `PRIVACY.md` matches implementation
- [ ] `PrivacyInfo.xcprivacy` is present in the app bundle and matches implementation
- [ ] Data remains local-only
- [ ] Notifications remain local-only
- [ ] No tracking, analytics, ads, or third-party SDKs are present

## Store Preparation
- [ ] App Store copy is finalized
- [ ] App icon set is finalized
- [ ] `./scripts/check-release-screenshots.sh` passes
- [ ] Submission screenshots exist for 6.7-inch, 6.5-inch, and 5.5-inch device classes
- [ ] Privacy policy URL and support URL are ready

## Known Warning Decision
- Accepted non-blocking Xcode toolchain warning:
  - `Metadata extraction skipped. No AppIntents.framework dependency found.`
- Decision:
  - Do not add `AppIntents.framework` only to suppress tooling output.
  - Treat this as Xcode metadata-tool noise unless the app intentionally adopts App Intents in a future specification update.

## Final Release Step
- [ ] Create a release commit
- [ ] Create an annotated git tag for the release version
- [ ] Push commit and tag
