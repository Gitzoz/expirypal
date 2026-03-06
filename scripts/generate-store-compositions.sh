#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
RAW_DIR="$ROOT_DIR/release-assets/screenshots"
OUTPUT_DIR="$ROOT_DIR/release-assets/store-composed"
CONFIG_PATH="$ROOT_DIR/docs/release/store-screenshot-copy.json"
ICON_PATH="$ROOT_DIR/docs/site/assets/app-icon.png"

mkdir -p /tmp/swift-module-cache
rm -rf "$OUTPUT_DIR"

CLANG_MODULE_CACHE_PATH=/tmp/swift-module-cache \
SWIFT_MODULE_CACHE_PATH=/tmp/swift-module-cache \
/usr/bin/swift \
  "$ROOT_DIR/scripts/compose-store-screenshots.swift" \
  "$CONFIG_PATH" \
  "$RAW_DIR" \
  "$OUTPUT_DIR" \
  "$ICON_PATH"

echo "Generated composed store screenshots in $OUTPUT_DIR"
