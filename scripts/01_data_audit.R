# 01_data_audit.R
# Phase 1: Data Audit — 2014, 2022, and Combined Datasets
# Covers GitHub Issues #4, #5, #6
# Run from repo root: source("scripts/01_data_audit.R")

source("scripts/00_setup.R")

cat("\n", strrep("=", 60), "\n")
cat("PHASE 1: DATA AUDIT\n")
cat(strrep("=", 60), "\n\n")

# ---------------------------------------------------------------------------
# BLOCK 1 — Load and inspect 2014 structure (Issue #4)
# ---------------------------------------------------------------------------
cat(strrep("-", 60), "\n")
cat("BLOCK 1: 2014 Dataset — Structure\n")
cat(strrep("-", 60), "\n")

df_2014 <- read.csv(paste0(PATH_RAW, "LLCP2014_model.csv"))

cat("Dimensions (rows x cols):\n")
print(dim(df_2014))

cat("\nColumn names:\n")
print(colnames(df_2014))

cat("\nColumn data types:\n")
print(sapply(df_2014, class))

# ---------------------------------------------------------------------------
# BLOCK 2 — 2014 target distribution, missing values, value ranges (Issue #4)
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("BLOCK 2: 2014 Dataset — Target, NAs, Value Ranges\n")
cat(strrep("-", 60), "\n")

cat("\nFirst 6 rows:\n")
print(head(df_2014))

cat("\nTarget variable (Diabetes_Binary) counts:\n")
print(table(df_2014$Diabetes_Binary))

cat("\nTarget variable proportions:\n")
print(round(prop.table(table(df_2014$Diabetes_Binary)), 4))

cat("\nMissing values per column:\n")
print(colSums(is.na(df_2014)))

cat("\nNumeric column ranges:\n")
print(sapply(df_2014 |> select(where(is.numeric)), range, na.rm = TRUE))

cat("\nNon-numeric column unique value counts:\n")
non_numeric_2014 <- df_2014 |> select(where(~ !is.numeric(.)))
if (ncol(non_numeric_2014) > 0) {
  print(sapply(non_numeric_2014, function(x) length(unique(x))))
  cat("\nNon-numeric column sample values (first 10 unique):\n")
  print(sapply(non_numeric_2014, function(x) head(unique(x), 10)))
} else {
  cat("All columns are numeric.\n")
}

# ---------------------------------------------------------------------------
# BLOCK 3 — Load and inspect 2022 structure (Issue #5)
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("BLOCK 3: 2022 Dataset — Structure\n")
cat(strrep("-", 60), "\n")

df_2022 <- read.csv(paste0(PATH_RAW, "LLCP2022_model.csv"))

cat("Dimensions (rows x cols):\n")
print(dim(df_2022))

cat("\nColumn names:\n")
print(colnames(df_2022))

cat("\nColumn data types:\n")
print(sapply(df_2022, class))

# ---------------------------------------------------------------------------
# BLOCK 4 — 2022 target distribution, missing values, value ranges (Issue #5)
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("BLOCK 4: 2022 Dataset — Target, NAs, Value Ranges\n")
cat(strrep("-", 60), "\n")

cat("\nFirst 6 rows:\n")
print(head(df_2022))

cat("\nTarget variable (Diabetes_Binary) counts:\n")
print(table(df_2022$Diabetes_Binary))

cat("\nTarget variable proportions:\n")
print(round(prop.table(table(df_2022$Diabetes_Binary)), 4))

cat("\nMissing values per column:\n")
print(colSums(is.na(df_2022)))

cat("\nNumeric column ranges:\n")
print(sapply(df_2022 |> select(where(is.numeric)), range, na.rm = TRUE))

cat("\nNon-numeric column unique value counts:\n")
non_numeric_2022 <- df_2022 |> select(where(~ !is.numeric(.)))
if (ncol(non_numeric_2022) > 0) {
  print(sapply(non_numeric_2022, function(x) length(unique(x))))
  cat("\nNon-numeric column sample values (first 10 unique):\n")
  print(sapply(non_numeric_2022, function(x) head(unique(x), 10)))
} else {
  cat("All columns are numeric.\n")
}

# ---------------------------------------------------------------------------
# Column comparison: 2014 vs 2022 (Issue #5 — encoding differences)
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("COLUMN COMPARISON: 2014 vs 2022\n")
cat(strrep("-", 60), "\n")

cat("\nColumns in 2014 but NOT in 2022:\n")
print(setdiff(colnames(df_2014), colnames(df_2022)))

cat("\nColumns in 2022 but NOT in 2014:\n")
print(setdiff(colnames(df_2022), colnames(df_2014)))

cat("\nColumns shared by both:\n")
print(intersect(colnames(df_2014), colnames(df_2022)))

# ---------------------------------------------------------------------------
# BLOCK 5 — Load and inspect combined structure (Issue #6)
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("BLOCK 5: Combined Dataset — Structure\n")
cat(strrep("-", 60), "\n")

