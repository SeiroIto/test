## build_income_panel.R
## Downloads OGHIST + WDI Atlas GNI, builds panel, produces Figure 1 and three
## variants of Figure 2 (current US$, US-deflated, SDR-deflated).
## Style: data.table throughout; no pipes; sequential <- assignments.

setwd("C:/seiro/docs/personal/Miscelleneous/testrepo/posts/LowIncomeCountries")
options(repos = c(CRAN = "https://cloud.r-project.org"))

for (pkg in c("readxl","data.table","ggplot2","wbstats","stringr","scales","ggrepel")) {
  if (!requireNamespace(pkg, quietly = TRUE)) install.packages(pkg, quiet = TRUE)
}
suppressPackageStartupMessages({
  library(readxl); library(data.table)
  library(ggplot2); library(wbstats); library(stringr); library(scales)
})

base <- "C:/seiro/docs/personal/Miscelleneous/testrepo/posts/LowIncomeCountries"
src  <- file.path(base, "source")
out  <- file.path(base, ".claude")

# ── 1. Download OGHIST ────────────────────────────────────────────────────────
oghist_path <- file.path(src, "OGHIST.xlsx")
if (!file.exists(oghist_path)) {
  download.file("https://ddh-openapi.worldbank.org/resources/DR0095334/download",
                oghist_path, mode = "wb")
  cat("Downloaded OGHIST.xlsx\n")
} else {
  cat("OGHIST.xlsx already present\n")
}

# ── 2. Parse OGHIST ───────────────────────────────────────────────────────────
sheets  <- excel_sheets(oghist_path)
cat("Sheets:", paste(sheets, collapse = " | "), "\n")

hist_sh <- grep("analytical|history", sheets, ignore.case = TRUE, value = TRUE)[1]
if (is.na(hist_sh)) hist_sh <- sheets[1]
cat("Using sheet:", hist_sh, "\n")

probe <- as.data.table(read_excel(oghist_path, sheet = hist_sh,
                                  col_names = FALSE, n_max = 15))
hrow  <- NA_integer_
for (r in seq_len(nrow(probe))) {
  v <- suppressWarnings(as.numeric(unlist(probe[r, 3:min(10, ncol(probe)), with = FALSE])))
  if (any(!is.na(v) & v > 1980 & v < 2030)) { hrow <- r; break }
}
cat("Header at row:", hrow, "\n")

raw <- as.data.table(read_excel(oghist_path, sheet = hist_sh,
                                skip = hrow - 1, col_names = TRUE))
setnames(raw, 1L, "iso3c")
setnames(raw, 2L, "country")

year_cols <- names(raw)[suppressWarnings(!is.na(as.numeric(names(raw)))) &
                        suppressWarnings(as.numeric(names(raw))) > 1980 &
                        suppressWarnings(as.numeric(names(raw))) <= 2023]
cat("Year columns:", length(year_cols), " from", year_cols[1],
    "to", tail(year_cols, 1), "\n")

ig_levels <- c("L", "LM", "UM", "H")
ig_labels <- c("Low", "Lower-middle", "Upper-middle", "High")

raw_sub    <- raw[!is.na(iso3c) & nchar(trimws(as.character(iso3c))) == 3,
                  c("iso3c", "country", year_cols), with = FALSE]
panel_long <- melt(raw_sub, id.vars = c("iso3c", "country"),
                   measure.vars  = year_cols,
                   variable.name = "year", value.name = "income_group")
panel_long[, year         := as.integer(as.character(year))]
panel_long[, income_group := str_remove(as.character(income_group), "[\\*]+$")]
panel_long[, income_group := str_trim(income_group)]
panel_ig   <- panel_long[income_group %in% ig_levels]
cat("Income group panel rows:", nrow(panel_ig), "\n")
rm(raw_sub, panel_long)

