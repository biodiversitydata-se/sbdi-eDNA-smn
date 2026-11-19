#!/usr/bin/env bash
# Rebuilds everything after a change to the tutorial: the tutorial_<track>.R
# scripts, the figures and the site in docs/.
#
# Usage:
#   SMN_INSECTS=/path/to/insects SMN_PLANKTON=/path/to/plankton ./build_site.sh
#
# Each folder should hold the two zip files of its track, and nothing else.
# QUARTO can point at the quarto program if it is not on the PATH.
set -euo pipefail

: "${SMN_INSECTS:?Set SMN_INSECTS to the folder with the insect zip files}"
: "${SMN_PLANKTON:?Set SMN_PLANKTON to the folder with the plankton zip files}"

QUARTO="${QUARTO:-quarto}"
RSTUDIO_QUARTO="/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto"
if ! command -v "$QUARTO" > /dev/null && [ -x "$RSTUDIO_QUARTO" ]; then
    QUARTO="$RSTUDIO_QUARTO"
fi
if ! command -v "$QUARTO" > /dev/null; then
    echo "Quarto not found. Install it or set QUARTO to its path." >&2
    exit 1
fi

cd "$(dirname "$0")"

echo "==> Writing tutorial_insects.R and tutorial_plankton.R"
Rscript build_tutorial_scripts.R

echo "==> Running both tracks and saving the figures"
Rscript generate_figures.R

echo "==> Building the site in docs/"
"$QUARTO" render

echo "==> Done. Commit and push to publish the site."
