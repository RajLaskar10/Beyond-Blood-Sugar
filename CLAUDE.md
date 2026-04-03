# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Response Format

**ALWAYS** start every response with ⭐ and end every response with 😊. No exceptions.

## Project Overview

**Beyond Blood Sugar** investigates how lifestyle and demographic predictors of diabetes risk changed between 2014 and 2022 using CDC BRFSS data. The core contribution is the **temporal comparison (Phase 7)** — singled out by the professor as the most intellectually important part.

- **Deadline:** April 16, 2026
- **Language:** R (RStudio project, `DS5110_Diabetes_Project.Rproj`)
- **GitHub:** https://github.com/RajLaskar10/Beyond-Blood-Sugar

## Team Roles

@docs/team_roles.md

## Running Scripts

All scripts must begin with:
```r
source("scripts/00_setup.R")
```

Scripts are numbered and must be executed in order (`01_` → `10_`). Run from the repo root so relative paths resolve correctly.

To knit the final report (once `report/final_report.Rmd` exists):
```r
rmarkdown::render("report/final_report.Rmd")
```

## Architecture

```
scripts/00_setup.R       ← Central config: paths, seed, colors, packages
data/raw/                ← LLCP2014_model.csv, LLCP2022_model.csv, LLCP_combined.csv (gitignored)
data/processed/          ← Output of harmonization & train/test splits
outputs/figures/         ← PNGs at 300 DPI
outputs/tables/          ← CSVs (model comparisons, coefficient tables)
outputs/models/          ← .rds model objects (gitignored)
report/                  ← final_report.Rmd → PDF
docs/                    ← Detailed reference files (imported below)
```

**Path variables** (defined in `00_setup.R`, use these — no hardcoded paths ever):
```r
PATH_RAW    <- "data/raw/"
PATH_PROC   <- "data/processed/"
PATH_FIG    <- "outputs/figures/"
PATH_TABLES <- "outputs/tables/"
PATH_MODELS <- "outputs/models/"
SEED        <- 42
```

**Color palette** (defined in `00_setup.R`):
```r
COLOR_DIABETES <- "#E07A5F"   # diabetic
COLOR_NO_DIAB  <- "#81B29A"   # non-diabetic
COLOR_2014     <- "#3D405B"   # 2014 data
COLOR_2022     <- "#F2CC8F"   # 2022 data
```

## Datasets & Verification

@docs/datasets_and_verification.md

## Coding Standards

- **Style:** Tidyverse (snake_case, pipes, dplyr verbs)
- **Functions:** `verb_noun()` format (e.g., `compute_metrics()`, `plot_feature_importance()`)
- **Models saved as:** `<model>_<dataset>.rds` (e.g., `rf_2014.rds`, `lr_combined.rds`)
- **Figures saved as:** descriptive snake_case PNG (e.g., `fig_bmi_distribution_2014.png`), 300 DPI via `ggsave()`
- Always set seed via `set.seed(SEED)` (SEED=42 from setup.R)
- All libraries loaded in `00_setup.R` only — do not add `library()` calls in analysis scripts
- Use `theme_minimal()` as base ggplot theme; always include axis labels, titles, and legends

## Git Workflow

- **Never commit directly to `main`** — use feature branches
- **Branch naming:** `<owner>/<phase>-<short-description>` (e.g., `raj/phase1-data-audit`)
- **Commit format:** `[Phase X] Short description` (e.g., `[Phase 1] Add data audit script`)
- **PR checklist:** code runs, no hardcoded paths, outputs go to correct directories, no large data files committed

## Git Commits

- Never add Claude as a co-author
- Never include `Co-authored-by:` lines for Claude or any AI tool
- Commit messages should contain only the human author's identity

## Execution Phases

@docs/execution_phases.md

## Technical Reference (Code Skeletons)

@docs/technical_workflow.md

## GitHub Issues & Project Board

@docs/github_issues.md

## Risks & Definition of Done

@docs/risks_and_done.md

## Key Notes

- **Phase 7 is the priority**: temporal comparison of 2014 vs 2022 feature importance and LR coefficients — allocate the most time and polish here.
- **Combined dataset is unverified**: Phase 1 must confirm row counts, encoding consistency, and harmonization before any modeling uses it.
- **Class imbalance strategy**: prefer class weights over SMOTE; finalize approach after the professor's upcoming lecture on resampling.
- **PROJECT_PLAN.md** is the human-readable source of truth and is not modified — the `docs/` files above are topic extracts imported here for Claude's use.