# ── 2b. Thresholds from OGHIST Thresholds sheet ───────────────────────────────
thresh_raw <- as.data.table(read_excel(oghist_path, sheet = "Thresholds",
                                       col_names = FALSE))
cat("Thresholds sheet:", nrow(thresh_raw), "rows x", ncol(thresh_raw), "cols\n")

fy_row <- NA_integer_
for (r in seq_len(nrow(thresh_raw))) {
  if (any(grepl("^FY|^fy", as.character(unlist(thresh_raw[r]))))) {
    fy_row <- r; break
  }
}
cat("Fiscal year header at row:", fy_row, "\n")

fy_labels <- as.character(unlist(thresh_raw[fy_row]))
fy_years  <- suppressWarnings(as.integer(sub(".*FY0*", "", fy_labels,
                                             ignore.case = TRUE)))
fy_years[fy_years < 100  & !is.na(fy_years)] <-
  fy_years[fy_years < 100  & !is.na(fy_years)] + 1900
fy_years[fy_years >= 1900 & fy_years < 1987 & !is.na(fy_years)] <-
  fy_years[fy_years >= 1900 & fy_years < 1987 & !is.na(fy_years)] + 100
#### CLAUDE bug-fy: 2026-06-16 -1 treated FY2018 as GNI 2017 (in-effect year),
####   but FY2019 is the set applied to 2017 GNI; matches PPP 2017 base year.
# gni_years <- fy_years - 1L
gni_years <- fy_years - 2L

col_2017 <- which(gni_years == 2017)
cat("Column for GNI year 2017:", col_2017,
    " (FY label:", fy_labels[col_2017], ")\n")

row_labels <- tolower(as.character(thresh_raw[[1]]))
r_LM <- which(grepl("^low income$|^low$",       row_labels))[1]
r_UM <- which(grepl("lower.middle|lower middle", row_labels))[1]
r_H  <- which(grepl("upper.middle|upper middle", row_labels))[1]
cat("Threshold rows — L/LM:", r_LM, "  LM/UM:", r_UM, "  UM/H:", r_H, "\n")

parse_upper <- function(cell) {
  x <- gsub(",",           "", as.character(cell))
  x <- gsub("[[:space:]]", "", x)
  x <- gsub("<=|=<|<|>|=","", x)
  if (grepl("-", x)) x <- sub(".*-", "", x)
  as.numeric(x)
}

thr_cols   <- which(!is.na(gni_years) & gni_years >= 1987 & gni_years <= 2023)
thr_series <- data.table(
  year  = gni_years[thr_cols],
  L_LM  = vapply(thr_cols, function(j) parse_upper(thresh_raw[[j]][r_LM]), numeric(1)),
  LM_UM = vapply(thr_cols, function(j) parse_upper(thresh_raw[[j]][r_UM]), numeric(1)),
  UM_H  = vapply(thr_cols, function(j) parse_upper(thresh_raw[[j]][r_H ]), numeric(1))
)
thr_series <- thr_series[!is.na(L_LM)]
setorder(thr_series, year)

# ── 2c. US deflator ───────────────────────────────────────────────────────────
cat("Downloading US GDP deflator (NY.GDP.DEFL.ZS, USA) ...\n")
defl_raw <- as.data.table(wb_data("NY.GDP.DEFL.ZS", country = "USA",
                                   start_date = 1987, end_date = 2023))
defl     <- defl_raw[, .(year = date, D_US = NY.GDP.DEFL.ZS)]
D_2017   <- defl[year == 2017, D_US]
defl[, conv_factor := D_2017 / D_US]

thr_series <- merge(thr_series, defl[, .(year, conv_factor)], by = "year")
thr_series[, L_LM_US  := L_LM  * conv_factor]
thr_series[, LM_UM_US := LM_UM * conv_factor]
thr_series[, UM_H_US  := UM_H  * conv_factor]