df_combined <- read.csv(paste0(PATH_RAW, "LLCP_combined.csv"))

cat("Dimensions (rows x cols) — expect 737799 rows:\n")
print(dim(df_combined))

cat("\nColumn names:\n")
print(colnames(df_combined))

cat("\nColumn data types:\n")
print(sapply(df_combined, class))

# ---------------------------------------------------------------------------
# BLOCK 6 — Combined dataset verification checklist (Issue #6)
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("BLOCK 6: Combined Dataset — Verification Checklist\n")
cat(strrep("-", 60), "\n")

cat("\nRow count by Year (expect 431877 for 2014, 305922 for 2022):\n")
print(table(df_combined$Year))

cat("\nMissing values per column:\n")
print(colSums(is.na(df_combined)))

cat("\nColumns in 2014 missing from combined (expect none):\n")
print(setdiff(colnames(df_2014), colnames(df_combined)))

cat("\nColumns in 2022 missing from combined (expect none):\n")
print(setdiff(colnames(df_2022), colnames(df_combined)))

cat("\nColumns in combined but not in 2014 (expect only: Year):\n")
print(setdiff(colnames(df_combined), colnames(df_2014)))

cat("\nColumns in combined but not in 2022 (expect only: Year):\n")
print(setdiff(colnames(df_combined), colnames(df_2022)))

# ---------------------------------------------------------------------------
# BLOCK 7 — Spot-check categorical encoding consistency across years (Issue #6)
# ---------------------------------------------------------------------------
cat("\n", strrep("-", 60), "\n")
cat("BLOCK 7: Categorical Encoding Spot-Checks\n")
cat(strrep("-", 60), "\n")

# Spot-check all shared columns for consistent encoding
shared_cols <- intersect(
  intersect(colnames(df_2014), colnames(df_2022)),
  colnames(df_combined)
)
shared_cols <- setdiff(shared_cols, "Diabetes_Binary") # exclude target

cat("\nUnique value counts per shared column by Year:\n")
for (col in shared_cols) {
  vals_2014 <- sort(unique(df_combined[[col]][df_combined$Year == 2014]))
  vals_2022 <- sort(unique(df_combined[[col]][df_combined$Year == 2022]))
  if (!identical(vals_2014, vals_2022)) {
    cat(sprintf(
      "  *** MISMATCH in '%s':\n    2014: %s\n    2022: %s\n",
      col,
      paste(vals_2014, collapse = ", "),
      paste(vals_2022, collapse = ", ")
    ))
  }
}
cat("Spot-check complete. Any mismatches shown above.\n")

# ---------------------------------------------------------------------------
# VERIFICATION VERDICT (Issue #6)
# ---------------------------------------------------------------------------
cat("\n", strrep("=", 60), "\n")
cat("VERIFICATION VERDICT\n")
cat(strrep("=", 60), "\n")

row_ok <- nrow(df_combined) == 737799
year_ok <- all(
  table(df_combined$Year) == c(`2014` = 431877, `2022` = 305922)
)
cols_2014 <- intersect(colnames(df_2014), colnames(df_combined))
cols_2022 <- intersect(colnames(df_2022), colnames(df_combined))
na_ok <- all(
  colSums(is.na(df_combined)) ==
    colSums(is.na(df_2014[, cols_2014])) +
      colSums(is.na(df_2022[, cols_2022]))
)
cols_2014_ok <- length(
  setdiff(colnames(df_2014), colnames(df_combined))
) == 0
cols_2022_ok <- length(
  setdiff(colnames(df_2022), colnames(df_combined))
) == 0
extra_cols <- setdiff(
  colnames(df_combined),
  union(colnames(df_2014), colnames(df_2022))
)
extra_ok <- identical(sort(extra_cols), "Year")

verdict <- function(x) if (x) "PASS" else "FAIL"
cat(sprintf("[ %s ] Row count == 737,799\n", verdict(row_ok)))
cat(sprintf("[ %s ] Year breakdown matches sources\n", verdict(year_ok)))
cat(sprintf("[ %s ] No unexpected NAs introduced\n", verdict(na_ok)))
cat(sprintf("[ %s ] No 2014 columns missing\n", verdict(cols_2014_ok)))
cat(sprintf("[ %s ] No 2022 columns missing\n", verdict(cols_2022_ok)))
cat(sprintf("[ %s ] Only 'Year' is new in combined\n", verdict(extra_ok)))

all_pass <- all(c(row_ok, year_ok, na_ok, cols_2014_ok, cols_2022_ok, extra_ok))
cat("\n")
if (all_pass) {
  cat("OVERALL: PASS — Combined dataset verified.\n")
  cat("Proceed to Phase 2: copy to data/processed/.\n")
} else {
  cat("OVERALL: FAIL — Combined dataset needs rebuilding.\n")
  cat("Proceed to 02_harmonize_verify.R.\n")
}

cat("\nAudit complete.\n")
