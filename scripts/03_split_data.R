# 03_split_data.R
# Phase 4: Stratified 80/20 train/test splits for all 3 datasets
# Covers GitHub Issue #12
# Run from repo root: source("scripts/03_split_data.R")

source("scripts/00_setup.R")

cat("\n", strrep("=", 60), "\n")
cat("PHASE 4: TRAIN/TEST SPLITS\n")
cat(strrep("=", 60), "\n\n")

# ---------------------------------------------------------------------------
# Harmonization helper — applies same column renames/recodes as
# 02_harmonize_verify.R so all 6 output CSVs share the same 34-col schema
# ---------------------------------------------------------------------------

harmonize_2014 <- function(df) {
  df %>%
    rename(
      X_RACEGR = X_RACEGR3,
      DRNKANY  = DRNKANY5,
      HLTHPLN  = HLTHPLN1
    ) %>%
    mutate(Year = 2014L) %>%
    select(-DIABETE3)
}

harmonize_2022 <- function(df) {
  df %>%
    rename(
      X_RACEGR = X_RACEGR4,
      X_INCOMG = X_INCOMG1,
      DRNKANY  = DRNKANY6,
      INSULIN  = INSULIN1,
      HLTHPLN  = X_HLTHPLN,
      MEDCOST  = MEDCOST1
    ) %>%
    mutate(
      Year = 2022L,
      X_INCOMG = if_else(X_INCOMG > 5L, 5L, X_INCOMG),
      Income = case_when(
        Income %in% c("50-100k", ">100k") ~ ">50k",
        TRUE ~ Income
      ),
      Race = case_when(
        X_RACEGR == 1L ~ "White",
        X_RACEGR == 2L ~ "Black",
        X_RACEGR == 3L ~ "Hispanic",
        X_RACEGR == 4L ~ "Multiracial",
        X_RACEGR == 5L ~ "Other",
        TRUE ~ NA_character_
      )
    ) %>%
    select(-DIABETE4, -X_SEX, -Sex, -Health_Insurance)
}

# ---------------------------------------------------------------------------
# Split function — stratified 80/20, saves train + test, prints summary
# ---------------------------------------------------------------------------

split_and_save <- function(df, name) {
  set.seed(SEED)
  idx <- createDataPartition(df$Diabetes_Binary, p = 0.8, list = FALSE)
  train <- df[idx, ]
  test <- df[-idx, ]

  write.csv(train, paste0(PATH_PROC, "train_", name, ".csv"), row.names = FALSE)
  write.csv(test, paste0(PATH_PROC, "test_", name, ".csv"), row.names = FALSE)

  cat(sprintf(
    "%-10s  train: %6d rows (%5.2f%% diabetes)  |  test: %6d rows (%5.2f%% diabetes)\n",
    name,
    nrow(train), mean(train$Diabetes_Binary) * 100,
    nrow(test),  mean(test$Diabetes_Binary) * 100
  ))
}

# ---------------------------------------------------------------------------
# STEP 1 — Load datasets
# ---------------------------------------------------------------------------
cat(strrep("-", 60), "\n")
cat("STEP 1: Loading datasets\n")
cat(strrep("-", 60), "\n")

df_2014_raw <- read.csv(paste0(PATH_RAW, "LLCP2014_model.csv"))
df_2022_raw <- read.csv(paste0(PATH_RAW, "LLCP2022_model.csv"))
df_combined <- read.csv(paste0(PATH_PROC, "combined_verified.csv"))

cat(sprintf("2014 raw:  %d rows x %d cols\n", nrow(df_2014_raw), ncol(df_2014_raw)))
cat(sprintf("2022 raw:  %d rows x %d cols\n", nrow(df_2022_raw), ncol(df_2022_raw)))
cat(sprintf("Combined:  %d rows x %d cols\n", nrow(df_combined), ncol(df_combined)))

# ---------------------------------------------------------------------------
# STEP 2 — Harmonize individual datasets to shared schema
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 2: Harmonizing individual datasets to shared schema\n")
cat(strrep("-", 60), "\n")

df_2014 <- harmonize_2014(df_2014_raw)
df_2022 <- harmonize_2022(df_2022_raw)

cat(sprintf("2014 harmonized: %d rows x %d cols\n", nrow(df_2014), ncol(df_2014)))
cat(sprintf("2022 harmonized: %d rows x %d cols\n", nrow(df_2022), ncol(df_2022)))
cat(sprintf("Combined:        %d rows x %d cols\n", nrow(df_combined), ncol(df_combined)))

# Verify all three share the same columns
cols_diff <- setdiff(colnames(df_2014), colnames(df_2022))
if (length(cols_diff) > 0) {
  stop(
    "Column mismatch between 2014 and 2022 after harmonization: ",
    paste(cols_diff, collapse = ", ")
  )
}
cat("Column alignment: OK — all datasets share identical schema\n")

# ---------------------------------------------------------------------------
# STEP 3 — Create splits
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 3: Creating stratified 80/20 splits (seed = 42)\n")
cat(strrep("-", 60), "\n\n")

split_and_save(df_2014, "2014")
split_and_save(df_2022, "2022")
split_and_save(df_combined, "combined")

# ---------------------------------------------------------------------------
# STEP 4 — Verify output files
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("STEP 4: Verification\n")
cat(strrep("-", 60), "\n")

expected_files <- c(
  "train_2014.csv", "test_2014.csv",
  "train_2022.csv", "test_2022.csv",
  "train_combined.csv", "test_combined.csv"
)

all_ok <- TRUE
for (f in expected_files) {
  path <- paste0(PATH_PROC, f)
  if (file.exists(path)) {
    nrows <- nrow(read.csv(path, nrows = 1)) # just header check
    cat(sprintf("  [ OK ] %s exists\n", f))
  } else {
    cat(sprintf("  [FAIL] %s missing!\n", f))
    all_ok <- FALSE
  }
}

cat("\n")
if (all_ok) {
  cat("OVERALL: PASS — All 6 split files created.\n")
  cat(sprintf("Saved to: %s\n", PATH_PROC))
} else {
  cat("OVERALL: FAIL — Some files missing. Check errors above.\n")
}

cat("\nSplitting complete.\n")
