library(pdftools)
pdf_path <- "C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf"
pages <- pdf_text(pdf_path)
for (i in 22:38) {
  cat(sprintf("\n\n===== PAGE %d =====\n\n", i))
  cat(pages[[i]])
}
