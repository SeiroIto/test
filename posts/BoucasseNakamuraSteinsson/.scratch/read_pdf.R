library(pdftools)
txt <- pdf_text("C:/seiro/docs/personal/Miscelleneous/testrepo/posts/BoucasseNakamuraSteinsson/BoucasseNakamuraSteinsson_WhenGrowth_QJE2025.pdf")
cat(paste(txt, collapse="\n---PAGE BREAK---\n"))
