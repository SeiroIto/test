suppressPackageStartupMessages(library(data.table))
p <- fread("C:/seiro/docs/personal/Miscelleneous/testrepo/posts/LowIncomeCountries/source/wb_income_panel.csv")
LLM <- c(`1987`=480,`1988`=545,`1989`=580,`1990`=610,`1991`=635,`1992`=675)
hi <- c("CHN","GNQ","GUY","IDN","MDV")
for (cc in hi) {
  z <- p[iso3c == cc & year %in% 1987:1992][order(year)]
  cat("\n", cc, ":\n", sep="")
  for (i in seq_len(nrow(z))) {
    yr <- as.character(z$year[i]); thr <- LLM[yr]
    flag <- if (!is.na(z$gni_atlas[i]) && z$gni_atlas[i] > thr) " <-- ABOVE L/LM" else ""
    cat(sprintf("  %s  gni=%s  ig=%s  L/LM=%s%s\n",
                yr, format(round(z$gni_atlas[i]), nsmall=0),
                z$income_group[i], thr, flag))
  }
}
