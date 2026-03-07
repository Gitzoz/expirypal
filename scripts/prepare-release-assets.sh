#!/bin/bash
set -euo pipefail

mkdir -p \
  release-assets/screenshots/6.7-inch/en \
  release-assets/screenshots/6.7-inch/de \
  release-assets/screenshots/6.1-inch/en \
  release-assets/screenshots/6.1-inch/de \
  release-assets/store-composed/6.7-inch/en \
  release-assets/store-composed/6.7-inch/de \
  release-assets/store-composed/6.1-inch/en \
  release-assets/store-composed/6.1-inch/de \
  release-assets/store-submission/6.7-inch/en \
  release-assets/store-submission/6.7-inch/de \
  release-assets/store-submission/6.5-inch/en \
  release-assets/store-submission/6.5-inch/de \
  release-assets/store-submission/5.5-inch/en \
  release-assets/store-submission/5.5-inch/de \
  docs/release/icon-source

cat <<'EOF'
Release asset directories are ready.

Next:
1. Run scripts/generate-store-screenshots.sh to build the app and capture the release set automatically.
2. Run scripts/generate-store-compositions.sh to build the App Store marketing compositions.
3. Run scripts/generate-store-submission-assets.sh to export exact App Store submission sizes.
4. Review the generated PNGs in release-assets/screenshots/, release-assets/store-composed/, and release-assets/store-submission/.
4. Use scripts/capture-screenshot.sh only for one-off recaptures.
EOF
