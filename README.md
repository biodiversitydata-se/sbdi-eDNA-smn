# SMN hands-on workshop 2026

Tutorial for the [Swedish Metabarcoding Network (SMN) meeting](https://metabarcoding.se/meeting-2026/) in Uppsala, 8–9 December 2026.

The workshop demonstrates how eDNA/metabarcoding data from the [Swedish Biodiversity Data Infrastructure (SBDI)](https://biodiversitydata.se/) can be downloaded from the ASV portal and analysed in R, using insects or marine plankton as alternative tracks.

**Website:** https://biodiversitydata-se.github.io/sbdi-eDNA-smn/

## Working with the tutorial

The website is built with [Quarto](https://quarto.org/). The tutorial pages are written in `.qmd` files in the repository root.

- `index.qmd` and `tutorial.qmd`: homepage and tutorial overview
- `tutorial-01-setup.qmd` and `tutorial-02-prep.qmd`: common steps
- `insects-*.qmd` and `plankton-*.qmd`: the two tutorial tracks
- `_quarto.yml` and `styles.css`: website configuration and styling

**Edit the `.qmd` files, not the generated output.**

The files `tutorial_insects.R` and `tutorial_plankton.R` contain the R code from each track, in the same order as on the website. They are generated automatically for running or testing an entire track on the workshop machine. Do not edit them manually.

The figures in `figures/` are also generated automatically by running the tutorial code on real data.

## Building the site

### Requirements

- R and the packages listed in step 1 of the tutorial
- [Quarto](https://quarto.org/) (included in RStudio)
- Two ZIP files per track, downloaded from the ASV portal and stored in separate folders for insects and plankton

The data are not included in this repository.

### After changing R code

If you change R code in the tutorial pages, including comments in code blocks, rebuild the scripts, figures and website.

Open a terminal in the repository folder and run:

```bash
export SMN_INSECTS=/path/to/insect-zip-files
export SMN_PLANKTON=/path/to/plankton-zip-files
./build_site.sh
```

The build script:

1. Generates `tutorial_insects.R` and `tutorial_plankton.R` from the tutorial code.
2. Runs both tracks and saves the figures in `figures/`.
3. Builds the website in `docs/` using Quarto.

The data paths only need to be set once per terminal session. Subsequent builds only need `./build_site.sh`.

### After changing text only

If you only change text outside R code blocks, run:

```bash
quarto render
```

This updates the website without rerunning the analyses. If `quarto` is not found, use the copy included in RStudio, for example `/Applications/RStudio.app/Contents/Resources/app/quarto/bin/quarto` on macOS.

### Publishing

Check the updated pages, then commit and push the changes to `main`. GitHub Pages serves the website from `docs/`.

## License

This material is licensed under the Creative Commons Attribution 4.0 International License (CC BY 4.0).
