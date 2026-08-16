# Changepoint detection.
#
# Detects a shift in mean/level (not slope) at an unknown location in a
# time series. Case study: Specific Conductance (data/synthetic/non_linear_wq.csv),
# which has a real step change around year_frac ~ 7.2 with equal (zero)
# slope on both sides.
#
# TBD together: fit function (`changepoint::cpt.mean()` is the natural
# choice; `strucchange` is an alternative), how the detected breakpoint gets
# compared back to the piecewise-regression breakpoint from the previous
# section.