# ── 2d. SDR deflator ──────────────────────────────────────────────────────────
#### CLAUDE spl: 2026-06-17 WB adjusts thresholds with SDR deflator, not US
####   deflator alone. Basket 2022: USD 43.38%, EUR 29.31%, CNY 12.28%,
####   JPY 7.59%, GBP 7.44%. Fixed weights used for entire 1987-2023 period.
sdr_w <- c(USA = 0.4338, EMU = 0.2931, CHN = 0.1228, JPN = 0.0759, GBR = 0.0744)
cat("Downloading GDP deflators for SDR basket countries ...\n")
sdr_raw  <- as.data.table(wb_data("NY.GDP.DEFL.ZS", country = names(sdr_w),
                                   start_date = 1987, end_date = 2023))
sdr_sub  <- sdr_raw[, .(iso3c, date, defl = NY.GDP.DEFL.ZS)]
sdr_wide <- dcast(sdr_sub, date ~ iso3c, value.var = "defl")
setnames(sdr_wide, "date", "year")
setorder(sdr_wide, year)
cat("sdr_wide:", nrow(sdr_wide), "rows x", ncol(sdr_wide), "cols:",
    paste(names(sdr_wide), collapse = ", "), "\n")

avail_c  <- intersect(names(sdr_w), names(sdr_wide))
sdr_mat  <- as.matrix(sdr_wide[, avail_c, with = FALSE])
sdr_wide[, SDR := apply(sdr_mat, 1, function(r) {
  ok <- !is.na(r)
  if (!any(ok)) return(NA_real_)
  w <- sdr_w[avail_c][ok]; w <- w / sum(w)
  sum(r[ok] * w)
})]
SDR_2017 <- sdr_wide[year == 2017, SDR]
sdr_wide[, conv_SDR := SDR_2017 / SDR]
sdr_conv <- sdr_wide[, .(year, conv_SDR)]
cat("SDR 2017 base =", round(SDR_2017, 2),
    "; countries:", paste(avail_c, collapse = ", "), "\n")

thr_series <- merge(thr_series, sdr_conv, by = "year", all.x = TRUE)
thr_series[, L_LM_SDR  := L_LM  * conv_SDR]
thr_series[, LM_UM_SDR := LM_UM * conv_SDR]
thr_series[, UM_H_SDR  := UM_H  * conv_SDR]

cat("\n=== WB threshold conversion (current US$ → constant 2017 US$) ===\n")
print(thr_series[, .(year, L_LM,
                      conv_US  = round(conv_factor, 3),
                      L_LM_US  = round(L_LM_US),
                      conv_SDR = round(conv_SDR, 3),
                      L_LM_SDR = round(L_LM_SDR))])

# Threshold long-format: one row per year×boundary, three versions
make_thr <- function(ts, l_lm, lm_um, um_h) {
  rbindlist(list(
    data.table(year = ts$year, boundary = "L→LM",  y = ts[[l_lm]]),
    data.table(year = ts$year, boundary = "LM→UM", y = ts[[lm_um]]),
    data.table(year = ts$year, boundary = "UM→H",  y = ts[[um_h]])
  ))[, boundary := factor(boundary, levels = c("L→LM", "LM→UM", "UM→H"))][]
}
thr_long_current <- make_thr(thr_series, "L_LM",    "LM_UM",    "UM_H")
thr_long_US      <- make_thr(thr_series, "L_LM_US", "LM_UM_US", "UM_H_US")
thr_long_SDR     <- make_thr(thr_series, "L_LM_SDR","LM_UM_SDR","UM_H_SDR")

