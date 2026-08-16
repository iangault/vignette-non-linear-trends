# Nonlinear Trend Analysis

`vignette-temporal-trends` covers linear/monotonic trend detection (ANOVA slope, Mann-Kendall) and explicitly scopes out genuinely nonlinear or non-monotonic trends. This vignette picks up that gap: analytes whose trajectory over time isn't well described by a straight line or a monotonic rank test — a slope break, a step change, a rise-then-plateau, or a seasonal cycle.

The question throughout is inference on the observed record (did this analyte change, and how) rather than forecasting — GAM and LOESS in particular extrapolate poorly past the fitted range, so projecting beyond the observed period is out of scope, the same way nonlinear trends were out of scope for `vignette-temporal-trends`.

## What this covers

Built up as a progression from the linear model `vignette-temporal-trends` already established:

- **Piecewise / segmented linear regression** — one slope becomes two, the direct extension of a single-slope trend model
- **Changepoint detection** — locates a shift in mean/level at an unknown point, rather than assuming where a break falls
- **LOESS smoothing** — a smooth nonparametric curve for trajectories a straight segment can't describe
- **GAM (`mgcv`) trend fitting** — a smooth curve with inferential machinery (confidence bands, significance of the smooth term)
- **Linear vs. nonlinear model comparison** (AIC / deviance explained) — checks whether the added flexibility was actually justified, and guards against a flexible model fitting noise as if it were a trend

## Case studies

Six analytes, each chosen to exercise a different method:

1. **Total Nitrogen** — flat, then a real break in slope partway through the record
2. **Specific Conductance** — a real break in level (step shift) at an unknown point, same slope before and after
3. **Total Phosphorus** — a smooth rise-then-plateau (logistic saturation), no natural single breakpoint
4. **Dissolved Oxygen** — a seasonal cycle layered on a slow multi-year decline
5. **Total Chloride** — a genuine straight-line trend across the whole record (control case)
6. **Total Zinc** — flat, no trend, pure noise (control case — guards against false positives)

## Structure

```
analysis/
  non_linear_trends.Rmd        # vignette — the reader-facing document
R/
  piecewise_model.R            # segmented/piecewise linear regression
  changepoint_model.R          # changepoint (mean-shift) detection
  smoothing_models.R           # LOESS + GAM fits
  model_comparison.R           # linear-vs-nonlinear AIC/deviance comparison
  plot_nonlinear.R             # shared figure builders
  utils.R                      # shared palette/theme constants
  generate_synthetic_data.R    # builds data/synthetic/non_linear_wq.csv
data/
  synthetic/
outputs/
  figures/
```

## Running the vignette

Open `vignette-non-linear-trends.Rproj` in RStudio, then knit `analysis/non_linear_trends.Rmd`. The setup chunk sets the working directory to the project root so all relative paths resolve correctly.

The rendered vignette is also published automatically on push to `main` via `.github/workflows/render-deploy.yml`, and viewable at https://iangault.github.io/vignette-non-linear-trends/.

The synthetic data file (`data/synthetic/non_linear_wq.csv`) is generated automatically on first run if not already present.

## Key packages

`mgcv`, `segmented`, `changepoint`, `dplyr`, `ggplot2`, `ggtext`, `readr`, `knitr` — package choices for the piecewise/changepoint sections are still being confirmed as the vignette is built out.
