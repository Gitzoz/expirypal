#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-/tmp/expirypal-screenshot-deriveddata}"
SCREENSHOT_DIR="$ROOT_DIR/release-assets/screenshots"
COMPOSED_DIR="$ROOT_DIR/release-assets/store-composed"

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
DESTINATION="${DESTINATION:-id=$SIMULATOR_DEVICE_ID}"

if [ -z "$SIMULATOR_DEVICE_ID" ]; then
  echo "No available simulator found for $SIMULATOR_DEVICE_NAME." >&2
  exit 1
fi

required_files=(
  "$SCREENSHOT_DIR/6.1-inch/en/dashboard.png"
  "$SCREENSHOT_DIR/6.1-inch/en/addItem.png"
  "$SCREENSHOT_DIR/6.1-inch/en/editItem.png"
  "$SCREENSHOT_DIR/6.1-inch/en/archive.png"
  "$SCREENSHOT_DIR/6.1-inch/en/settings.png"
  "$SCREENSHOT_DIR/6.1-inch/de/dashboard.png"
  "$SCREENSHOT_DIR/6.1-inch/de/addItem.png"
  "$SCREENSHOT_DIR/6.1-inch/de/editItem.png"
  "$SCREENSHOT_DIR/6.1-inch/de/archive.png"
  "$SCREENSHOT_DIR/6.1-inch/de/settings.png"
  "$SCREENSHOT_DIR/6.7-inch/en/dashboard.png"
  "$SCREENSHOT_DIR/6.7-inch/en/addItem.png"
  "$SCREENSHOT_DIR/6.7-inch/en/editItem.png"
  "$SCREENSHOT_DIR/6.7-inch/en/archive.png"
  "$SCREENSHOT_DIR/6.7-inch/en/settings.png"
  "$SCREENSHOT_DIR/6.7-inch/de/dashboard.png"
  "$SCREENSHOT_DIR/6.7-inch/de/addItem.png"
  "$SCREENSHOT_DIR/6.7-inch/de/editItem.png"
  "$SCREENSHOT_DIR/6.7-inch/de/archive.png"
  "$SCREENSHOT_DIR/6.7-inch/de/settings.png"
)

required_composed_files=(
  "$COMPOSED_DIR/6.1-inch/en/01-dashboard.png"
  "$COMPOSED_DIR/6.1-inch/en/02-addItem.png"
  "$COMPOSED_DIR/6.1-inch/en/03-editItem.png"
  "$COMPOSED_DIR/6.1-inch/en/04-archive.png"
  "$COMPOSED_DIR/6.1-inch/en/05-settings.png"
  "$COMPOSED_DIR/6.1-inch/de/01-dashboard.png"
  "$COMPOSED_DIR/6.1-inch/de/02-addItem.png"
  "$COMPOSED_DIR/6.1-inch/de/03-editItem.png"
  "$COMPOSED_DIR/6.1-inch/de/04-archive.png"
  "$COMPOSED_DIR/6.1-inch/de/05-settings.png"
  "$COMPOSED_DIR/6.7-inch/en/01-dashboard.png"
  "$COMPOSED_DIR/6.7-inch/en/02-addItem.png"
  "$COMPOSED_DIR/6.7-inch/en/03-editItem.png"
  "$COMPOSED_DIR/6.7-inch/en/04-archive.png"
  "$COMPOSED_DIR/6.7-inch/en/05-settings.png"
  "$COMPOSED_DIR/6.7-inch/de/01-dashboard.png"
  "$COMPOSED_DIR/6.7-inch/de/02-addItem.png"
  "$COMPOSED_DIR/6.7-inch/de/03-editItem.png"
  "$COMPOSED_DIR/6.7-inch/de/04-archive.png"
  "$COMPOSED_DIR/6.7-inch/de/05-settings.png"
)

echo "Running screenshot-scene quality tests..."
xcodebuild \
  -project "$ROOT_DIR/ExpiryPal.xcodeproj" \
  -scheme ExpiryPal \
  -derivedDataPath "$DERIVED_DATA_PATH" \
  -destination "$DESTINATION" \
  -only-testing:ExpiryPalUITests/GermanLocalizationUITests \
  test >/dev/null

echo "Clearing previous screenshot export..."
find "$SCREENSHOT_DIR" -type f -name "*.png" -delete 2>/dev/null || true

echo "Generating release screenshots..."
"$ROOT_DIR/scripts/generate-store-screenshots.sh" >/dev/null

echo "Generating composed store screenshots..."
"$ROOT_DIR/scripts/generate-store-compositions.sh" >/dev/null

echo "Validating screenshot files..."
for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing screenshot: $file" >&2
    exit 1
  fi

  if ! sips -g pixelWidth -g pixelHeight "$file" >/dev/null 2>&1; then
    echo "Unreadable screenshot file: $file" >&2
    exit 1
  fi
done

echo "Validating composed store assets..."
for file in "${required_composed_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing composed screenshot: $file" >&2
    exit 1
  fi

  if ! sips -g pixelWidth -g pixelHeight "$file" >/dev/null 2>&1; then
    echo "Unreadable composed screenshot file: $file" >&2
    exit 1
  fi
done

echo "Release screenshot checks passed."