# ── 3. WDI: Atlas GNI per capita + deflated variants ─────────────────────────
#### CLAUDE spl: 2026-06-17 switched from PPP (NY.GNP.PCAP.PP.KD) to Atlas
####   (NY.GNP.PCAP.CD); same method as OGHIST thresholds → consistent units
#### CLAUDE spl: 2026-06-17 added PPP (NY.GNP.PCAP.PP.CD, current intl $) as a
####   4th y-axis. PPP intl $ ≡ US$ at the US (PPP numeraire), so the current-US$
####   Atlas thresholds serve as the reference line; per-country crossings differ
####   from OGHIST by each country's price level (the price-level effect).
cat("Downloading WDI (NY.GNP.PCAP.CD Atlas + NY.GNP.PCAP.PP.CD PPP) ...\n")
gni_raw <- as.data.table(wb_data(c("NY.GNP.PCAP.CD", "NY.GNP.PCAP.PP.CD"),
                                  start_date = 1987, end_date = 2023))
gni     <- gni_raw[!is.na(NY.GNP.PCAP.CD),
                   .(iso3c, year = date, gni_atlas = NY.GNP.PCAP.CD,
                     gni_ppp = NY.GNP.PCAP.PP.CD)]
gni     <- merge(gni, defl[,    .(year, conv_factor)], by = "year", all.x = TRUE)
gni     <- merge(gni, sdr_conv,                        by = "year", all.x = TRUE)
gni[, gni_atlas_US  := gni_atlas * conv_factor]
gni[, gni_atlas_SDR := gni_atlas * conv_SDR]
cat("WDI GNI rows with Atlas data:", nrow(gni),
    "; of which PPP non-NA:", gni[!is.na(gni_ppp), .N], "\n")

# ── 4. Merge and save panel ───────────────────────────────────────────────────
gni_cols <- c("iso3c", "year", "gni_atlas", "gni_atlas_US",
              "gni_atlas_SDR", "gni_ppp")
panel    <- merge(panel_ig, gni[, gni_cols, with = FALSE],
                  by = c("iso3c", "year"), all.x = TRUE)
panel[, ig_ord := factor(income_group, levels = ig_levels,
                         labels = ig_labels, ordered = TRUE)]
setorder(panel, iso3c, year)
fwrite(panel, file.path(src, "wb_income_panel.csv"))
cat("Saved wb_income_panel.csv (", nrow(panel), "rows )\n")

# ── 5. Figure 1: stacked bar — count of countries by income group per year ────
fig1_dat <- unique(panel[!is.na(income_group)], by = c("iso3c", "year"))[
             , .N, by = .(year, ig_ord)]

fig1 <- ggplot(fig1_dat, aes(year, N, fill = ig_ord)) +
  geom_col(width = 0.85, position = position_stack(reverse = TRUE)) +
  scale_fill_manual(
    values = c("Low"="#d73027","Lower-middle"="#fc8d59",
               "Upper-middle"="#91bfdb","High"="#4575b4"),
    name = "Income group") +
  scale_x_continuous(breaks = seq(1990, 2024, 5)) +
  labs(title   = "Number of countries by World Bank income group, 1987–2023",
       x = NULL, y = "Number of countries",
       caption = "Source: World Bank OGHIST") +
  theme_bw(base_size = 13) +
  theme(legend.position = "bottom") +
  guides(fill = guide_legend(reverse = TRUE))
ggsave(file.path(out, "fig1_income_groups_count.png"), fig1,
       width = 12, height = 6, dpi = 150)
cat("Saved fig1_income_groups_count.png\n")

fig1_facet <- ggplot(fig1_dat, aes(year, N, fill = ig_ord)) +
  geom_col(width = 0.85) +
  facet_wrap(~ factor(ig_ord, levels = rev(levels(ig_ord))),
             ncol = 1, scales = "free_y") +
  scale_fill_manual(
    values = c("Low"="#d73027","Lower-middle"="#fc8d59",
               "Upper-middle"="#91bfdb","High"="#4575b4"),
    guide = "none") +
  scale_x_continuous(breaks = seq(1990, 2024, 10)) +
  labs(title   = "Number of countries by World Bank income group, 1987–2023",
       x = NULL, y = "Number of countries",
       caption = "Source: World Bank OGHIST") +
  theme_bw(base_size = 13) +
  theme(strip.background = element_rect(fill = "gray95"),
        strip.text       = element_text(face = "bold"))
