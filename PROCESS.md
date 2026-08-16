# Build process & status

Gitignored, not published. This is the checklist for actually building the site — concepts and reasoning live in `NOTES.md`; this file tracks what's done, what's next, and how work proceeds.

## Working process

Each chapter page is written directly — explore the raw shape in a scratch chunk first, refine the fit interactively, then write the page's final prose and code once the analysis is settled. Unlike the earlier single-Rmd version of this project, there's no separate promotion step into a named `R/*.R` function per method: fit code lives inline in its chapter page. `R/` now holds only what's genuinely shared across pages — `utils.R` (palette, theme) and `plot_nonlinear.R` (shared plot builders, still scaffolded until a second method needs one).

**Blind analysis in chapter narrative.** The synthetic generator's ground-truth parameters (`R/generate_synthetic_data.R` — e.g. `break_tn <- 6.0`) exist to check a fitted result against, not to inform it. Each chapter's written analysis should read the way it would against a real, unlabeled dataset: breakpoints eyeballed from a plot and then estimated, not read off the generator and asserted. Ground truth is fair game privately, in the console, to confirm a fit landed close to where it should — it just doesn't leak into the published page or bias where a knot/starting guess gets placed.

Practical loop, per chapter page:

1. Explore raw in a scratch console session or throwaway chunk first (plot it, try the fit call directly) before committing to the page's final structure.
2. Once the call shape is stable, write it into the chapter page as its final form — the code the reader sees is the code that was actually used, not a re-derivation.
3. Render the single page (`quarto render chapters/<file>.qmd`) to iterate, rather than the whole project, while a page is in progress.
4. Drop any throwaway exploration once the page's real content exists.

## Method progression checklist

Order is fixed (see `NOTES.md` for why each method sits where it does).

- [x] 1. Piecewise / segmented linear regression — Total Nitrogen — `chapters/piecewise-regression.qmd`
- [ ] 2. Changepoint detection — Specific Conductance — `chapters/changepoint-detection.qmd` (scaffold only)
- [ ] 3. k-NN regression — Total Phosphorus — `chapters/knn-regression.qmd` (scaffold only)
- [ ] 4. LOESS — Total Phosphorus, same data as k-NN — `chapters/loess-smoothing.qmd` (scaffold only)
- [ ] 5. GAM (`mgcv`) — Dissolved Oxygen — `chapters/gam.qmd` (scaffold only)
- [ ] 6. Linear vs. nonlinear comparison — Total Chloride, Total Zinc — `chapters/linear-vs-nonlinear-comparison.qmd` (scaffold only)

## Key packages

- `segmented` (piecewise/segmented regression) — in use.
- `lmtest` (Breusch-Pagan) — in use, alongside base R's `shapiro.test()`.
- `mgcv` (GAM) — to be used once that chapter is built.
- `changepoint` (changepoint detection) — `strucchange` is the alternative, to confirm once that chapter is built.
- `caret` (k-NN regression, `knnreg()`) — to be used once that chapter is built.
- `dplyr`, `ggplot2`, `readr`, `knitr` — shared across all pages.
- renv initialized; package set snapshotted after each chapter that adds a new dependency.

## Status

Site structure is in place (`_quarto.yml`, `index.qmd`, six chapter pages under `chapters/`). Piecewise regression (Total Nitrogen) is fully written: fit, results, diagnostics, interpretation. The remaining five chapters are scaffolds — title and a short description of the case study and shape, no analysis yet.
