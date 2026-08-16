# Linear-vs-nonlinear model comparison.
#
# Fits a plain linear model and a GAM (or LOESS) to the same analyte and
# compares them (AIC, deviance explained) to answer "was going nonlinear
# actually justified here?"
#
# Case studies: Total Chloride (a real straight-line trend — linear should
# win or tie) and Total Zinc (pure noise — neither model should claim a
# trend; this is the guard against the flexible model over-fitting noise).
#
# TBD together: comparison function, what "nonlinear wins" should require
# (not just lower AIC by epsilon — some meaningful margin / significance of
# the smooth term).