ggsave(file.path(out, "fig1Facet_income_groups_count.png"), fig1_facet,
       width = 8, height = 14, dpi = 150)
cat("Saved fig1Facet_income_groups_count.png\n")

# ── 6. Figure 2 shared setup ──────────────────────────────────────────────────
mov_levels <- c("2up", "1up", "stay", "1down", "2down")
fig2_base  <- panel[!is.na(gni_atlas) & !is.na(income_group)]
mov_first  <- fig2_base[, .(ig_first = income_group[which.min(year)]), by = iso3c]
mov_last   <- fig2_base[, .(ig_last  = income_group[which.max(year)]), by = iso3c]
mov_class  <- merge(mov_first, mov_last, by = "iso3c")
mov_class[, net_change := match(ig_last, ig_levels) - match(ig_first, ig_levels)]
mov_class[, movement   := fifelse(net_change >= 2,  "2up",
                          fifelse(net_change == 1,  "1up",
                          fifelse(net_change == 0,  "stay",
                          fifelse(net_change == -1, "1down", "2down"))))]
mov_class[, movement := factor(movement, levels = mov_levels)]
cat("Movement counts:\n"); print(table(mov_class$movement, useNA = "always"))

# Countries that STARTED in Low income (OGHIST) and rose 2+ groups, KEEPING only
# those whose first-year *revised* GNI is at/below the L/LM line that year — i.e.
# genuinely Low by today's data. Drops Maldives & Indonesia, whose modern GNI was
# already above the cutoff in their first year (a data-vintage artefact: WB
# classified them Low at the time using lower contemporaneous estimates).
# Viridis palette (colour-blind safe), capped at end=0.6 so the lightest fill
# keeps white label text readable; same hex for line colour and label fill.
hi_cand  <- mov_class[ig_first == "L" & net_change >= 2, iso3c]
hi_first <- panel[iso3c %in% hi_cand & !is.na(gni_atlas)][
              order(year), .(year = year[1], gni0 = gni_atlas[1]), by = iso3c]
hi_first <- merge(hi_first, thr_series[, .(year, L_LM)], by = "year", all.x = TRUE)
hi_L     <- hi_first[gni0 <= L_LM, iso3c]
cat("L-origin 2+up (OGHIST):", paste(hi_cand, collapse = ", "),
    "\n  kept (first-yr revised GNI <= L/LM):", paste(hi_L, collapse = ", "), "\n")
hi_cols  <- setNames(scales::viridis_pal(begin = 0, end = 0.6)(length(hi_L)), hi_L)

panel_for_trans <- copy(panel[!is.na(income_group) & !is.na(gni_atlas)])
setorder(panel_for_trans, iso3c, year)
panel_for_trans[, prev_ig := shift(income_group, type = "lag"), by = iso3c]
trans_up <- panel_for_trans[
  !is.na(prev_ig) & income_group != prev_ig &
  ((prev_ig == "L"  & income_group == "LM") |
   (prev_ig == "LM" & income_group == "UM") |
   (prev_ig == "UM" & income_group == "H"))]
trans_up[, boundary := factor(paste0(prev_ig, "→", income_group),
                              levels = c("L→LM", "LM→UM", "UM→H"))]
thresh_n <- trans_up[, .(n_countries = uniqueN(iso3c)), by = boundary]
setorder(thresh_n, boundary)
cat("Countries crossing each boundary:\n"); print(thresh_n)

fig2_all <- merge(panel[!is.na(gni_atlas)],
                  mov_class[, .(iso3c, movement)],
                  by = "iso3c", all.x = TRUE)
fig2_all[, draw_order := fifelse(movement == "stay", 1L,
                         fifelse(movement %in% c("1up", "1down"), 2L, 3L))]

