#!/bin/sh
# Build KFZAPP into dist/ from a clean checkout.
# Used locally and as the Cloudflare (Workers Builds / Pages) build command.
set -eu
cd "$(dirname "$0")"

# Elm 0.19.2 (see elm.json) is not on npm, so fetch the official binary
# if it is not already installed.
if ! command -v elm >/dev/null 2>&1; then
  echo "elm not found, downloading Elm 0.19.2..."
  curl -fL -o /tmp/elm.gz https://github.com/elm/compiler/releases/download/0.19.2/elm-0.19.2-linux-x64.gz
  gunzip -f /tmp/elm.gz
  chmod +x /tmp/elm
  ELM=/tmp/elm
else
  ELM=elm
fi

rm -rf dist
mkdir -p dist/icons
"$ELM" make src/Main.elm --optimize --output=dist/elm.js
cp src/main.css dist/main.css
cp assets/index.html dist/index.html
cp assets/manifest.webmanifest dist/manifest.webmanifest
cp assets/sw.js dist/sw.js
cp assets/icons/* dist/icons/

# SEO: robots.txt always; sitemap.xml + canonical/og:url only when the public
# URL is known. Set SITE_URL (e.g. https://kfzapp.pages.dev) as a Cloudflare
# build environment variable; CF_PAGES_URL is picked up automatically on Pages.
SITE_URL="${SITE_URL:-${CF_PAGES_URL:-}}"
SITE_URL="${SITE_URL%/}"
{
  echo "User-agent: *"
  echo "Allow: /"
  if [ -n "$SITE_URL" ]; then
    echo "Sitemap: $SITE_URL/sitemap.xml"
  fi
} > dist/robots.txt
if [ -n "$SITE_URL" ]; then
  cat > dist/sitemap.xml <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>$SITE_URL/</loc>
    <changefreq>monthly</changefreq>
  </url>
</urlset>
EOF
  sed -i "s|<!--SEO-CANONICAL-->|<link rel=\"canonical\" href=\"$SITE_URL/\">\n    <meta property=\"og:url\" content=\"$SITE_URL/\">|" dist/index.html
else
  sed -i "/<!--SEO-CANONICAL-->/d" dist/index.html
fi
echo "Built dist/ ($(du -sh dist | cut -f1))"
