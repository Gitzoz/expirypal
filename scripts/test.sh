#!/bin/bash
set -e

echo "Running ExpiryPal tests..."

SIMULATOR_DESTINATION=$(xcrun simctl list devices available | awk -F'[()]' '/iPhone/ {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $1); print $1; exit}' || true)

if [ -z "$SIMULATOR_DESTINATION" ]; then
  echo "No available iPhone simulator found."
  echo "Install an iOS Simulator runtime in Xcode > Settings > Components."
  exit 1
fi

xcodebuild \
  -project ExpiryPal.xcodeproj \
  -scheme ExpiryPal \
  -derivedDataPath /tmp/expirypal-deriveddata \
  -destination "platform=iOS Simulator,name=$SIMULATOR_DESTINATION" \
  test

echo "All tests passed."
