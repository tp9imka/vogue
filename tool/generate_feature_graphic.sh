#!/usr/bin/env bash
# Renders tool/feature_graphic.html to assets/brand/feature_graphic.png
# at exactly 1024×500 (Google Play feature graphic spec).
#
# Uses headless Chrome so real Google Fonts (Bodoni Moda, Inter) render —
# Flutter's headless test renderer falls back to placeholder glyphs.
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
HTML="$PWD/tool/feature_graphic.html"
OUT="$PWD/assets/brand/feature_graphic.png"

"$CHROME" \
  --headless=new \
  --disable-gpu \
  --hide-scrollbars \
  --no-sandbox \
  --window-size=1024,500 \
  --default-background-color=00000000 \
  --virtual-time-budget=5000 \
  --screenshot="$OUT" \
  "file://$HTML" >/dev/null 2>&1

if [ ! -f "$OUT" ]; then
  echo "Chrome did not produce $OUT" >&2
  exit 1
fi

W=$(sips -g pixelWidth "$OUT" 2>/dev/null | awk '/pixelWidth/{print $2}')
H=$(sips -g pixelHeight "$OUT" 2>/dev/null | awk '/pixelHeight/{print $2}')
echo "feature_graphic.png: ${W}×${H}"
if [ "$W" != "1024" ] || [ "$H" != "500" ]; then
  echo "Wrong dimensions; expected 1024×500" >&2
  exit 1
fi
echo "OK"
