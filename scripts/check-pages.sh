#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SITE_DIR="$ROOT_DIR/docs/site"

required_files=(
  "$SITE_DIR/index.html"
  "$SITE_DIR/docs.html"
  "$SITE_DIR/privacy.html"
  "$SITE_DIR/roadmap.html"
  "$SITE_DIR/styles.css"
)

for file in "${required_files[@]}"; do
  if [ ! -f "$file" ]; then
    echo "Missing required Pages file: $file"
    exit 1
  fi
done

for href in "href=\"index.html\"" "href=\"docs.html\"" "href=\"privacy.html\"" "href=\"roadmap.html\""; do
  if ! rg -q "$href" "$SITE_DIR"/*.html; then
    echo "Missing expected internal link: $href"
    exit 1
  fi
done

if rg -n "<script|gtag\\(|googletagmanager|plausible\\.|segment\\.com|mixpanel|hotjar" "$SITE_DIR"; then
  echo "Disallowed script or analytics reference found in docs/site"
  exit 1
fi

if rg -n 'src=["'\'']https?://|url\(https?://|<img[^>]+src=["'\'']https?://' "$SITE_DIR"; then
  echo "Disallowed remote asset reference found in docs/site"
  exit 1
fi

echo "GitHub Pages site checks passed."
