#!/bin/bash
set -euo pipefail

echo "Running ExpiryCue tests..."

find_latest_device_id() {
  local device_name="$1"

  xcrun simctl list devices available --json | jq -r --arg name "$device_name" '
    [
      .devices
      | to_entries[]
      | select(.key | startswith("com.apple.CoreSimulator.SimRuntime.iOS-"))
      | .key as $runtime
      | .value[]
      | select(.isAvailable == true and .name == $name)
      | {
          udid: .udid,
          runtimeParts: ($runtime | sub("^com.apple.CoreSimulator.SimRuntime.iOS-"; "") | split("-") | map(tonumber))
        }
    ]
    | sort_by(.runtimeParts)
    | last
    | .udid // empty
  '
}

SIMULATOR_DEVICE_NAME="${SIMULATOR_DEVICE_NAME:-iPhone 17 Pro}"
SIMULATOR_DEVICE_ID="${SIMULATOR_DEVICE_ID:-$(find_latest_device_id "$SIMULATOR_DEVICE_NAME")}"

if [ -z "$SIMULATOR_DEVICE_ID" ]; then
  echo "No available simulator found for $SIMULATOR_DEVICE_NAME."
  echo "Install an iOS Simulator runtime in Xcode > Settings > Components."
  exit 1
fi

xcrun simctl boot "$SIMULATOR_DEVICE_ID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$SIMULATOR_DEVICE_ID" -b >/dev/null

xcodebuild \
  -project ExpiryCue.xcodeproj \
  -scheme ExpiryCue \
  -derivedDataPath /tmp/expirycue-deriveddata \
  -destination "id=$SIMULATOR_DEVICE_ID" \
  -parallel-testing-enabled NO \
  test

echo "All tests passed."
