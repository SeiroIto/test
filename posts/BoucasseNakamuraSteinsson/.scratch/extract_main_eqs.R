library(pdftools)
pdf_path <- "C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf"
pages <- pdf_text(pdf_path)
cat("Total pages:", length(pages), "\n\n")
# Print pages 5-20 where the model equations typically appear
for (i in 5:22) {
  cat(sprintf("\n\n===== PAGE %d =====\n\n", i))
  cat(pages[[i]])
}
