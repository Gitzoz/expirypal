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
  docs/release/icon-source

cat <<'EOF'
Release asset directories are ready.

Next:
1. Run scripts/generate-store-screenshots.sh to build the app and capture the release set automatically.
2. Run scripts/generate-store-compositions.sh to build the App Store marketing compositions.
3. Review the generated PNGs in release-assets/screenshots/ and release-assets/store-composed/.
4. Use scripts/capture-screenshot.sh only for one-off recaptures.
EOF
