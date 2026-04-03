# data/raw/

This directory holds the raw source CSV files. **All files here are gitignored** and must be obtained separately.

## Required files

| File | Rows | Size (approx) | Source |
|------|------|---------------|--------|
| `LLCP2014_model.csv` | 431,877 | ~58 MB | CDC BRFSS 2014 via UCI ML Repository (cleaned) |
| `LLCP2022_model.csv` | 305,922 | ~43 MB | CDC BRFSS 2022 raw survey (cleaned by team) |
| `LLCP_combined.csv`  | 737,799 | ~57 MB | Previous partial harmonization — **do not use for modeling** |

## How to obtain

Contact Raj Laskar (team Data & Infrastructure Lead) for access to these files, or download from the shared team Google Drive folder.

> Do NOT commit these files to git. They are listed in `.gitignore` under `data/raw/*`.

## After placing files

Run scripts in order from the repo root:

```r
source("scripts/00_setup.R")   # loads packages and config
source("scripts/01_data_audit.R")        # Phase 1: audit all three files
source("scripts/02_harmonize_verify.R")  # Phase 2: rebuild combined dataset
source("scripts/03_split_data.R")        # Phase 4: train/test splits
```
