# Generates data/synthetic/non_linear_wq.csv for the nonlinear trends vignette.
#
# Six analytes, each engineered to exercise a different branch of the
# vignette's method progression (piecewise linear -> changepoint ->
# LOESS -> GAM -> linear-vs-nonlinear comparison):
#
#   Total Nitrogen    — one real break in SLOPE partway through the record
#     (flat, then rising). Drives the piecewise/segmented linear regression
#     section — the break is known here so you can check a fitted
#     breakpoint against ground truth.
#
#   Specific Conductance — one real break in LEVEL (a step/mean shift, not a
#     slope change) at an unlabeled point in the record, standing in for a
#     discrete event (e.g. an operational change). Drives the changepoint
#     detection section — the algorithm has to find *where* the shift is
#     without being told.
#
#   Total Phosphorus  — rises smoothly then saturates (logistic-shaped).
#     No natural single breakpoint or straight-line segment describes it.
#     Drives the LOESS section.
#
#   Dissolved Oxygen   — strong within-year seasonal cycle layered on a
#     gradual multi-year trend. Drives the GAM section (smooth term +
#     inference on whether the smooth/trend is significant).
#
#   Total Chloride     — a real, genuinely straight-line trend across the
#     whole record. Control case for the linear-vs-nonlinear comparison:
#     the nonlinear methods should NOT out-perform a plain linear fit here.
#
#   Total Zinc         — flat mean, no trend of any kind, just noise.
#     Control case for the linear-vs-nonlinear comparison: a flexible model
#     (GAM/LOESS) can be tempted to fit noise as if it were a trend, and
#     this analyte is the check against that.
#
# Sampling design: monthly grab samples, single composite site, 2013-2024
# (12 years x 12 months = 144 potential samples per analyte). Single site
# rather than temporal-trends' multi-area design — this vignette's question
# is about the SHAPE of change over time, not area comparison.

suppressPackageStartupMessages({
  library(dplyr)
})

set.seed(42)

years <- 2013:2024
months <- 1:12

sampling_grid <- expand.grid(year = years, month = months) %>%
  mutate(date = as.Date(sprintf("%d-%02d-15", year, month))) %>%
  arrange(date)

t0 <- min(sampling_grid$date)
sampling_grid <- sampling_grid %>%
  mutate(year_frac = as.numeric(date - t0) / 365.25)

noise_sd <- 0.15

make_analyte <- function(analyte_name, log_mean_fn, noise_sd = 0.15) {
  sampling_grid %>%
    mutate(
      analyte = analyte_name,
      log_mean = log_mean_fn(year_frac),
      result = exp(log_mean + rnorm(n(), sd = noise_sd))
    ) %>%
    select(date, year, month, year_frac, analyte, result)
}

# Total Nitrogen: flat at log(1.0) until year_frac == break_tn, then rises at
# ~0.15/year. A genuine slope break, not a level jump.
break_tn <- 6.0
tn <- make_analyte("Total Nitrogen", function(t) {
  log(1.0) + 0.15 * pmax(0, t - break_tn)
})

# Specific Conductance: flat at log(300) until break_cond, then a step up to
# log(420) — a level shift with the SAME slope (zero) on both sides, so a
# piecewise-linear-slope model wouldn't flag it but a changepoint-in-mean
# test will.
break_cond <- 7.2
cond <- make_analyte("Specific Conductance", function(t) {
  log(300) + log(420 / 300) * as.numeric(t >= break_cond)
}, noise_sd = 0.06)

# Total Phosphorus: logistic saturation — rises from log(0.02) to log(0.08)
# centered around year_frac 5, then plateaus. No single breakpoint or
# straight segment fits this well.
tp <- make_analyte("Total Phosphorus", function(t) {
  lo <- log(0.02); hi <- log(0.08)
  lo + (hi - lo) / (1 + exp(-(t - 5) / 1.2))
})

# Dissolved Oxygen: seasonal cycle (annual period) plus a slow decline.
do_ <- make_analyte("Dissolved Oxygen", function(t) {
  log(9) - 0.01 * t + 0.25 * sin(2 * pi * t)
}, noise_sd = 0.05)

# Total Chloride: a real, plain straight-line trend across the whole record.
chloride <- make_analyte("Total Chloride", function(t) {
  log(15) + 0.03 * t
})

# Total Zinc: flat, no trend — pure noise control.
zinc <- make_analyte("Total Zinc", function(t) {
  log(5) + 0 * t
})

non_linear <- bind_rows(tn, cond, tp, do_, chloride, zinc)

dir.create("data/synthetic", showWarnings = FALSE, recursive = TRUE)
readr::write_csv(non_linear, "data/synthetic/non_linear_wq.csv")
