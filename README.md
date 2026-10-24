# Modelling Beyond a Straight Line

Making sense of a trend in environmental chemistry data means picking the statistical approach that matches how the series actually behaves, not defaulting to one method regardless of shape. A [companion analysis](https://github.com/iangault/vignette-temporal-trends) covers linear and monotonic trend detection — slope estimation, Mann-Kendall — for analytes where a straight line or a monotonic rank test is the right tool. This site picks up where that leaves off, covering analytes whose trajectory over time isn't well described by a straight line: a slope break, a step change, a rise-then-plateau, or a seasonal cycle.

The question throughout is inference on the observed record — did this analyte change, and by how much — rather than forecasting. Techniques such as k-nearest-neighbors, LOESS, GAM, and GAMM in particular extrapolate poorly past the fitted range, so projecting beyond the observed period is out of scope, and will be done in another vignette. 

## What this vignette covers

- **The regression framework** — the five components any regression model specifies (estimand, random component, link, systematic component, estimation), with ordinary least squares (OLS) as one instance of that structure, and why "linear" means linear in the parameters rather than straight in x
- **Transformations** — three distinct tools (transforming the response, feature-engineering the regressor, changing the link function) and how to diagnose which one a given series actually needs
- **Piecewise / segmented linear regression** — one slope becomes two, joined continuously at an estimated breakpoint
- **Changepoint detection** — locates a shift in mean/level at an unknown point, rather than assuming where a break falls
- **k-nearest-neighbors regression** — the simplest local, prediction-oriented method: predicts each point as the average of its nearest neighbors, no fitted curve or coefficients
- **LOESS smoothing** — a smooth nonparametric curve, generalizing k-NN's local average into a local weighted regression
- **Generalized additive models (`mgcv`)** — a smooth curve with inferential machinery (confidence bands, significance of the smooth term)
- **Generalized additive mixed models (`mgcv::gamm()`)** — the same additive-smooth structure, with an explicit correlation structure for cases where residuals aren't independent
- **Linear vs. nonlinear model comparison** (AIC / deviance) — checks whether the added flexibility was actually justified

## Case studies

Seven analytes, each chosen to exercise a different method (Total Phosphorus drives two — k-NN and LOESS, for a direct side-by-side on the same data):

1. **Total Nitrogen** — flat, then a real break in slope partway through the record
2. **Specific Conductance** — a real break in level (step shift) at an unknown point, same slope before and after
3. **Total Phosphorus** — a smooth rise-then-plateau, no natural single breakpoint (k-NN, LOESS)
4. **Total Copper** — step-like, non-monotonic change with no periodic or polynomial pattern
5. **Dissolved Oxygen** — a seasonal cycle layered on a slow multi-year trend, with autocorrelated residuals
6. **Total Chloride** — a genuine straight-line trend across the whole record (control case)
7. **Total Zinc** — flat, no trend, pure noise (control case — guards against false positives)

## Structure

```
_quarto.yml
index.qmd                                  # welcome page
chapters/
  regression-framework.qmd                 # complete
  transformations.qmd                      # complete
  piecewise-regression.qmd                 # Total Nitrogen — complete
  changepoint-detection.qmd                # Specific Conductance — complete
  knn-regression.qmd                       # Total Phosphorus — complete
  loess-smoothing.qmd                      # Total Phosphorus — complete
  parametric-commitment.qmd                # Total Phosphorus — complete
  gam.qmd                                  # Total Copper — complete
  gamm.qmd                                 # Dissolved Oxygen — complete
  linear-vs-nonlinear-comparison.qmd       # Total Chloride, Total Zinc — complete
R/
  utils.R                                  # shared palette/theme constants
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

`quarto preview` serves the site locally with live reload. The synthetic data file (`data/synthetic/non_linear_wq.csv`) is generated automatically on first render if not already present. `.github/workflows/publish.yml` renders and deploys the site to GitHub Pages on push.

## Key packages

`segmented` (piecewise regression), `strucchange` (changepoint detection), `mgcv` (GAM, GAMM), `nlme` (GAMM's AR(1) correlation structure, via `mgcv::gamm()`), `lmtest` (Breusch-Pagan) alongside base R's `shapiro.test()`; `caret` (k-NN); `dplyr`, `ggplot2`, `readr`, `knitr` (shared across pages).

## AI assistance

I used Claude Code to help with drafting and code review. I reviewed and edited everything it produced, and any errors are my own. Corrections and suggestions are welcome as GitHub issues.
