# Design: restructure into a Quarto website

Date: 2026-08-16
Status: approved, ready for implementation plan

## Context

The vignette currently lives as a single R Markdown document
(`analysis/non_linear_trends.Rmd`) rendered with `rmarkdown::render()`,
following the same one-file-per-vignette convention as its siblings in
`wsp-portfolio-raw`. Only the first of six planned methods (piecewise /
segmented linear regression, Total Nitrogen) has been built.

The premise has changed. This project is no longer scoped as "one vignette
among several, matching sibling format" — it's now its own book-style site,
**"Modelling Beyond a Straight Line," for an environmental-consulting
audience**, modeled structurally on the DSCI 562 (Regression II) Quarto
course site (`/Users/iangault/git/MDS/562_regression-2/DSCI_562_regr-2_students/website`):
a docked sidebar, one page per topic, a welcome/landing page.

Checked against the reference site's actual `_quarto.yml`: it is a Quarto
**website** (`project: type: website`), not a Quarto **book**
(`type: book`) — sidebar navigation with independent pages, not
chapter/prev-next book semantics. This design follows that.

A second, independent change rides along with the restructure: the
existing piecewise content was written *as* a teaching transcript (pair-
programming instructions, "TODO: replace with your guess", "this becomes
a function later"). The site's pages need to read as a finished analytical
document instead — the reasoning stays, the meta-commentary about how it
was authored does not.

## Goals

- Stand up a Quarto website project (sidebar nav, `index.qmd` welcome page,
  one page per method) that renders locally via `quarto render` /
  `quarto preview`.
- Migrate the already-built piecewise section into its own page, rewritten
  in a professional analytical voice (methodology and interpretation kept,
  authoring-process narration cut).
- Redistribute `NOTES.md`'s general framing content onto the welcome page,
  and its piecewise-specific content onto the piecewise page — without
  modifying or deleting `NOTES.md` itself, which remains the user's
  private original.
- Scaffold the remaining five method pages as bare placeholders (title +
  1-2 sentences), matching their current TBD state — no new modeling code
  for methods not yet built.
- Simplify `R/` to shared utilities only, since per-method fit code now
  lives inline in its page rather than being promoted to a named function.
- Update `CLAUDE.md`, `PROCESS.md`, and `README.md` to describe the new
  structure and premise.

## Non-goals

- No GitHub Pages / CI deployment. Local render only for now.
- No new modeling code for changepoint, k-NN, LOESS, GAM, or the linear-
  vs-nonlinear comparison — those pages stay scaffolds.
- No change to the underlying statistical work already done for piecewise
  regression (the fit, the breakpoint estimate, the diagnostics) — this is
  a presentation/structure migration, not a re-analysis.
- No change to `data/`, `renv.lock`'s package set (beyond what Quarto
  itself needs, which is none — it's already installed and separate from
  the R package library), or the synthetic data generator.

## Directory structure

```
vignette-non-linear-trends/
  _quarto.yml
  index.qmd                              # welcome page
  chapters/
    piecewise-regression.qmd             # migrated + rewritten
    changepoint-detection.qmd            # scaffold only
    knn-regression.qmd                   # scaffold only
    loess-smoothing.qmd                  # scaffold only
    gam.qmd                              # scaffold only
    linear-vs-nonlinear-comparison.qmd   # scaffold only
  R/
    utils.R                              # palette, nlt_theme, analyte_colors
    plot_nonlinear.R                     # shared plot builders (still scaffolded)
    generate_synthetic_data.R            # unchanged
  data/, outputs/, renv/, renv.lock      # unchanged
  docs/superpowers/specs/                # this file, and future specs/plans
  NOTES.md                               # unchanged, private original
  PROCESS.md                             # rewritten for new structure
  README.md                              # rewritten for new premise
  CLAUDE.md                              # rewritten for new premise
```

`analysis/non_linear_trends.Rmd` and its rendered
`analysis/non_linear_trends.html` are deleted once `chapters/piecewise-
regression.qmd` covers the same ground — no dangling half-migrated
document left behind.

`piecewise_model.R`, `changepoint_model.R`, `knn_model.R`,
`smoothing_models.R`, and `model_comparison.R` are deleted. They were
scaffolds for the promote-to-named-function step, which no longer applies
now that fit code lives inline in each page.

Chapter filenames are descriptive, no numeric prefixes (matches the
DSCI 562 reference) — page order comes entirely from `_quarto.yml`'s
sidebar `contents:` list, so reordering later never requires a rename.

## `_quarto.yml`

- `project: type: website`
- `project: execute-dir: project` — every `.qmd` executes with the project
  root as its working directory, regardless of which subdirectory the file
  lives in. This replaces the current Rmd's manual
  `knitr::opts_knit$set(root.dir = normalizePath(".."))` hack, and is why
  `source("R/utils.R")` / `read_csv("data/...")` calls can stay identical
  across every page.
- `website: sidebar:` docked, single unnamed content list (no
  Lectures/Labs/Appendices grouping — this site doesn't have that variety
  of page, so one flat list is enough): `index.qmd`, then the six chapter
  files in method-progression order.
- `format: html:` — code visible by default (no folding), matching the
  reference site and because showing the actual R work is part of the
  portfolio's point. `toc: true` for in-page navigation.
- No GitHub Pages / `output-dir` / Actions workflow (non-goal).

## Page content

### `index.qmd` (welcome page)

Extracted and adapted from `NOTES.md`'s general-framing sections — OLS
assumptions, inference vs. prediction, "a model is an abstraction of
reality," the parametric → nonparametric spectrum, the GLM/link-function
bridge, splines as the bridge from hinge functions to GAM. Plus:

