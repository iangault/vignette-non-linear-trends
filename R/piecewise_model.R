# Piecewise / segmented linear regression.
#
# Fits a linear model with one estimated breakpoint (slope before differs
# from slope after) to a single analyte's time series. Case study: Total
# Nitrogen (data/synthetic/non_linear_wq.csv), which has a real slope break
# around year_frac ~ 6.
#
# TBD together: fit function (base lm() + `segmented::segmented()` is the
# natural choice), what it returns, breakpoint CI extraction.
