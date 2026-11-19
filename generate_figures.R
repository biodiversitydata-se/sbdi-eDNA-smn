# Runs the tutorial code of both tracks on local copies of the data, saves the
# figures in figures/ and prints the numbers quoted in the tutorial text.
#
# Run from the root of the repo, after build_tutorial_scripts.R. The environment variables
# SMN_INSECTS and SMN_PLANKTON should point at folders with the two zip files of
# each track, and nothing else.

figure_dir <- "figures"
dir.create(figure_dir, showWarnings = FALSE, recursive = TRUE)
fig <- function(name) file.path(figure_dir, name)

# Runs a track's script in a new environment, with local paths and without help
# lookups or on-screen plots, and returns the environment.
run_track <- function(track, data_path) {
  env <- new.env(parent = globalenv())
  env$data_path <- data_path
  env$store_path <- file.path(tempdir(), paste0("store_", track))
  code <- readLines(sprintf("tutorial_%s.R", track), encoding = "UTF-8")
  code <- code[!grepl("^\\?", code) & !grepl("^(data_path|store_path) *<-", code)]
  code <- code[!grepl("^plot_[a-z_]+\\(.*\\)$", code)]
  pdf(NULL)
  on.exit(invisible(dev.off()))
  eval(parse(text = code, encoding = "UTF-8"), envir = env)
  env
}

save_png <- function(name, plot_fun, ...) {
  png(fig(name), ...)
  plot_fun()
  invisible(dev.off())
}

# Insects ----------------------------------------------------------------------

ins <- run_track("insects", Sys.getenv("SMN_INSECTS"))
save_png("insects_3_map.png", ins$plot_monthly_maps, width = 1100, height = 950)
save_png("insects_5_pcoa.png", ins$plot_pcoa, width = 1200, height = 1000, res = 110)
save_png("insects_6_shannon.png", ins$plot_shannon, width = 800, height = 650, res = 110)
ggplot2::ggsave(fig("insects_4_barplots.png"), ins$plot_barplots(rank = "order", top_x = 8),
                width = 9, height = 8, dpi = 130)

cat("\n=== Insects\nPaired samples per method:\n")
print(table(ins$samples$method))
cat("Lysate samples for alpha:", nrow(ins$alpha_samples), "\n")
print(table(ins$alpha_samples$habitat))
cat("Axis shares (%):", round(100 * ins$axis_share, 1), "\n")
set.seed(1)
permanova <- vegan::adonis2(ins$bray ~ habitat + yday + decimalLatitude + method,
                            data = ins$samples, by = "margin", permutations = 99)
print(permanova)
print(round(sapply(split(ins$alpha_samples$shannon, ins$alpha_samples$habitat), summary), 2))

# Marine plankton --------------------------------------------------------------

plk <- run_track("plankton", Sys.getenv("SMN_PLANKTON"))
save_png("plankton_3_map_2019_2020.png", function() plk$plot_maps("2019-2020"), width = 1100, height = 950)
save_png("plankton_3_map_2013.png", function() plk$plot_maps("2013"), width = 1100, height = 950)
save_png("plankton_5_pcoa.png", plk$plot_pcoa, width = 1200, height = 700, res = 110)
save_png("plankton_6_shannon.png", plk$plot_shannon, width = 800, height = 650, res = 110)
ggplot2::ggsave(fig("plankton_4_barplots.png"), plk$plot_barplots(rank = "class", top_x = 8),
                width = 9, height = 10, dpi = 130)

cat("\n=== Marine plankton\nSamples per dataset:\n")
print(table(plk$events$dataset))
cat("Samples without salinity:", sum(is.na(plk$events$salinity)), "\n")
cat("Axis shares (%):", round(100 * plk$axis_share, 1), "\n")
cat("Correlation of PC1/PC2 with salinity:",
    round(cor(plk$pcoa$points, plk$events$salinity, use = "complete.obs"), 2), "\n")
cat("Correlation of Shannon with salinity:",
    round(cor(plk$events$shannon, plk$events$salinity, use = "complete.obs"), 2), "\n")
composition <- plk$get_composition("class")
overall <- sort(tapply(composition$norm, composition$clade, sum) / length(unique(composition$eventID)),
                decreasing = TRUE)
print(round(head(overall, 8), 3))

# Numbers quoted on the results page -------------------------------------------

# Written to _variables.yml, which results.qmd reads with {{< var ... >}}, so the
# text follows the figures whenever the site is rebuilt.
paired <- unique(as.vector(table(ins$samples$method)))
if (length(paired) != 1) stop("The extraction methods have different numbers of paired samples")
r2 <- setNames(100 * permanova$R2, rownames(permanova))
plk_n <- table(plk$events$dataset)
pct <- function(x, digits = 1) formatC(x, format = "f", digits = digits)

variables <- c(
  "insects:",
  sprintf("  paired_per_method: \"%s\"", format(paired, big.mark = ",")),
  sprintf("  lysate_samples: \"%s\"", format(nrow(ins$alpha_samples), big.mark = ",")),
  sprintf("  r2_habitat: \"%s\"", pct(r2[["habitat"]])),
  sprintf("  r2_date: \"%s\"", pct(r2[["yday"]])),
  sprintf("  r2_latitude: \"%s\"", pct(r2[["decimalLatitude"]])),
  sprintf("  r2_method: \"%s\"", pct(r2[["method"]])),
  sprintf("  r2_residual: \"%s\"", pct(r2[["Residual"]], 0)),
  "plankton:",
  sprintf("  samples_2013: \"%s\"", format(plk_n[["2013"]], big.mark = ",")),
  sprintf("  samples_2019_2020: \"%s\"", format(plk_n[["2019-2020"]], big.mark = ",")),
  sprintf("  pc1_share: \"%s\"", pct(100 * plk$axis_share[1], 0)),
  sprintf("  pc1_salinity_cor: \"%s\"",
          pct(abs(cor(plk$pcoa$points[, 1], plk$events$salinity, use = "complete.obs")), 2)),
  sprintf("  alpha_dropped: \"%s\"", nrow(plk$events) - length(plk$shannon))
)
writeLines(variables, "_variables.yml")
