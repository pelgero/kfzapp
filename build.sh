#!/bin/sh
# Build KFZAPP into dist/ from a clean checkout.
# Used locally and as the Cloudflare Pages build command.
set -eu
cd "$(dirname "$0")"

# Elm 0.19.2 (see elm.json) is not on npm, so fetch the official binary
# if it is not already installed.
if ! command -v elm >/dev/null 2>&1; then
  echo "elm not found, downloading Elm 0.19.2..."
  curl -L -o /tmp/elm.gz https://github.com/elm/compiler/releases/download/0.19.2/binary-for-linux-64-bit.gz
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
echo "Built dist/ ($(du -sh dist | cut -f1))"
