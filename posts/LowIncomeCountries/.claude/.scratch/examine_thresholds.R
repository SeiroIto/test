options(warn = -1)
p <- read.csv("C:/seiro/docs/personal/Miscelleneous/testrepo/posts/LowIncomeCountries/source/wb_income_panel.csv",
              stringsAsFactors = FALSE)

t_LLM <- 995; t_LMU <- 3895; t_UMH <- 12055

cat("=== 1990: OGHIST-Low countries, PPP distribution ===\n")
d90L <- p[p$year == 1990 & p$income_group == "L" & !is.na(p$gni_ppp), ]
cat("N OGHIST-Low in 1990 with PPP data:", nrow(d90L), "\n")
cat("PPP min / median / max:", round(min(d90L$gni_ppp)), "/",
    round(median(d90L$gni_ppp)), "/", round(max(d90L$gni_ppp)), "\n")
cat("Of these, how many have PPP < 995 (the L/LM line)?:",
    sum(d90L$gni_ppp < t_LLM), "\n")
cat("PPP band of OGHIST-Low 1990 countries:\n")
band <- ifelse(d90L$gni_ppp < t_LLM, "L(<995)",
        ifelse(d90L$gni_ppp < t_LMU, "LM(995-3895)",
        ifelse(d90L$gni_ppp < t_UMH, "UM(3895-12055)", "H(>12055)")))
print(table(band))

cat("\n=== All years: OGHIST group vs PPP band (cross-tab) ===\n")
pp <- p[!is.na(p$gni_ppp), ]
pp$ppp_band <- ifelse(pp$gni_ppp < t_LLM, "L",
              ifelse(pp$gni_ppp < t_LMU, "LM",
              ifelse(pp$gni_ppp < t_UMH, "UM", "H")))
pp$ppp_band <- factor(pp$ppp_band, levels = c("L","LM","UM","H"))
pp$income_group <- factor(pp$income_group, levels = c("L","LM","UM","H"))
cat("Rows = OGHIST (Atlas) classification, Cols = PPP band:\n")
print(addmargins(table(OGHIST = pp$income_group, PPP_band = pp$ppp_band)))

cat("\n=== Median PPP of each OGHIST group (the PPP-equivalent of Atlas bands) ===\n")
agg <- aggregate(gni_ppp ~ income_group, data = pp,
                 FUN = function(x) round(median(x)))
print(agg)

cat("\n=== How many country-years are OGHIST-Low but plot ABOVE $995 PPP? ===\n")
oghist_low <- pp[pp$income_group == "L", ]
cat("OGHIST-Low country-years with PPP data:", nrow(oghist_low), "\n")
cat("  of which PPP >= 995 (wrongly appear non-Low on the axis):",
    sum(oghist_low$gni_ppp >= t_LLM),
    paste0("(", round(100*mean(oghist_low$gni_ppp >= t_LLM)), "%)"), "\n")
