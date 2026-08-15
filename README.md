# Nonlinear Trend Analysis

Placeholder vignette. `vignette-temporal-trends` covers linear/monotonic trend detection (ANOVA slope, Mann-Kendall) and explicitly scopes out genuinely nonlinear or non-monotonic trends. This vignette picks up that gap: analytes whose trajectory over time isn't well described by a straight line or a monotonic rank test (e.g. a rise-then-plateau, a seasonal cycle, or a peak-and-decline).

## What this covers

- TBD — likely candidates: GAM (`mgcv`) trend fitting, LOESS smoothing, changepoint detection, or a comparison of linear vs. nonlinear model fit

## Structure

```
analysis/
  non_linear_trends.Rmd        # vignette — the reader-facing document
R/
  generate_synthetic_data.R    # builds data/synthetic dataset
data/
  synthetic/
outputs/
  figures/
```

## Running the vignette

Open `vignette-non-linear-trends.Rproj` in RStudio, then knit `analysis/non_linear_trends.Rmd`.

The rendered vignette is also published automatically on push to `main` via `.github/workflows/render-deploy.yml`, and viewable at https://iangault.github.io/vignette-non-linear-trends/.

## Key packages

TBD
