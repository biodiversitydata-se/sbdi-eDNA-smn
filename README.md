# SMN hands-on workshop 2026

Tutorial for the [Swedish Metabarcoding Network (SMN) meeting](https://metabarcoding.se/meeting-2026/) in Uppsala, 8–9 December 2026.

The workshop demonstrates how eDNA/metabarcoding data from the [Swedish Biodiversity Data Infrastructure (SBDI)](https://biodiversitydata.se/) can be downloaded from the [ASV portal](https://asv-portal.biodiversitydata.se/index) and analysed in R, using marine plankton or insects as alternative tracks.

**Website:** https://biodiversitydata-se.github.io/sbdi-eDNA-smn/

## Working with the tutorial

The website is built with [Quarto](https://quarto.org/). The tutorial pages are written in `.qmd` files in the repository root.

- `index.qmd` and `tutorial.qmd`: homepage and tutorial overview
- `tutorial-01-setup.qmd`: common first step
- `plankton-*.qmd` and `insects-*.qmd`: the two tutorial tracks (A and B), from step 2
- `_format-tables.qmd`: wide and long example tables, included in both step 2 pages
- `_quarto.yml` and `styles.css`: website configuration and styling

**Edit the `.qmd` files, not the generated output.**

The files `tutorial_insects.R` and `tutorial_plankton.R` contain the R code from each track, in the same order as on the website. They are generated automatically for running or testing an entire track on the workshop machine. Do not edit them manually.

The scripts are built from the code in steps 2–6. Step 1 is not included: the package and data path lines at the top of each script are defined in `build_tutorial_scripts.R`, so update them there if you change the packages or paths in step 1.

The figures in `figures/` are also generated automatically by running the tutorial code on real data. So are the numbers quoted on the results page: they are written to `_variables.yml` and inserted in `results.qmd` with `{{< var ... >}}`.

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
2. Runs both tracks, saves the figures in `figures/` and the numbers for the results page in `_variables.yml`.
3. Builds the website in `docs/` using Quarto.

The data paths only need to be set once per terminal session. Subsequent builds only need `./build_site.sh`.

### After changing text only

If you only change text outside R code blocks, run:

```bash
quarto render
```

This updates the website without rerunning the analyses.

Note for macOS: Quarto may be included with RStudio but not available in your terminal's PATH. If `quarto render` is not found, use the Quarto executable bundled with RStudio or add it to your PATH.

### Publishing

Check the updated pages, then commit and push the changes to `main`. GitHub Pages serves the website from `docs/`.

## License

This material is licensed under the Creative Commons Attribution 4.0 International License (CC BY 4.0).
