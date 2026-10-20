source("R/analysis.R")

out <- tempfile()

dir.create(out)

r <- run_analysis(normalizePath("."), out)

stopifnot(length(r) > 0, file.exists(out))

stopifnot(r$components_90_percent == 8, r$retained_variance >= 0.9, r$solution_residual < 
    1e-08, r$pseudoinverse_agreement < 1e-08)

cat("Validation passed\n")

