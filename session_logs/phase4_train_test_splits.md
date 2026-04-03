# Session Log — Phase 4: Train/Test Splits

**Date:** 2026-04-03
**Owner:** Raj Laskar
**Issue closed:** #12
**Script:** `scripts/03_split_data.R`

---

## What was done

Created stratified 80/20 train/test splits for all 3 datasets using `caret::createDataPartition()` with `set.seed(42)`. All 6 CSVs saved to `data/processed/`.

---

## Split results

| Dataset | Train | Train % diabetes | Test | Test % diabetes |
|---------|-------|-----------------|------|----------------|
| 2014 | 345,502 | 13.98% | 86,375 | 14.22% |
| 2022 | 244,738 | 15.32% | 61,184 | 15.03% |
| Combined | 590,240 | 14.51% | 147,559 | 14.66% |

Stratification is working — class proportions are consistent across splits.

---

## Schema note

All 6 files use the **same 34-column harmonized schema** as `combined_verified.csv`. The `03_split_data.R` script applies the same harmonization as `02_harmonize_verify.R` to the raw 2014/2022 CSVs before splitting, so Gaurav's modeling scripts can load any of the 6 files without additional column handling.

---

## For teammates

**Gaurav:** All 6 train/test CSVs are ready in `data/processed/`. To regenerate them:
```r
source("scripts/00_setup.R")
source("scripts/02_harmonize_verify.R")  # creates combined_verified.csv first
source("scripts/03_split_data.R")        # creates all 6 splits
```

You can now proceed with Issue #13 (class imbalance strategy) and Issues #14–19 (model training). Load splits like:
```r
train_2014 <- read.csv(paste0(PATH_PROC, "train_2014.csv"))
test_2014  <- read.csv(paste0(PATH_PROC, "test_2014.csv"))
```

**Namya:** EDA issues #9–11 are unblocked (were unblocked since #8). Use `data/raw/LLCP2014_model.csv`, `data/raw/LLCP2022_model.csv`, or `data/processed/combined_verified.csv`.

---

## Raj's issues — all done

| Issue | Phase | Status |
|-------|-------|--------|
| #1–3 | Phase 0 | ✅ Done (repo setup) |
| #4 | Phase 1 | ✅ Done (2014 audit) |
| #5 | Phase 1 | ✅ Done (2022 audit) |
| #6 | Phase 1 | ✅ Done (combined verification) |
| #7 | Phase 1 | ✅ Done (data dictionary) |
| #8 | Phase 2 | ✅ Done (harmonization) |
| #12 | Phase 4 | ✅ Done (train/test splits) |

Remaining Raj issues: #24 (temporal comparison narrative — Phase 7, depends on Gaurav/Namya finishing first), #29/#32/#33 (Phase 9 report).