# Yellow (1up) L-origin countries with the 5 lowest first-year incomes —
# annotated black-on-yellow, spread across 1997–2005.
yl_cand  <- mov_class[movement == "1up" & ig_first == "L", iso3c]
yl_first <- panel[iso3c %in% yl_cand & !is.na(gni_atlas)][
              order(year), .(gni0 = gni_atlas[1]), by = iso3c]
setorder(yl_first, gni0)
yl5      <- head(yl_first$iso3c, 5)
cat("Bottom-5 lowest-income yellow L-origin:", paste(yl5, collapse = ", "), "\n")

col_map <- c("2up"="#d73027","1up"="#f4a100","stay"="gray70",
             "1down"="#74add1","2down"="#313695")
alp_map <- c("2up"=0.82,"1up"=0.75,"stay"=0.50,"1down"=0.75,"2down"=0.82)
lwd_map <- c("2up"=0.55,"1up"=0.45,"stay"=0.45,"1down"=0.45,"2down"=0.55)

# ── 6b. Three figure variants via loop ───────────────────────────────────────
fig2_specs <- list(
  list(gni_col  = "gni_atlas",
       thr_long = thr_long_current,
       fname    = "fig2_income_trajectories_current.png",
       title    = "GNI per capita (Atlas method, current US\u24) by country, 1987–2023",
       y_lab    = "GNI per capita, Atlas method, current US\u24 (log scale)",
       thr_note = "no deflation — axis and lines in identical current US\u24"),
  list(gni_col  = "gni_atlas_US",
       thr_long = thr_long_US,
       fname    = "fig2_income_trajectories_US.png",
       title    = "GNI per capita (Atlas, constant 2017 US\u24, US deflator) by country, 1987–2023",
       y_lab    = "GNI per capita, constant 2017 US\u24 via US deflator (log scale)",
       thr_note = "deflated by US GDP deflator (NY.GDP.DEFL.ZS) to constant 2017 US\u24"),
  list(gni_col  = "gni_atlas_SDR",
       thr_long = thr_long_SDR,
       fname    = "fig2_income_trajectories_SDR.png",
       title    = "GNI per capita (Atlas, constant 2017 US\u24, SDR deflator) by country, 1987–2023",
       y_lab    = "GNI per capita, constant 2017 US\u24 via SDR deflator (log scale)",
       thr_note = "deflated by SDR basket (USD 43% EUR 29% CNY 12% JPY 8% GBP 7%) to constant 2017 US\u24"),
  list(gni_col  = "gni_ppp",
       thr_long = thr_long_current,
       fname    = "fig2_income_trajectories_PPP.png",
       title    = "GNI per capita (PPP, current international \u24) by country, 1987–2023",
       y_lab    = "GNI per capita, PPP, current international \u24 (log scale)",
       thr_note = paste0("WB Atlas cutoffs at US prices (PPP numeraire: intl \u24 ≡ US\u24);",
                         " per-country crossings differ from OGHIST by price level"))
)

