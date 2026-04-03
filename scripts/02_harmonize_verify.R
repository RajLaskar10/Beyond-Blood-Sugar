# 02_harmonize_verify.R
# Phase 2: Harmonize and verify combined dataset
# Covers GitHub Issue #8
# Run from repo root: source("scripts/02_harmonize_verify.R")

source("scripts/00_setup.R")

cat("\n", strrep("=", 60), "\n")
cat("PHASE 2: HARMONIZE & VERIFY COMBINED DATASET\n")
cat(strrep("=", 60), "\n\n")

# ---------------------------------------------------------------------------
# STEP 1 — Load source datasets
# ---------------------------------------------------------------------------
cat(strrep("-", 60), "\n")
cat("STEP 1: Loading source datasets\n")
cat(strrep("-", 60), "\n")

df_2014 <- read.csv(paste0(PATH_RAW, "LLCP2014_model.csv"))
df_2022 <- read.csv(paste0(PATH_RAW, "LLCP2022_model.csv"))

cat(sprintf("2014: %d rows x %d cols\n", nrow(df_2014), ncol(df_2014)))
cat(sprintf("2022: %d rows x %d cols\n", nrow(df_2022), ncol(df_2022)))

# ---------------------------------------------------------------------------
# STEP 2 — Harmonize 2014
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 2: Harmonizing 2014 dataset\n")
cat(strrep("-", 60), "\n")

# Rename year-specific columns to common names; drop raw diabetes code
df_2014_h <- df_2014 %>%
  rename(
    X_RACEGR = X_RACEGR3, # race column rename (2014 → common)
    DRNKANY  = DRNKANY5, # alcohol rename (survey cycle suffix)
    HLTHPLN  = HLTHPLN1 # health plan rename
    # INSULIN, MEDCOST already use target names in 2014
  ) %>%
  mutate(Year = 2014L) %>%
  select(-DIABETE3) # drop raw diabetes question code (use Diabetes_Binary)

cat(sprintf(
  "2014 harmonized: %d rows x %d cols\n",
  nrow(df_2014_h), ncol(df_2014_h)
))
cat("2014 columns:\n")
print(sort(colnames(df_2014_h)))

# ---------------------------------------------------------------------------
# STEP 3 — Harmonize 2022
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 3: Harmonizing 2022 dataset\n")
cat(strrep("-", 60), "\n")

df_2022_h <- df_2022 %>%
  rename(
    X_RACEGR = X_RACEGR4, # race column rename (2022 → common)
    X_INCOMG = X_INCOMG1, # income rename (survey variable rename)
    DRNKANY  = DRNKANY6, # alcohol rename (survey cycle suffix)
    INSULIN  = INSULIN1, # insulin rename
    HLTHPLN  = X_HLTHPLN, # health plan rename
    MEDCOST  = MEDCOST1 # medical cost rename
  ) %>%
  mutate(
    Year = 2022L,

    # Recode income: collapse 2022 codes 5 (50-100k) and 6 (>100k) → 5 (>50k)
    # to match 2014's 5-level scale
    X_INCOMG = if_else(X_INCOMG > 5L, 5L, X_INCOMG),

    # Recode derived Income character column to match 2014's 5 levels
    Income = case_when(
      Income %in% c("50-100k", ">100k") ~ ">50k",
      TRUE ~ Income
    ),

    # Derive Race character column (absent in 2022, present in 2014)
    # Coding: 1=White, 2=Black, 3=Hispanic, 4=Multiracial, 5=Other
    Race = case_when(
      X_RACEGR == 1L ~ "White",
      X_RACEGR == 2L ~ "Black",
      X_RACEGR == 3L ~ "Hispanic",
      X_RACEGR == 4L ~ "Multiracial",
      X_RACEGR == 5L ~ "Other",
      TRUE ~ NA_character_
    )
  ) %>%
  select(
    -DIABETE4, # drop raw diabetes question code
    -X_SEX, # 2022-only — absent from 2014
    -Sex, # derived label for X_SEX
    -Health_Insurance
  ) # derived label for HLTHPLN (already captured as HLTHPLN)

cat(sprintf(
  "2022 harmonized: %d rows x %d cols\n",
  nrow(df_2022_h), ncol(df_2022_h)
))
cat("2022 columns:\n")
print(sort(colnames(df_2022_h)))

# ---------------------------------------------------------------------------
# STEP 4 — Column alignment check before binding
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 4: Column alignment check\n")
cat(strrep("-", 60), "\n")

