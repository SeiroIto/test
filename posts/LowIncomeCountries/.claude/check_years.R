options(warn = -1)
library(wbstats)
gni <- wb_data("NY.GNP.PCAP.PP.KD", start_date = 2020, end_date = 2024)
gni2 <- gni[!is.na(gni[["NY.GNP.PCAP.PP.KD"]]), ]
cat("Last year with GNI PPP data:", max(gni2[["date"]]), "\n")
cat("Countries with 2024 data:", sum(gni2[["date"]] == 2024), "\n")
cat("Countries with 2023 data:", sum(gni2[["date"]] == 2023), "\n")
cat("Countries with 2022 data:", sum(gni2[["date"]] == 2022), "\n")
