# Beyond Blood Sugar: Predicting Diabetes Risk

This repository contains the analysis codebase for investigating how lifestyle and demographic predictors of diabetes risk have changed between 2014 and 2022 using CDC BRFSS data.

## Project Structure
- `data/raw/`: Original CSVs (ignored by git). Place `LLCP2014_model.csv`, `LLCP2022_model.csv`, and `LLCP_combined.csv` here.
- `data/processed/`: Cleaned and harmonized datasets.
- `scripts/`: R scripts for data processing, EDA, and modeling.
- `outputs/`: Generated figures, tables, and saved models.
- `report/`: Final knittable RMarkdown report.
- `presentation/`: Slides for project presentation.

## Setup Instructions

1. **Clone the repository**:
   ```bash
   git clone <repo_url>
   cd beyond-blood-sugar
   ```

2. **Add Raw Data**:
   Ensure `LLCP2014_model.csv`, `LLCP2022_model.csv`, and `LLCP_combined.csv` are placed strictly inside the `data/raw/` directory. These files are not tracked by version control.

3. **Install Dependencies & Load Environment**:
   Before running any script, ensure you run `scripts/00_setup.R`. It will automatically install any missing packages.
   ```r
   source("scripts/00_setup.R")
   ```

## Script Execution Order (Phases)
Scripts should be executed in numerical order:
1. `01_data_audit.R` - Audit source datasets
2. `02_harmonize_verify.R` - Re-harmonize datasets
3. `03_eda.R` - Exploratory Data Analysis
... (and so on up to 10)