cols_only_2014 <- setdiff(colnames(df_2014_h), colnames(df_2022_h))
cols_only_2022 <- setdiff(colnames(df_2022_h), colnames(df_2014_h))

cat("Columns in 2014 but not 2022 (expect none):\n")
print(if (length(cols_only_2014) == 0) "none" else cols_only_2014)

cat("\nColumns in 2022 but not 2014 (expect none):\n")
print(if (length(cols_only_2022) == 0) "none" else cols_only_2022)

if (length(cols_only_2014) > 0 || length(cols_only_2022) > 0) {
  stop("Column mismatch detected — fix before binding. See output above.")
}
cat("Column alignment: OK\n")

# ---------------------------------------------------------------------------
# STEP 5 — Row-bind and add verification columns
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 5: Row-binding\n")
cat(strrep("-", 60), "\n")

df_combined <- bind_rows(df_2014_h, df_2022_h)

cat(sprintf("Combined: %d rows x %d cols\n", nrow(df_combined), ncol(df_combined)))

# ---------------------------------------------------------------------------
# STEP 6 — Verification
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 6: Verification\n")
cat(strrep("-", 60), "\n")

cat("\nRow count by Year:\n")
print(table(df_combined$Year))

cat("\nTarget distribution by Year:\n")
print(table(df_combined$Diabetes_Binary, df_combined$Year))

cat("\nMissing values per column:\n")
na_counts <- colSums(is.na(df_combined))
print(na_counts)

cat("\nIncome distribution by Year (check: same 5 levels):\n")
print(table(df_combined$Income, df_combined$Year, useNA = "ifany"))

cat("\nX_INCOMG range by Year (check: both 1-5):\n")
print(tapply(df_combined$X_INCOMG, df_combined$Year, range, na.rm = TRUE))

cat("\nRace distribution by Year:\n")
print(table(df_combined$Race, df_combined$Year, useNA = "ifany"))

cat("\nX_RACEGR range by Year (check: both 1-5):\n")
print(tapply(df_combined$X_RACEGR, df_combined$Year, range, na.rm = TRUE))

# ---------------------------------------------------------------------------
# VERDICT
# ---------------------------------------------------------------------------
cat("\n", strrep("=", 60), "\n")
cat("VERIFICATION VERDICT\n")
cat(strrep("=", 60), "\n")

row_ok <- nrow(df_combined) == 737799
year_ok <- all(table(df_combined$Year) == c(`2014` = 431877, `2022` = 305922))
target_ok <- sum(is.na(df_combined$Diabetes_Binary)) == 0
cols_ok <- length(cols_only_2014) == 0 && length(cols_only_2022) == 0
income_ok <- max(df_combined$X_INCOMG, na.rm = TRUE) <= 5
income_lvl_ok <- all(
  df_combined$Income[!is.na(df_combined$Income)] %in%
    c("<15k", "15-25k", "25-35k", "35-50k", ">50k")
)

verdict <- function(x) if (x) "PASS" else "FAIL"
cat(sprintf("[ %s ] Row count == 737,799\n", verdict(row_ok)))
cat(sprintf("[ %s ] Year breakdown matches sources\n", verdict(year_ok)))
cat(sprintf("[ %s ] Diabetes_Binary has no NAs\n", verdict(target_ok)))
cat(sprintf("[ %s ] Column names identical across years\n", verdict(cols_ok)))
cat(sprintf("[ %s ] X_INCOMG max <= 5 (income recoded)\n", verdict(income_ok)))
cat(sprintf("[ %s ] Income character levels == 5\n", verdict(income_lvl_ok)))

all_pass <- all(c(row_ok, year_ok, target_ok, cols_ok, income_ok, income_lvl_ok))
cat("\n")
if (all_pass) {
  cat("OVERALL: PASS — Combined dataset verified.\n\n")

  # ---------------------------------------------------------------------------
  # STEP 7 — Save to processed/
  # ---------------------------------------------------------------------------
  out_path <- paste0(PATH_PROC, "combined_verified.csv")
  write.csv(df_combined, out_path, row.names = FALSE)
  cat(sprintf("Saved to: %s\n", out_path))
  cat(sprintf(
    "Final dimensions: %d rows x %d cols\n",
    nrow(df_combined), ncol(df_combined)
  ))
} else {
  cat("OVERALL: FAIL — Do not use this combined dataset.\n")
  cat("Review FAIL checks above and fix before saving.\n")
}

cat("\nHarmonization complete.\n")
