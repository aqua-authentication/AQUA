AQUA — QUICK GUIDE

SITE PAGES
- index.qmd: AQUA framework landing page
- definitional-models.qmd: AQUA-A / AQUA-T / AQUA-S definitional quality models
- prediction-models.qmd: AQUÆDICT prediction-model page

INCLUDED CONTENT
- authenticator-*.qmd: AQUA-A structure and definitional content
- auth-technique-*.qmd: AQUA-T structure and definitional content
- auth-sol-*.qmd: AQUA-S structure and definitional content
- aquaedict-a-tree.qmd: AQUÆDICT-A prediction-model introduction and inherited AQUA-A structure
- aquaedict-a-predictions.qmd: AQUÆDICT-A prediction metrics and worked examples
- trees/*.dot: Graphviz sources for the three AQUA quality-model trees
- figures/: figures and generated SVG trees used by the QMD pages
- styles.css: shared website styling and fixed AQUA model colors
- zoom-lightbox.html: quality-tree zoom, hover, and AQUA/AQUÆDICT layer interactions

RENDER TREES
Run render-trees.cmd after changing a tree in trees/.

RENDER WEBSITE
Run render-html.cmd on Windows or render-html-linux.sh on Linux/macOS.
The scripts render all three pages, apply standalone HTML processing, and create local GitHub Pages copies in docs/.
Generated files in _output/ and docs/ are build artifacts and are not source files.

IMPORTANT
- Keep the fixed model colors defined at the top of styles.css:
  Authenticator: #9a5718
  Authentication Technique: #287a58
  Authentication Solution: #1769aa
- Authenticator Employment is a framework concept, not a quality model; use the neutral framework color.
- AQUA-A / AQUA-T / AQUA-S are definitional quality models.
- AQUÆDICT-A / AQUÆDICT-T / AQUÆDICT-S are prediction models only.
