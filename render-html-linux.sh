#!/usr/bin/env bash
set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

SOURCE_HTML="$SCRIPT_DIR/_output/authentication-quality-models.html"
FINAL_HTML="$SCRIPT_DIR/_output/a-quality-model-for-authentication-solutions.html"
PUBLISHED_HTML="$SCRIPT_DIR/docs/index.html"

if ! command -v quarto >/dev/null 2>&1; then
  echo
  echo "Rendering failed. Quarto is not installed or not available in PATH."
  exit 1
fi

if ! command -v node >/dev/null 2>&1; then
  echo
  echo "Standalone HTML processing failed. Node.js is not installed or not available in PATH."
  exit 1
fi

quarto render index.qmd --to html
if [ $? -ne 0 ]; then
  echo
  echo "Rendering failed. Check that Quarto is installed."
  exit 1
fi

node "$SCRIPT_DIR/make-standalone.js" "$SOURCE_HTML"
if [ $? -ne 0 ]; then
  echo
  echo "Standalone HTML processing failed."
  exit 1
fi

mv -f "$SOURCE_HTML" "$FINAL_HTML"
if [ $? -ne 0 ]; then
  echo
  echo "Renaming the rendered HTML failed."
  exit 1
fi

mkdir -p "$SCRIPT_DIR/docs"
cp -f "$FINAL_HTML" "$PUBLISHED_HTML"
if [ $? -ne 0 ]; then
  echo
  echo "Copying the HTML to docs/index.html failed."
  exit 1
fi

echo
echo "HTML successfully created:"
echo "$FINAL_HTML"
echo
echo "GitHub Pages copy updated:"
echo "$PUBLISHED_HTML"

if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$FINAL_HTML" >/dev/null 2>&1 &
elif command -v open >/dev/null 2>&1; then
  open "$FINAL_HTML" >/dev/null 2>&1 &
fi
