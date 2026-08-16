# Quarto Website Restructure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the single-Rmd vignette with a Quarto website (docked sidebar, one page per method, a welcome page) rewritten for a client/environmental-consultant audience, per the approved design spec.

**Architecture:** A `project: type: website` Quarto project rendered locally (`quarto render`). `index.qmd` is the welcome page; `chapters/*.qmd` holds one page per method (only piecewise regression has real content — the rest are scaffolds). `R/utils.R` and `R/plot_nonlinear.R` remain the shared layer; the five per-method `R/*_model.R` files and the old Rmd are removed, since fit code now lives inline in its chapter page.

**Tech Stack:** Quarto CLI 1.7.33 (already installed), R + knitr (Quarto's R engine), existing renv environment (`segmented`, `lmtest`, `dplyr`, `ggplot2`, `readr`) — no new package dependencies.

**Spec:** `docs/superpowers/specs/2026-08-16-quarto-website-restructure-design.md`

## Global Constraints

- `project: type: website`, not `type: book` (spec: "Project type").
- `project: execute-dir: project` so every page's working directory is the project root, regardless of its own location under `chapters/`.
- No GitHub Pages / CI deployment — local render only. The existing `.github/workflows/render-deploy.yml` (which deploys the old Rmd) gets removed as part of this work, not updated, since it will break once the Rmd is deleted.
- Code stays visible in rendered output (no code folding).
- Page prose reads as a finished analytical report: no authoring-process narration ("scratch chunk", "TODO", "this becomes a function later", "replace the placeholder"), no internal course citations ("Sourced against DSCI 562..."). Methodology and interpretation are kept, reworded into report voice.
- `NOTES.md` is never edited or deleted — content is read from it and adapted into pages, the file itself stays untouched.
- No new modeling code for changepoint, k-NN, LOESS, GAM, or the linear-vs-nonlinear comparison — those five chapter pages are scaffolds only (title + 1-2 sentences).
- Numeric results already computed for the piecewise section carry over unchanged, not re-derived: breakpoint ≈ 5.9 (95% CI 5.18–6.61), pre-break slope ≈ -0.0015 (CI crosses zero), post-break slope ≈ 0.140 (95% CI 0.120–0.160), Breusch-Pagan p ≈ 0.328, Shapiro-Wilk p ≈ 0.575.

---

## Task 1: Scaffold the Quarto project

**Files:**
- Create: `_quarto.yml`
- Create: `index.qmd` (temporary placeholder — real content in Task 2)
- Create: `chapters/piecewise-regression.qmd` (temporary placeholder — real content in Task 3)
- Create: `chapters/changepoint-detection.qmd` (final content — scaffold only, no further task touches this file)
- Create: `chapters/knn-regression.qmd` (final content — scaffold only)
- Create: `chapters/loess-smoothing.qmd` (final content — scaffold only)
- Create: `chapters/gam.qmd` (final content — scaffold only)
- Create: `chapters/linear-vs-nonlinear-comparison.qmd` (final content — scaffold only)

**Interfaces:**
- Consumes: nothing new — `R/utils.R` (`nlt_theme`, `project_palette`, `analyte_colors`) and `data/synthetic/non_linear_wq.csv` already exist unchanged.
- Produces: the sidebar navigation structure (`_quarto.yml`'s `contents:` list) that every later task's pages must already appear in.

- [ ] **Step 1: Write `_quarto.yml`**

```yaml
project:
  type: website
  execute-dir: project

website:
  title: "Modelling Beyond a Straight Line"
  page-navigation: true
  sidebar:
    style: docked
    search: true
    contents:
      - index.qmd
      - section: "Methods"
        contents:
          - chapters/piecewise-regression.qmd
          - chapters/changepoint-detection.qmd
          - chapters/knn-regression.qmd
          - chapters/loess-smoothing.qmd
          - chapters/gam.qmd
          - chapters/linear-vs-nonlinear-comparison.qmd

format:
  html:
    theme: flatly
    toc: true
    toc-location: right
    code-fold: false
```

- [ ] **Step 2: Write the temporary `index.qmd` placeholder**

```markdown
---
title: "Modelling Beyond a Straight Line"
---

Content in progress.
```

- [ ] **Step 3: Write the temporary `chapters/piecewise-regression.qmd` placeholder**

```markdown
---
title: "Piecewise / Segmented Linear Regression"
---

Content in progress.
```

- [ ] **Step 4: Write the final `chapters/changepoint-detection.qmd`**

```markdown
---
title: "Changepoint Detection"
subtitle: "Specific Conductance — a level shift at an unknown point"
---

Specific Conductance holds at one level, then shifts to a new level partway through the record, with the same — flat — slope on both sides: a level jump rather than a slope break. Unlike the piecewise case, the shift's location isn't known in advance here, so a changepoint-detection algorithm has to find it rather than a knot being read off a plot.

*Analysis not yet written.*
```

- [ ] **Step 5: Write the final `chapters/knn-regression.qmd`**

```markdown
---
title: "k-Nearest Neighbors Regression"
subtitle: "Total Phosphorus — a rise that levels into a plateau"
---

Total Phosphorus rises smoothly and then plateaus, a shape no single breakpoint or straight segment describes well. k-nearest-neighbors regression predicts each point as the average of its *k* nearest neighbors in the data — no fitted curve, no coefficients, a purely local-average baseline compared against LOESS on the same data.

*Analysis not yet written.*
```

- [ ] **Step 6: Write the final `chapters/loess-smoothing.qmd`**

```markdown
---
title: "LOESS Smoothing"
subtitle: "Total Phosphorus — the same rise-then-plateau, a smoother local fit"
---

LOESS fits a separate weighted local regression at every point, producing a smoother curve than k-nearest-neighbors' local average, on the same Total Phosphorus data for a direct comparison. Like k-NN, it doesn't produce coefficients or a significance test — its role here is a smooth-curve baseline ahead of the GAM section.

*Analysis not yet written.*
```

- [ ] **Step 7: Write the final `chapters/gam.qmd`**

```markdown
---
title: "Generalized Additive Models"
subtitle: "Dissolved Oxygen — a seasonal cycle riding on a longer-term trend"
---

Dissolved Oxygen combines a within-year seasonal cycle with a slower multi-year trend, a shape no single knot or local average handles well. A generalized additive model fits this with a smooth basis function via `mgcv`, restoring the confidence bands and significance testing that k-nearest-neighbors and LOESS give up.

*Analysis not yet written.*
```

- [ ] **Step 8: Write the final `chapters/linear-vs-nonlinear-comparison.qmd`**

```markdown
---
title: "Linear vs. Nonlinear Comparison"
subtitle: "Total Chloride and Total Zinc — control cases"
---

Total Chloride follows a genuine, unremarkable straight-line trend; Total Zinc is pure noise with no real trend. Together they check two opposite failure modes: forcing unnecessary flexibility onto a series already well described by a straight line, and letting a flexible model manufacture a trend out of noise. This section compares linear and nonlinear fits on both analytes using AIC and deviance.

*Analysis not yet written.*
```

- [ ] **Step 9: Render the project and verify the skeleton works**

Run: `quarto render`
Expected: exits 0, produces `_site/index.html` and `_site/chapters/*.html` for all six chapter pages, no errors in the console output.

- [ ] **Step 10: Commit**

```bash
git add _quarto.yml index.qmd chapters/
git commit -m "Scaffold Quarto website project"
```

---

## Task 2: Write `index.qmd`'s real content

**Files:**
- Modify: `index.qmd` (replace the Task 1 placeholder)

**Interfaces:**
- Consumes: `R/utils.R` (`nlt_theme`), `data/synthetic/non_linear_wq.csv`, `R/generate_synthetic_data.R` (only invoked if the CSV doesn't exist yet).
- Produces: nothing later tasks depend on programmatically — this is a leaf content page.

- [ ] **Step 1: Replace `index.qmd` with its full content**

```markdown
---
title: "Modelling Beyond a Straight Line"
subtitle: "Detecting nonlinear and non-monotonic trends in water-quality monitoring data"
---

```{r}
#| label: setup
#| include: false
library(dplyr)
library(ggplot2)
source("R/utils.R")
if (!file.exists("data/synthetic/non_linear_wq.csv")) {
  source("R/generate_synthetic_data.R")
}
non_linear_wq <- readr::read_csv("data/synthetic/non_linear_wq.csv", show_col_types = FALSE)
```

## Why nonlinear methods matter here

Environmental data rarely behaves as neatly as the models used to describe it. A straight-line trend is a fine description when a concentration is genuinely rising or falling at a constant rate — but many real records don't look like that: a flat baseline that suddenly starts climbing, a level that jumps once and holds, a rise that levels off into a plateau, a seasonal cycle riding on top of a slower trend. Forcing a straight line onto any of these shapes produces a technically-fitted but practically misleading answer: it can make a plateaued analyte look like it's still climbing, or smear a one-time step change into what reads as a gradual trend.

This site works through five methods for picking up on those shapes, in order of increasing flexibility — piecewise/segmented regression, changepoint detection, k-nearest-neighbors regression, LOESS smoothing, and generalized additive models — plus a closing comparison of when the added flexibility is actually worth it against a plain linear fit.

## What ordinary least squares is actually doing

Ordinary least squares models the conditional mean of the response given the regressors, not the response itself. For a single predictor:

$$y_i = \beta_0 + \beta_1 x_i + \varepsilon_i, \qquad \varepsilon_i \sim N(0, \sigma^2) \text{ i.i.d.}$$

Equivalently, $E[Y \mid X = x] = \beta_0 + \beta_1 x$: on average, at this value of $x$, expect this value of $y$ — a claim about the average trajectory, not any individual point.

The core assumptions, roughly in order of how much trouble breaking them causes:

- **Linearity** — the true conditional mean really is a straight line in the predictors. This is the assumption every method on this site is about testing or relaxing.
- **Independence** — residuals aren't correlated with each other.
- **Homoscedasticity** — constant error variance across the range of $x$.
- **Normality of errors** — needed for exact p-values and confidence intervals at small sample sizes, not for the point estimates themselves.

## Inference vs. prediction

Two different jobs a model can do, and every case study on this site is doing the first one:

- **Inference** — the coefficients themselves are the answer: is there a real trend, how big is it, is it statistically distinguishable from noise. This requires the model form to be roughly right, since a misspecified model gives confident-looking, wrong numbers.
- **Prediction** — only $\hat y$ for new inputs matters; the model can be an uninterpretable black box as long as it's accurate out-of-sample.

"Is this analyte trending, and how" is an inference question. "What will next year's reading be" would be prediction — out of scope here, because k-nearest-neighbors, LOESS, and GAM all extrapolate poorly past the range of data they were fit on (see Scope, below).

Not every method here can do inference, and that's a structural property of the fitting procedure, not a per-project choice:

- **Inference-capable, and therefore prediction-capable too:** linear regression, piecewise/segmented regression, changepoint detection, GAM. Each produces an interpretable, testable parameter — a slope, a breakpoint location, a shift, a significance test on a smooth term — and the same fit gives a $\hat y$ for free.
- **Prediction-only, structurally:** k-nearest-neighbors and LOESS. Neither ever produces a coefficient or a p-value — there is no mechanism for one to come out of. What they supply is $\hat y$ within the observed range of $x$; LOESS is a smoother, less boundary-biased version of the same job k-nearest-neighbors does.

## A model is an abstraction, not a recovery

Every method here — linear, piecewise, LOESS, GAM — is a different simplification of an unknown true process. The question is never which model is correct, it's which simplification is adequate for the decision at hand and cheap enough to explain and defend. A straight line is a fine abstraction when the data really is monotonic; it becomes actively misleading once the shape genuinely bends.

Model choice is a tradeoff along three axes: interpretability (can the fitted model be explained to a non-statistician), fit quality (does it capture the actual shape), and data efficiency (how much data it needs to estimate reliably).

The methods on this site sit on a spectrum from parametric to nonparametric:

- **Parametric** (linear, piecewise) — a small, fixed number of parameters. Highly interpretable and cheap to estimate, but correct only if the true shape matches the assumed form.
- **Nonparametric** (k-nearest-neighbors, LOESS) — no fixed functional form; the fit adapts to local structure. Robust to getting the shape wrong a priori, but needs more data to estimate as reliably as a correctly-specified parametric model, and doesn't reduce to a handful of reportable numbers.
- **Semi-parametric** (GAM) — smooth basis functions like LOESS, but with a fitted penalty controlling how much wiggle is allowed, plus proper inferential machinery LOESS doesn't provide.

## Why this matters for a client or regulator

Getting the functional form right isn't academic — it changes what gets reported and what action follows. Forcing a straight line onto a plateau makes an analyte look like it's still climbing when it's actually leveled off. Missing a real step change — an operational event, a permit change — and reporting it as a gradual trend obscures the actual cause and the actual fix. Fitting a flexible model to pure noise manufactures a trend that isn't there and triggers unnecessary escalation. A defensible analysis uses the model whose complexity is actually supported by the data — no more, no less — and can explain in plain terms why that model was chosen over the alternatives.

## The case studies

Six analytes, each chosen to demonstrate a specific shape or to act as a control — monthly sampling, single composite site, 2013–2024.

```{r}
#| label: raw-overview
#| fig-height: 8
#| echo: false
ggplot(non_linear_wq, aes(date, result)) +
  geom_point(alpha = 0.5, size = 1) +
  facet_wrap(~analyte, scales = "free_y", ncol = 2) +
  labs(x = NULL, y = "Result") +
  nlt_theme
```

- **Total Nitrogen** — flat, then a genuine slope break. Piecewise/segmented regression: two slopes, one knot, no discontinuity.
- **Specific Conductance** — a level jump at an unknown location. Changepoint detection: the same "something shifted" question as Total Nitrogen, but without being told where.
- **Total Phosphorus** — a rise that levels into a plateau. Used twice — k-nearest-neighbors and LOESS, on the same data, for a direct side-by-side.
- **Dissolved Oxygen** — a seasonal cycle riding on a longer-term trend. GAM: a shape no single knot or local average handles well.
- **Total Chloride** — a genuine, unremarkable straight-line trend. A control: the case where the simple linear model is already the right answer.
- **Total Zinc** — pure noise, no real trend. The other control: the guard against a flexible model manufacturing a trend that isn't there.

## Scope

This is inference on the observed record — is there a real trend, where and how did it change — not forecasting. k-nearest-neighbors, LOESS, and GAM all extrapolate poorly past the range of the fitted data, so projecting beyond the observed period is out of scope throughout.
```

- [ ] **Step 2: Render and verify**

Run: `quarto render index.qmd`
Expected: exits 0, `_site/index.html` produced.

Run: `grep -c "raw-overview" _site/index.html`
Expected: at least 1 (the figure's alt/id text or the chunk-generated image reference should appear — confirms the chunk executed rather than erroring silently).

Run: `grep -o "Modelling Beyond a Straight Line" _site/index.html | head -1`
Expected: prints the title, confirming the page rendered with the right title.

- [ ] **Step 3: Commit**

```bash
git add index.qmd
git commit -m "Write welcome page content"
```

---

## Task 3: Write `chapters/piecewise-regression.qmd`'s real content

**Files:**
- Modify: `chapters/piecewise-regression.qmd` (replace the Task 1 placeholder)

**Interfaces:**
- Consumes: `R/utils.R` (`nlt_theme`), `data/synthetic/non_linear_wq.csv`, packages `segmented` and `lmtest` (already in `renv.lock`).
- Produces: nothing later tasks depend on programmatically — this is a leaf content page.

- [ ] **Step 1: Replace `chapters/piecewise-regression.qmd` with its full content**

```markdown
---
title: "Piecewise / Segmented Linear Regression"
subtitle: "Total Nitrogen — a genuine break in slope"
---

```{r}
#| label: setup
#| include: false
library(dplyr)
library(ggplot2)
library(segmented)
library(lmtest)
source("R/utils.R")
non_linear_wq <- readr::read_csv("data/synthetic/non_linear_wq.csv", show_col_types = FALSE)
tn <- non_linear_wq |> filter(analyte == "Total Nitrogen")
```

## From a single slope to a bending line

A straight-line regression assumes one slope holds across the whole record. Three progressively less restrictive models relax that assumption:

1. **Piecewise constant.** The regressor's range is split into intervals at one or more knots, and each interval gets its own flat mean — no slope at all within a segment, and a jump in the fitted value at every knot.
2. **Non-continuous piecewise linear.** Each interval gets its own intercept *and* its own slope, by interacting the regressor with the interval indicator. Segments still don't connect at the knots — there's a visible jump in the fitted line even though nothing in the data actually jumped.
3. **Continuous piecewise linear.** Segments are forced to join at each knot by using a hinge function, $(x - c)_+ = \max(0, x - c)$, in place of separate per-interval terms:
   $$y_i = \beta_0 + \beta_1 x_i + \beta_2 (x_i - c)_+ + \varepsilon_i$$
   One global intercept and slope, plus one hinge term per knot that adjusts the slope going forward without introducing a jump.

Total Nitrogen — flat, then a genuine slope break, with no discontinuity in level — belongs at the third stage: two slopes joined at a single knot.

A hinge function is feature engineering on the regressor, not a link function. It's a new column handed to an ordinary least-squares fit, estimated the usual way — "linear regression" means linear *in the coefficients*, not linear in $x$, so a model with a hinge term is still fit by `lm()`. A link function is a different mechanism: a transform on the response's mean, connecting it to the linear predictor, relevant to generalized linear models rather than to feature engineering on $x$.

### Why `log(result)`

Concentration data is strictly positive and typically right-skewed — the processes that move a concentration, such as dilution, loading, and removal, tend to act multiplicatively, a fixed-percentage effect on the current level rather than a fixed absolute amount, which generates a log-normal-shaped distribution close to by construction. Fitting on `log(result)` rather than `result` directly addresses two ordinary-least-squares assumptions the raw scale usually violates: **homoscedasticity** (raw-scale concentration variance typically grows with the mean) and **normality of residuals** (right skew on the raw scale becomes closer to symmetric on the log scale). The fit that follows models $E[\log(Y) \mid X]$ — $Y$ is treated as log-normal, not Gaussian on its original scale.

One consequence worth flagging up front: a hinge-term coefficient estimated on `log(result)` is a rate in log-units per year, not raw units per year. For small rates, $\log(1+r) \approx r$, so a coefficient like 0.14 is roughly a 14% per year change — but the number worth reporting is the back-transformed one, $(\exp(\hat\beta) - 1) \times 100\%$, not the raw log-scale coefficient.

## The shape in the record

```{r}
#| label: tn-raw-series
ggplot(tn, aes(year_frac, result)) +
  geom_point(alpha = 0.5) +
  geom_smooth(se = FALSE) +
  labs(title = "Total Nitrogen — raw scale") +
  nlt_theme

ggplot(tn, aes(year_frac, log(result))) +
  geom_point(alpha = 0.5) +
  geom_smooth(se = FALSE) +
  labs(title = "Total Nitrogen — log scale") +
  nlt_theme
```

The log-scale series is the closer match to two straight segments joined at a bend, consistent with the log-transform reasoning above.

## Estimating the breakpoint

The breakpoint was not assumed: it was estimated from the data using `segmented::segmented()`, seeded from an initial visual read of the series. That function starts from a baseline model with a single global slope and no breakpoint, then runs an iterative local search — Muggeo's algorithm: re-estimate the breakpoint given the current slopes, re-estimate the slopes given the new breakpoint, repeat to convergence — around the starting value. It is a local search, not an exhaustive one, so the starting value needs to be in the right neighborhood rather than exact; here, roughly year 6 into the twelve-year record, read off the plot above.

```{r}
#| label: tn-segmented-fit
lm_tn <- lm(log(result) ~ year_frac, data = tn)
seg_tn <- segmented(lm_tn, seg.Z = ~year_frac, psi = 6)
```

## Results

```{r}
#| label: tn-summary
summary(seg_tn)
```

The coefficient table above reports `Pr(>|t|)` as `NA` for the change-in-slope term, `U1.year_frac`. That's expected rather than missing: the standard $t$-test reference distribution assumes a fixed design matrix, and here the breakpoint the design depends on was itself estimated from the same data. `confint()` and `slope()` below are `segmented`'s treatment of this — inference on the breakpoint and on each segment's slope that accounts for the estimated breakpoint.

```{r}
#| label: tn-confint
confint(seg_tn)
```

```{r}
#| label: tn-slope
slope(seg_tn)
```

The breakpoint is estimated at `year_frac` ≈ 5.9 (95% CI 5.18–6.61) — roughly 5.9 years into the twelve-year record. Before the break, the slope is not distinguishable from zero: the series is genuinely flat for the first six years, not merely slow-rising. After the break, the slope is clearly positive (95% CI 0.120–0.160, nowhere near zero); back-transformed, $(\exp(0.140) - 1) \times 100\% \approx 15\%$ per year.

`slope()`'s output reports a $t$-value but no p-value, for the same reason as the `NA` above — the reference distribution for that statistic isn't exact once the breakpoint is estimated rather than fixed. The confidence interval carries the same caveat but is what the package leads with, rather than a p-value that would look more precise than the estimation actually supports. It doesn't change the reading: the interval excludes zero for the post-break slope and includes it for the pre-break slope, the same conclusion a p-value would give.

```{r}
#| label: tn-fitted-plot
tn_pred <- tn |> mutate(fitted = predict(seg_tn))

slope2 <- slope(seg_tn)$year_frac["slope2", ]
slope2_label <- sprintf(
  "slope 2 = %.3f (95%% CI %.3f-%.3f)",
  slope2["Est."], slope2["CI(95%).l"], slope2["CI(95%).u"]
)

ggplot(tn, aes(year_frac, log(result))) +
  geom_point(alpha = 0.5) +
  geom_line(data = tn_pred, aes(y = fitted), color = "steelblue", linewidth = 1) +
  geom_vline(xintercept = seg_tn$psi[, "Est."], linetype = "dashed") +
  annotate(
    "label",
    x = seg_tn$psi[, "Est."], y = max(log(tn$result)),
    label = slope2_label, hjust = 0, vjust = 1, size = 3.2
  ) +
  labs(title = "Total Nitrogen — continuous piecewise fit (log scale)") +
  nlt_theme
```

## Model diagnostics

The segmented fit carries the same ordinary-least-squares assumptions as the underlying linear model — homoscedasticity and normally distributed residuals.

```{r}
#| label: tn-bptest
bptest(seg_tn)
```

```{r}
#| label: tn-shapiro
shapiro.test(resid(seg_tn))
```

Both tests fail to reject their null: the Breusch-Pagan test ($p = 0.328$) finds no evidence of heteroscedasticity, and the Shapiro-Wilk test ($p = 0.575$) finds no evidence of non-normal residuals. This is also a retroactive check on the log-transform: a failure in either test would have suggested `log(result)` wasn't the right scale to model on.

## Interpretation

Total Nitrogen was flat for roughly the first six years of the record and then began rising at approximately 15% per year, with the shift estimated — not assumed — at `year_frac` ≈ 5.9, about six years into the twelve-year record, with a residual uncertainty band of roughly ±0.7 years around that estimate. The pre-break segment shows no detectable trend; the post-break segment's rate is estimated precisely enough (95% CI 0.120–0.160 log-units per year) to report with confidence. The model's assumptions hold up under diagnostic testing, supporting the fit as a defensible basis for the interpretation above.
```

- [ ] **Step 2: Render and verify**

Run: `quarto render chapters/piecewise-regression.qmd`
Expected: exits 0, `_site/chapters/piecewise-regression.html` produced.

Run: `grep -o "5\.89\|5\.9" _site/chapters/piecewise-regression.html | head -1`
Expected: at least one match, confirming the `confint()`/`slope()` chunk output rendered with the expected breakpoint value (sanity check that the fit reproduced the same result as before, since `set.seed(42)` in `R/generate_synthetic_data.R` makes this deterministic).

Run: `grep -c "scratch\|TODO\|placeholder" _site/chapters/piecewise-regression.html`
Expected: `0` — confirms none of the removed authoring-process language leaked into the rendered page.

- [ ] **Step 3: Commit**

```bash
git add chapters/piecewise-regression.qmd
git commit -m "Write piecewise regression chapter content"
```

---

## Task 4: Remove superseded files

**Files:**
- Delete: `analysis/non_linear_trends.Rmd`
- Delete: `analysis/non_linear_trends.html` (if present — it's a render artifact, check before assuming)
- Delete: `R/piecewise_model.R`
- Delete: `R/changepoint_model.R`
- Delete: `R/knn_model.R`
- Delete: `R/smoothing_models.R`
- Delete: `R/model_comparison.R`
- Delete: `.github/workflows/render-deploy.yml`

**Interfaces:**
- Consumes: nothing — this is pure removal.
- Produces: nothing — confirms no remaining file references what's deleted.

- [ ] **Step 1: Confirm nothing still references the files about to be deleted**

Run: `grep -rn "piecewise_model\|changepoint_model\|knn_model\|smoothing_models\|model_comparison" --include="*.qmd" --include="*.yml" .`
Expected: no matches (the new `.qmd` pages never source these files — fit code is inline).

- [ ] **Step 2: Delete the files**

```bash
rm -f analysis/non_linear_trends.Rmd analysis/non_linear_trends.html
rm -f R/piecewise_model.R R/changepoint_model.R R/knn_model.R R/smoothing_models.R R/model_comparison.R
rm -f .github/workflows/render-deploy.yml
```

- [ ] **Step 3: Confirm the `analysis/` directory is now empty and remove it if so**

Run: `ls -A analysis/ 2>/dev/null`
Expected: empty output (no files left). If empty, run `rmdir analysis`.

- [ ] **Step 4: Re-render the whole project to confirm nothing broke**

Run: `quarto render`
Expected: exits 0, all six chapter pages plus `index.qmd` render with no errors.

- [ ] **Step 5: Commit**

```bash
git add -A analysis/ R/ .github/
git commit -m "Remove Rmd, per-method R files, and Rmd deploy workflow"
```

---

## Task 5: Update `PROCESS.md`, `README.md`, `CLAUDE.md`

**Files:**
- Modify: `PROCESS.md`
- Modify: `README.md`
- Modify: `CLAUDE.md`

**Interfaces:**
- Consumes: nothing programmatic.
- Produces: nothing later tasks depend on — this is documentation only.

- [ ] **Step 1: Replace `PROCESS.md`'s content**

```markdown
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
```

- [ ] **Step 2: Replace `README.md`'s content**

```markdown
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
```

- [ ] **Step 3: Replace `CLAUDE.md`'s content**

```markdown
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
```

- [ ] **Step 4: Commit**

```bash
git add PROCESS.md README.md CLAUDE.md
git commit -m "Rewrite PROCESS.md, README.md, CLAUDE.md for the Quarto website structure"
```

---

## Task 6: Final whole-project verification

**Files:** none modified — verification only.

- [ ] **Step 1: Full render**

Run: `quarto render`
Expected: exits 0, `_site/` contains `index.html` and `chapters/*.html` for all six chapter pages, no errors or warnings about missing files in the console output.

- [ ] **Step 2: Confirm the sidebar lists all six chapters plus the welcome page**

Run: `grep -o 'href="[^"]*\.html"' _site/index.html | sort -u`
Expected: includes `index.html` and all six `chapters/*.html` paths.

- [ ] **Step 3: Confirm renv is still consistent**

Run: `Rscript -e 'renv::status()'`
Expected: `No issues found -- the project is in a consistent state.` (No new packages were introduced in this plan, so this should be unchanged from before.)

- [ ] **Step 4: Confirm no stray references to deleted files remain**

Run: `grep -rln "non_linear_trends.Rmd\|piecewise_model.R\|changepoint_model.R\|knn_model.R\|smoothing_models.R\|model_comparison.R" --include="*.qmd" --include="*.md" --include="*.yml" .`
Expected: no matches, or matches only inside `NOTES.md` (which is allowed to reference the old structure as historical context and is explicitly out of scope for editing).
