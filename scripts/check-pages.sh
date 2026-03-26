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
  "$SITE_DIR/robots.txt"
  "$SITE_DIR/sitemap.xml"
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

if rg -n \
  -e 'gtag\(' \
  -e 'googletagmanager' \
  -e 'plausible\.' \
  -e 'segment\.com' \
  -e 'mixpanel' \
  -e 'hotjar' \
  "$SITE_DIR"; then
  echo "Disallowed analytics reference found in docs/site"
  exit 1
fi

if rg -n "<script" "$SITE_DIR" | rg -v 'type="application/ld\+json"' >/dev/null; then
  echo "Disallowed executable script reference found in docs/site"
  exit 1
fi

if rg -n 'src=["'\'']https?://|url\(https?://|<img[^>]+src=["'\'']https?://' "$SITE_DIR"; then
  echo "Disallowed remote asset reference found in docs/site"
  exit 1
fi

for pattern in 'rel="canonical"' 'property="og:title"' 'name="twitter:card"'; do
  if ! rg -q "$pattern" "$SITE_DIR"/index.html "$SITE_DIR"/docs.html "$SITE_DIR"/privacy.html "$SITE_DIR"/roadmap.html; then
    echo "Missing expected SEO/social metadata pattern: $pattern"
    exit 1
  fi
done

echo "GitHub Pages site checks passed."
