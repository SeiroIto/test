library(pdftools)
pdf_path <- "C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf"
text <- pdf_text(pdf_path)
writeLines(text, "C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/BoucasseNakamuraSteinsson_text.txt")
cat("Extracted text successfully!\n")
