# LOESS and GAM smoothing.
#
# LOESS section — case study: Total Phosphorus, a logistic saturation curve
# with no single breakpoint or straight segment.
#
# GAM section — case study: Dissolved Oxygen, a seasonal cycle layered on a
# slow multi-year decline. `mgcv::gam()` with a smooth term on year_frac
# (and, if we want to separate seasonal cycle from trend, a second smooth
# or a cyclic term on month).
#
# TBD together: fit functions for both, span/k selection, how the fitted
# curve + confidence band gets plotted against the raw data.
