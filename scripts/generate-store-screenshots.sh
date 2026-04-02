#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_PATH="$ROOT_DIR/ExpiryCue.xcodeproj"
DERIVED_DATA_PATH="${DERIVED_DATA_PATH:-/tmp/expirycue-screenshot-deriveddata}"
APP_PATH="$DERIVED_DATA_PATH/Build/Products/Debug-iphonesimulator/ExpiryCue.app"
APP_BUNDLE_ID="de.gitzoz.expirycue"

SCENES=(dashboard addItem editItem archive settings)
GERMAN_SCENES=(dashboard addItem editItem archive settings)

device_name_for_class() {
  case "$1" in
    "6.1-inch") echo "iPhone 17 Pro" ;;
    "6.7-inch") echo "iPhone 17 Pro Max" ;;
    *)
      echo "Unsupported device class: $1" >&2
      exit 1
      ;;
  esac
}

output_dir_for_class() {
  case "$1" in
    "6.1-inch") echo "$ROOT_DIR/release-assets/screenshots/6.1-inch" ;;
    "6.7-inch") echo "$ROOT_DIR/release-assets/screenshots/6.7-inch" ;;
    *)
      echo "Unsupported device class: $1" >&2
      exit 1
      ;;
  esac
}

find_device_id() {
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

ensure_simulator() {
  local device_id="$1"

  xcrun simctl boot "$device_id" >/dev/null 2>&1 || true
  xcrun simctl bootstatus "$device_id" -b
  xcrun simctl ui "$device_id" appearance light >/dev/null 2>&1 || true
  xcrun simctl status_bar "$device_id" override \
    --time "9:41" \
    --dataNetwork wifi \
    --wifiBars 3 \
    --cellularMode active \
    --batteryState charged \
    --batteryLevel 100 >/dev/null 2>&1 || true
}

build_app() {
  local build_device_id
  build_device_id="$(find_device_id "iPhone 17 Pro")"

  xcodebuild \
    -project "$PROJECT_PATH" \
    -scheme ExpiryCue \
    -derivedDataPath "$DERIVED_DATA_PATH" \
    -destination "id=$build_device_id" \
    build >/dev/null

  if [ ! -d "$APP_PATH" ]; then
    echo "Unable to find built app at $APP_PATH" >&2
    exit 1
  fi
}

install_app() {
  local device_id="$1"

  xcrun simctl uninstall "$device_id" "$APP_BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl install "$device_id" "$APP_PATH"
}

capture_scene() {
  local device_id="$1"
  local language="$2"
  local locale="$3"
  local scene="$4"
  local output_path="$5"

  mkdir -p "$(dirname "$output_path")"

  xcrun simctl terminate "$device_id" "$APP_BUNDLE_ID" >/dev/null 2>&1 || true
  xcrun simctl launch "$device_id" "$APP_BUNDLE_ID" \
    SCREENSHOT_MODE \
    "SCREENSHOT_SCENE=$scene" \
    -AppleLanguages "($language)" \
    -AppleLocale "$locale" \
    >/dev/null

  sleep 4
  xcrun simctl io "$device_id" screenshot "$output_path" >/dev/null
  xcrun simctl terminate "$device_id" "$APP_BUNDLE_ID" >/dev/null 2>&1 || true
}

main() {
  "$ROOT_DIR/scripts/prepare-release-assets.sh" >/dev/null
  build_app

  for device_class in "6.1-inch" "6.7-inch"; do
    device_name="$(device_name_for_class "$device_class")"
    device_id="$(find_device_id "$device_name")"
    output_dir="$(output_dir_for_class "$device_class")"

    if [ -z "$device_id" ]; then
      echo "Unable to find simulator device: $device_name" >&2
      exit 1
    fi

    ensure_simulator "$device_id"
    install_app "$device_id"

    for scene in "${SCENES[@]}"; do
      capture_scene \
        "$device_id" \
        "en" \
        "en_US" \
        "$scene" \
        "$output_dir/en/${scene}.png"
    done

    for scene in "${GERMAN_SCENES[@]}"; do
      capture_scene \
        "$device_id" \
        "de" \
        "de_DE" \
        "$scene" \
        "$output_dir/de/${scene}.png"
    done
  done

  echo "Generated screenshots in $ROOT_DIR/release-assets/screenshots"
}

main "$@"
