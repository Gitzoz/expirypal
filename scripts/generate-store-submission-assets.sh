#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSED_DIR="$ROOT_DIR/release-assets/store-composed"
OUTPUT_DIR="$ROOT_DIR/release-assets/store-submission"

mkdir -p /tmp/swift-module-cache
rm -rf "$OUTPUT_DIR"

CLANG_MODULE_CACHE_PATH=/tmp/swift-module-cache \
SWIFT_MODULE_CACHE_PATH=/tmp/swift-module-cache \
/usr/bin/swift \
  "$ROOT_DIR/scripts/export-store-submission-assets.swift" \
  "$COMPOSED_DIR" \
  "$OUTPUT_DIR"

echo "Generated App Store submission screenshots in $OUTPUT_DIR"
