suppressPackageStartupMessages(library(data.table))
p <- fread("C:/seiro/docs/personal/Miscelleneous/testrepo/posts/LowIncomeCountries/source/wb_income_panel.csv")
ig_levels <- c("L","LM","UM","H")

b  <- p[!is.na(gni_atlas) & !is.na(income_group)]
mf <- b[, .(ig_first = income_group[which.min(year)],
            yr_first = min(year)), by = iso3c]
ml <- b[, .(ig_last  = income_group[which.max(year)],
            yr_last  = max(year)), by = iso3c]
m  <- merge(mf, ml, by = "iso3c")
m[, net := match(ig_last, ig_levels) - match(ig_first, ig_levels)]
oneup <- m[net == 1]

cat("=== '1up' (yellow) countries:", nrow(oneup), "===\n")
for (cc in oneup$iso3c) {
  seq <- b[iso3c == cc][order(year)]
  cat(sprintf("%s  first=%s(%d) last=%s(%d) | path: %s\n",
              cc, oneup[iso3c==cc, ig_first], oneup[iso3c==cc, yr_first],
              oneup[iso3c==cc, ig_last], oneup[iso3c==cc, yr_last],
              paste(seq$income_group, collapse="")))
}

cat("\n=== flag: 1up countries whose path contains H ===\n")
for (cc in oneup$iso3c) {
  seq <- b[iso3c == cc][order(year)]
  if (any(seq$income_group == "H"))
    cat(sprintf("%s: %s\n", cc, paste(seq$income_group, collapse="")))
}