for (sp in fig2_specs) {

  d        <- fig2_all[order(draw_order, iso3c, year)]
  d[,        y_plot := d[[sp$gni_col]]]
  thr_last <- sp$thr_long[order(year)][!duplicated(boundary, fromLast = TRUE)]
  thr_lbl  <- merge(thr_last, thresh_n, by = "boundary")

  fig2 <- ggplot(d, aes(year, y_plot, group = iso3c,
                         colour = movement, alpha = movement, linewidth = movement)) +
    geom_line() +
    geom_step(data        = sp$thr_long,
              aes(x = year, y = y, linetype = boundary),
              colour      = "forestgreen", linewidth = 0.85,
              direction   = "hv", inherit.aes = FALSE) +
    scale_colour_manual(values = col_map,
      labels = c("2up"="2+ groups up","1up"="1 group up","stay"="No change",
                 "1down"="1 group down","2down"="2+ groups down"),
      name = "Net movement") +
    scale_alpha_manual(values = alp_map, guide = "none") +
    scale_linewidth_manual(values = lwd_map, guide = "none") +
    scale_linetype_manual(
      values = c("L→LM"="solid","LM→UM"="dashed","UM→H"="dotted"),
      name   = "Boundary") +
    scale_y_log10(labels = comma_format(accuracy = 1)) +
    scale_x_continuous(breaks = seq(1990, 2024, 5)) +
    labs(
      title    = sp$title,
      subtitle = paste0(
        "Colour = change in official WB (Atlas) income group, first to last year:\n",
        "red 2+ up · yellow 1 up · gray no change ·",
        " light blue 1 down · deep blue 2+ down\n",
        "Green step lines = WB income thresholds, ", sp$thr_note),
      x       = NULL,
      y       = sp$y_lab,
      caption = "Sources: World Bank WDI (NY.GNP.PCAP.CD) and OGHIST") +
    theme_bw(base_size = 11) +
    theme(legend.position = "bottom", panel.grid.minor = element_blank())

  # (a) one thicker viridis line per highlighted country
  hi_dat <- d[iso3c %in% hi_L & !is.na(y_plot)]
  for (cc in hi_L) {
    fig2 <- fig2 +
      geom_line(data = hi_dat[iso3c == cc], aes(year, y_plot, group = iso3c),
                colour = hi_cols[[cc]], linewidth = 1.2, inherit.aes = FALSE)
  }
  # (b) highlight labels: GUY anchored at 1993, the rest at 1995; viridis fill,
  #     white text, repelled vertically (fill scale is free → no ggnewscale)
  hi_yr <- setNames(rep(1995, length(hi_L)), hi_L)
  if ("GUY" %in% hi_L) hi_yr["GUY"] <- 1993
  hi_anchor <- rbindlist(lapply(hi_L, function(cc) {
    z <- hi_dat[iso3c == cc]; z[which.min(abs(year - hi_yr[[cc]]))]
  }))
  fig2 <- fig2 +
    ggrepel::geom_label_repel(
      data           = hi_anchor,
      aes(year, y_plot, label = country, fill = iso3c),
      colour         = "white", size = 3.0, fontface = "bold",
      label.padding  = unit(0.15, "lines"), inherit.aes = FALSE,
      direction      = "y", hjust = 0.5, nudge_x = 0,
      segment.colour = "gray30", min.segment.length = 0,
      box.padding    = 0.5, max.overlaps = Inf, seed = 1) +
    scale_fill_manual(values = hi_cols, guide = "none")
  # (c) yellow bottom-5: black text on yellow fill, anchors spread 1997–2005
  yl_yr     <- setNames(round(seq(1997, 2005, length.out = length(yl5))), yl5)
  yl_anchor <- rbindlist(lapply(yl5, function(cc) {
    z <- d[iso3c == cc & !is.na(y_plot)]; z[which.min(abs(year - yl_yr[[cc]]))]
  }))
  fig2 <- fig2 +
    ggrepel::geom_label_repel(
      data           = yl_anchor,
      aes(year, y_plot, label = country),
      colour         = "black", fill = "#f4a100", size = 2.8,
      label.padding  = unit(0.15, "lines"), inherit.aes = FALSE,
      direction      = "y", hjust = 0.5, nudge_x = 0,
      segment.colour = "gray30", min.segment.length = 0,
      box.padding    = 0.5, max.overlaps = Inf, seed = 2)
  # (d) n= threshold labels added LAST, so nothing is drawn over them
  fig2 <- fig2 +
    geom_label(data          = thr_lbl,
               aes(x = year, y = y,
                   label = paste0(boundary, "\n(n=", n_countries, ")")),
               colour        = "forestgreen", fill = "white",
               size          = 2.8, hjust = 1,
               label.padding = unit(0.15, "lines"), inherit.aes = FALSE)

  ggsave(file.path(out, sp$fname), fig2, width = 16, height = 10, dpi = 150)
  cat("Saved", sp$fname, "\n")
}

cat("Done.\n")
