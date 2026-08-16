# Modelling Beyond a Straight Line

A companion analysis on linear and monotonic trend detection (slope estimation, Mann-Kendall) covers the cases where a straight line or a monotonic rank test is the right tool. This site picks up where that leaves off: analytes whose trajectory over time isn't well described by a straight line — a slope break, a step change, a rise-then-plateau, or a seasonal cycle.

The question throughout is inference on the observed record — did this analyte change, and how — rather than forecasting. k-nearest-neighbors, LOESS, and GAM in particular extrapolate poorly past the fitted range, so projecting beyond the observed period is out of scope.

## What this covers

- **Piecewise / segmented linear regression** — one slope becomes two, joined continuously at an estimated breakpoint
- **Changepoint detection** — locates a shift in mean/level at an unknown point, rather than assuming where a break falls
- **k-nearest-neighbors regression** — the simplest local, prediction-oriented method: predicts each point as the average of its nearest neighbors, no fitted curve or coefficients
- **LOESS smoothing** — a smooth nonparametric curve, generalizing k-NN's local average into a local weighted regression
- **Generalized additive models (`mgcv`)** — a smooth curve with inferential machinery (confidence bands, significance of the smooth term)
- **Linear vs. nonlinear model comparison** (AIC / deviance) — checks whether the added flexibility was actually justified

## Case studies

Six analytes, each chosen to exercise a different method (Total Phosphorus drives two — k-NN and LOESS, for a direct side-by-side on the same data):

1. **Total Nitrogen** — flat, then a real break in slope partway through the record
2. **Specific Conductance** — a real break in level (step shift) at an unknown point, same slope before and after
3. **Total Phosphorus** — a smooth rise-then-plateau, no natural single breakpoint (k-NN, LOESS)
4. **Dissolved Oxygen** — a seasonal cycle layered on a slow multi-year trend
5. **Total Chloride** — a genuine straight-line trend across the whole record (control case)
6. **Total Zinc** — flat, no trend, pure noise (control case — guards against false positives)

## Structure

```
_quarto.yml
index.qmd                                  # welcome page
chapters/
  piecewise-regression.qmd                 # Total Nitrogen — complete
  changepoint-detection.qmd                # scaffold
  knn-regression.qmd                       # scaffold
  loess-smoothing.qmd                      # scaffold
  gam.qmd                                  # scaffold
  linear-vs-nonlinear-comparison.qmd       # scaffold
R/
  utils.R                                  # shared palette/theme constants
  plot_nonlinear.R                         # shared figure builders
  generate_synthetic_data.R                # builds data/synthetic/non_linear_wq.csv
data/
  synthetic/
outputs/
  figures/
```

## Rendering the site

```
quarto render
```

or, while working on a single page:

```
quarto render chapters/piecewise-regression.qmd
```

`quarto preview` serves the site locally with live reload. The synthetic data file (`data/synthetic/non_linear_wq.csv`) is generated automatically on first render if not already present. There is currently no automated deploy — rendering is local only.

## Key packages

`segmented`, `lmtest` (in use); `mgcv`, `changepoint`, `caret` (planned, for the chapters not yet written); `dplyr`, `ggplot2`, `readr`, `knitr` (shared across pages).
