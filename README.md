# sbdi-eDNA-smn
Tutorial for the hands-on workshop at the [first in-person Swedish Metabarcoding Network (SMN) meeting](https://metabarcoding.se/meeting-2026/), Uppsala, 8–9 December 2026. It shows how eDNA/metabarcoding data published through the [Swedish Biodiversity Data Infrastructure (SBDI)](https://biodiversitydata.se/) can be downloaded from the ASV portal and explored in R, with insects or marine plankton as alternative tracks.

Website: <https://biodiversitydata-se.github.io/sbdi-eDNA-smn/>

## Instructors
- Dr. Tobias Andermann — SBDI & Uppsala University
- Prof. Anders Andersson — SBDI & KTH SciLifeLab
- Dr. Daniel Lundin — SBDI & Linnaeus University
- Dr. Maria Prager — SBDI & University of Gothenburg

## References
Track A, insects:

Miraldo, A., Sundh, J., Iwaszkiewicz-Eggebrecht, E., et al. (2025). [Data of the Insect Biome Atlas: A metabarcoding survey of the terrestrial arthropods of Sweden and Madagascar](https://doi.org/10.1038/s41597-025-05151-0). Scientific Data, 12, 1–18.

Track B, marine plankton:

Hu, Y.O.O., Karlson, B., Charvet, S., Andersson, A.F. (2016). [Diversity of pico- to mesoplankton along the 2000 km salinity gradient of the Baltic Sea](https://doi.org/10.3389/fmicb.2016.00679). Frontiers in Microbiology, 7:679.

Latz, M.A.C., Andersson, A., Brugel, S., et al. (2024). [A comprehensive dataset on spatiotemporal variation of microbial plankton communities in the Baltic Sea](https://doi.org/10.1038/s41597-023-02825-5). Scientific Data, 11:18.

## Building the site
You need R with the packages from step 1 of the tutorial, [Quarto](https://quarto.org/) (included in RStudio), and the four zip files from the ASV portal, in one folder per track.

After a change to the R code in the tutorial, run the command below. `SMN_INSECTS` and `SMN_PLANKTON` tell the script where the data are: replace the paths with the folders on your computer that hold the zip files of each track.
```bash
SMN_INSECTS=/path/to/folder-with-insect-zip-files SMN_PLANKTON=/path/to/folder-with-plankton-zip-files ./build_site.sh
```
It runs three steps:
1. `build_tutorial_scripts.R` writes `tutorial_insects.R` and `tutorial_plankton.R` from the R code in the tutorial pages.
2. `generate_figures.R` runs both scripts on the data and saves the figures in `figures/`.
3. `quarto render` builds the site in `docs/`.

After a change to the text only, `quarto render` is enough. Commit and push `docs/` to publish the site with GitHub Pages.

## License

This material is licensed under the Creative Commons
Attribution 4.0 International License (CC BY 4.0).