- The faceted raw-data overview plot (ports the existing `raw-overview`
  chunk logic).
- A short roadmap: one to two sentences per method/case-study pairing —
  not the method-specific deep-dive, that lives on each method's own page.
- Title: "Modelling Beyond a Straight Line." Subtitle/framing pitched at
  an environmental-consulting reader.

### `chapters/piecewise-regression.qmd`

Migrated from today's Piecewise section, restructured and rewritten:

- **Opening framing** — adapted from `NOTES.md`'s piecewise section: the
  three-stage progression (piecewise constant → non-continuous piecewise
  linear → continuous piecewise linear via hinge terms), why Total
  Nitrogen lands at stage 3, the hinge-function-is-feature-engineering-
  not-a-link-function distinction, the log-transform rationale. Course
  citations ("Sourced against DSCI 562...") are cut — that's an internal
  sourcing note, not client-facing content; it stays in `NOTES.md` only.
- **The shape in the record** — raw vs. log-scale series (was
  `tn-scratch-plot`).
- **Estimating the breakpoint** — the segmented fit. Methodology is kept
  but reworded as analytical narration rather than instruction: e.g. "the
  breakpoint was initially estimated by inspection of the plotted series,
  then refined via `segmented()`'s iterative local search" rather than
  "replace this placeholder with your eyeballed guess." (was
  `tn-scratch-fit`)
- **Results** — `summary()`/`confint()`/`slope()`, each its own chunk as
  established. The `NA` p-value and no-p-value-on-`slope()` explanations
  are kept as methodology footnotes (why the estimated breakpoint breaks
  standard reference-distribution assumptions), reworded out of
  instructional voice. Fitted plot with the slope-2 CI annotation. (was
  `tn-scratch-summary` / `-confint` / `-slope` / `-fitted-plot`)
- **Model diagnostics** — Breusch-Pagan, Shapiro-Wilk, each its own chunk,
  with the interpretation kept. (was `tn-scratch-bptest` / `-shapiro`)
- **Interpretation** — closing paragraph, adapted from the existing
  "Reading the output" content, in report voice.

All chunk labels drop the `tn-scratch-` prefix (e.g. `tn-raw-series`,
`tn-segmented-fit`) since nothing here is scratch anymore — it's the
finished page.

### The other five chapter files

Bare scaffolds: title, 1-2 sentences naming the case-study analyte and the
shape it demonstrates (content already exists in `NOTES.md`'s "case
studies" list and `PROCESS.md`'s checklist — ported over, not invented).
No modeling code, no fit attempts.

## `R/` after the change

Two files remain:

- `utils.R` — palette, `analyte_colors`, `nlt_theme`. Unchanged.
- `plot_nonlinear.R` — shared plot builders. Stays scaffolded (header
  comment only) exactly as it is now; still TBD until a second method
  needs a shared plot builder worth extracting.

`generate_synthetic_data.R` is untouched — it's not a per-method fit file,
it's the data source, out of scope for this restructure.

## `NOTES.md`, `PROCESS.md`, `CLAUDE.md`, `README.md`

- **`NOTES.md`** — untouched. Content gets read and adapted into pages,
  never edited or trimmed in place. Remains the user's private working
  original (still gitignored).
- **`PROCESS.md`** — rewritten: checklist becomes per-chapter-file instead
  of per-`.Rmd`-section; the "blind analysis in the Rmd narrative"
  convention gets reworded for the new per-page structure (same rule,
  different noun — "the page's narrative" instead of "the Rmd").
- **`CLAUDE.md`** — rewritten: drops the "dual role: portfolio piece +
  learning vehicle, pair-programming mode" framing in favor of the new
  premise (a standalone book-style site for an environmental-consulting
  audience); working-style section updated to describe writing directly
  into a page rather than promoting scratch code into `R/*.R`.
- **`README.md`** — rewritten to describe the site structure and how to
  render it (`quarto render` / `quarto preview` instead of
  `rmarkdown::render()`).

## Migration sequence

1. Scaffold the Quarto project (`_quarto.yml`, empty `index.qmd` and six
   `chapters/*.qmd` files).
2. Write `index.qmd`'s content.
3. Rewrite and port the piecewise content into
   `chapters/piecewise-regression.qmd`; verify the fit results/diagnostics
   values carried over match what was already computed (breakpoint ≈ 5.9,
   segment-2 slope ≈ 0.140, BP p ≈ 0.328, Shapiro-Wilk p ≈ 0.575) — no
   re-deriving numbers, just re-presenting them.
4. Scaffold the remaining five chapter pages.
5. Delete `analysis/non_linear_trends.Rmd`, its rendered `.html`, and the
   five now-unused `R/*_model.R` files.
6. `quarto render` the whole project; confirm every page renders with no
   errors and the sidebar navigates correctly.
7. Rewrite `PROCESS.md`, `CLAUDE.md`, `README.md`.

## Testing / verification

- `quarto render` succeeds for the whole project (analogous to the
  `rmarkdown::render()` check already done for the Rmd).
- Spot-check the rendered piecewise page: sidebar link works, all code
  chunks produce output, the fitted-plot annotation and figure theme
  (`nlt_theme`) still render correctly under Quarto's chunk execution
  (was verified under `rmarkdown::render()`; Quarto uses knitr under the
  hood for `.qmd` + R, so this is expected to carry over, but gets
  re-verified rather than assumed).
- Confirm no broken relative paths from chapter pages (this is what
  `execute-dir: project` is specifically for) — check `R/utils.R` sourcing
  and `data/synthetic/non_linear_wq.csv` reading from a page inside
  `chapters/`.
