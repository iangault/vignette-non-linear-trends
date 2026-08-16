# vignette-non-linear-trends

A Quarto website — "Modelling Beyond a Straight Line" — walking through nonlinear and non-monotonic trend detection for water-quality data, written for an environmental-consulting audience. One page per method under `chapters/`, plus a welcome page (`index.qmd`) covering the shared framing (OLS assumptions, inference vs. prediction, the parametric-to-nonparametric spectrum).

## Method progression (six methods, in this order)

1. Piecewise / segmented linear regression (Total Nitrogen — slope break) — `chapters/piecewise-regression.qmd`, complete
2. Changepoint detection (Specific Conductance — level break, unknown location) — scaffold only
3. k-NN regression (Total Phosphorus — rise-then-plateau) — scaffold only
4. LOESS smoothing (Total Phosphorus — same data as k-NN, direct side-by-side) — scaffold only
5. GAM, `mgcv` (Dissolved Oxygen — seasonal cycle + trend) — scaffold only
6. Linear vs. nonlinear model comparison (Total Chloride and Total Zinc — controls) — scaffold only

The site's premise is **inference on the observed record, not forecasting** — k-NN/LOESS/GAM all extrapolate poorly outside the fitted range, so projecting beyond the observed period is out of scope.

## Writing style

Every page reads as a finished analytical document, not a working session: methodology and interpretation are real content (why a breakpoint was estimated rather than assumed, why a log transform was chosen), written in report voice — no "let's try", no "TODO", no narration of the authoring process. Code stays visible in rendered output. Internal course citations don't appear on pages; if a statistical claim needs grounding, check it against the source before asserting it, but cite the method/package, not the course.

## Working style

1. Explore the raw shape and try the fit interactively (console or a throwaway chunk) before committing to a page's structure.
2. Write the chapter page directly — fit code lives inline in the `.qmd`, there's no separate per-method `R/*.R` file to promote into. `R/` holds only what's shared across pages (`utils.R`, `plot_nonlinear.R`).
3. Render the single page being worked on (`quarto render chapters/<file>.qmd`) to iterate, not the whole project.
4. A chapter isn't done until its numbers are read back and interpreted in prose, not just printed.

## Where to look for more detail

- **`NOTES.md`** (gitignored, not published) — the original working draft this site's content is adapted from: OLS/GLM/link-function framing, the piecewise-regression three-stage build, k-NN, LOESS, the case studies, and why each method sits where it does in the progression. Never edited or deleted as part of building a page — content gets read from it and rewritten into the relevant `.qmd`, the file itself stays as the private original.
- **`PROCESS.md`** (gitignored, not published) — the working checklist: method-by-method build status and key packages. Read this for *where things currently stand*.
- **DSCI 562 (Regression II) course notes** — `/Users/iangault/git/MDS/562_regression-2/DSCI_562_regr-2_students/website/notes/lecture{1-8}*.qmd`. Lecture 1 (GLM/link functions) and Lecture 6 (piecewise regression, k-NN, LOESS) are directly relevant for grounding statistical claims about those methods — used for verification, never cited on the public pages. GAM, splines, and changepoint detection are **not** covered by this course; ground those in package documentation (`mgcv`, `changepoint`, `segmented`) instead.
