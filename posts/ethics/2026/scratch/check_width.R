library(tinytable)
library(data.table)

dt <- data.table(
  A = c("x", "y"),
  B = c("a", "b")
)

# Check tt() signature
cat("=== tt() args ===\n")
print(args(tt))

# Check what each width arg produces as HTML
get_inline_style <- function(w_arg) {
  if (is.null(w_arg)) {
    tb <- tt(dt)  # no width arg at all
  } else {
    tb <- tt(dt, width = w_arg)
  }
  html <- capture.output(print(tb, output = "html"))
  style_line <- grep("table-layout|width:", html, value = TRUE)
  style_line <- style_line[1]
  if (is.na(style_line)) style_line <- "(no style found)"
  style_line
}

cat("\n=== width = NULL (default, no arg) ===\n")
cat(get_inline_style(NULL), "\n")

cat("\n=== width = 1 ===\n")
cat(get_inline_style(1), "\n")

cat("\n=== width = c(.2,.15,.4) ===\n")
cat(get_inline_style(c(.2,.15,.4)), "\n")

cat("\n=== width = c(1) ===\n")
cat(get_inline_style(c(1)), "\n")
