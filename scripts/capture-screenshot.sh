#!/bin/bash
set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <output-path>"
  exit 1
fi

OUTPUT_PATH="$1"
DEVICE_ID="${DEVICE_ID:-}"

mkdir -p "$(dirname "$OUTPUT_PATH")"

if [ -z "$DEVICE_ID" ]; then
  DEVICE_ID="$(xcrun simctl list devices booted available | awk -F '[()]' '/Booted/ {print $2; exit}')"
fi

if [ -z "$DEVICE_ID" ]; then
  echo "No booted simulator found."
  echo "Boot a simulator, navigate to the screen you want, then rerun."
  exit 1
fi

xcrun simctl io "$DEVICE_ID" screenshot "$OUTPUT_PATH"
echo "Saved screenshot to $OUTPUT_PATH"
