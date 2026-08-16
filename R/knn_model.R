# k-Nearest Neighbors regression.
#
# Predicts each point as the average response of its k nearest neighbors by
# Euclidean distance on the regressor. Case study: Total Phosphorus (shared
# with the LOESS section — same rise-then-plateau data, for a direct
# side-by-side of k-NN's local-average fit against LOESS's local-regression
# fit). `caret::knnreg()` is the course's fit call (DSCI 562 Lecture 6).
#
# Note the notation gotcha from the course: k is the neighbor count here, not
# the number of regressors (that's p in this section, to avoid the clash).
#
# Bias-variance framing to demonstrate: k = 1 gives zero training error but
# will likely overfit; increasing k smooths the fit until it starts
# underfitting. No coefficients, no significance test — even less of an
# inferential story than LOESS.
#
# TBD together: fit function, how k gets chosen/swept for the demonstration.
