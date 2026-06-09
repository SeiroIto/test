library(pdftools)
pdf_path <- "C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf"
pages <- pdf_text(pdf_path)
out_path <- "C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/.scratch/main_paper_text.txt"
con <- file(out_path, open = "w", encoding = "UTF-8")
cat(sprintf("Total pages: %d\n", length(pages)), file = con)
for (i in seq_along(pages)) {
  cat(sprintf("\n\n===== PAGE %d =====\n\n", i), file = con)
  cat(pages[[i]], file = con)
}
close(con)
cat("Done. Written to", out_path, "\n")
