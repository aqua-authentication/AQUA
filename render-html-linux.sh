#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

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

if ! quarto render --to html; then
  echo
  echo "Rendering failed."
  exit 1
fi

OUTPUT_DIR="$SCRIPT_DIR/_output"
DOCS_DIR="$SCRIPT_DIR/docs"

HTML_FILES=(
  "authentication-quality-models.html"
  "definitional-models.html"
  "prediction-models.html"
)

for file in "${HTML_FILES[@]}"; do
  if [ ! -f "$OUTPUT_DIR/$file" ]; then
    echo
    echo "Expected rendered file not found: _output/$file"
    exit 1
  fi

  if ! node "$SCRIPT_DIR/make-standalone.js" "$OUTPUT_DIR/$file"; then
    echo
    echo "Standalone HTML processing failed for $file."
    exit 1
  fi
done

mkdir -p "$DOCS_DIR"

# Keep the canonical landing-page filename as well as index.html so the
# persistent cross-page navigation works in both _output and docs.
cp -f "$OUTPUT_DIR/authentication-quality-models.html" "$DOCS_DIR/authentication-quality-models.html"
cp -f "$OUTPUT_DIR/authentication-quality-models.html" "$DOCS_DIR/index.html"
cp -f "$OUTPUT_DIR/definitional-models.html" "$DOCS_DIR/definitional-models.html"
cp -f "$OUTPUT_DIR/prediction-models.html" "$DOCS_DIR/prediction-models.html"

echo
echo "HTML successfully created:"
echo "$OUTPUT_DIR/authentication-quality-models.html"
echo "$OUTPUT_DIR/definitional-models.html"
echo "$OUTPUT_DIR/prediction-models.html"
echo
echo "GitHub Pages copies updated in:"
echo "$DOCS_DIR"

if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "$OUTPUT_DIR/authentication-quality-models.html" >/dev/null 2>&1 &
elif command -v open >/dev/null 2>&1; then
  open "$OUTPUT_DIR/authentication-quality-models.html" >/dev/null 2>&1 &
fi
