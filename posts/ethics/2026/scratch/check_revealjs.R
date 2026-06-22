library(tinytable)
# Get the css_dark template from the package namespace
ns <- asNamespace("tinytable")
cat("=== css_dark ===\n")
cat(get("css_dark", envir = ns))
