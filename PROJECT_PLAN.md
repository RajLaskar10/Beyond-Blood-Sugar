# Beyond Blood Sugar — Project Execution Plan

**Project:** Uncovering Lifestyle and Demographic Drivers of Diabetes Risk Across the U.S.
**Team:** Raj Laskar, Gaurav Bidani, Namya Singh
**Deadline:** April 16, 2026
**Deliverables:** Final Report, Presentation, Codebase

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Research Questions](#2-research-questions)
3. [Datasets](#3-datasets)
4. [Success Criteria](#4-success-criteria)
5. [Team Roles & Ownership](#5-team-roles--ownership)
6. [Repository Structure](#6-repository-structure)
7. [Git Workflow & Conventions](#7-git-workflow--conventions)
8. [Coding Standards](#8-coding-standards)
9. [Execution Phases](#9-execution-phases)
10. [GitHub Issues Plan](#10-github-issues-plan)
11. [GitHub Project Board](#11-github-project-board)
12. [Technical Workflow Detail](#12-technical-workflow-detail)
13. [Risks & Mitigation](#13-risks--mitigation)
14. [Definition of Done](#14-definition-of-done)

---

## 1. Project Overview

This project investigates how lifestyle and demographic predictors of diabetes risk have changed between 2014 and 2022 using two waves of the CDC Behavioral Risk Factor Surveillance System (BRFSS). The central goal is **not** just prediction — it is the **temporal comparison** of which factors matter, how much they matter, and whether demographic disparities have widened or narrowed over eight years.

We train logistic regression and random forest models independently on each year, then on a combined dataset, and compare feature importance, model performance, and subgroup-level patterns across time.

---

## 2. Research Questions

1. **Within-year prediction:** Which lifestyle and demographic factors best predict diabetes status in 2014? In 2022?
2. **Subgroup disparities:** Do diabetes risk profiles differ by income, education, age, and race — and have those disparities changed between 2014 and 2022?
3. **Temporal shift:** How have the most important predictors of diabetes risk changed between 2014 and 2022, and does a combined model with `Year` as a feature capture meaningful temporal signal?

---

## 3. Datasets

| Property | 2014 BRFSS | 2022 BRFSS | Combined |
|----------|-----------|-----------|----------|
| Source | CDC BRFSS via UCI ML Repository | CDC BRFSS (raw, cleaned by team) | Row-bind of both |
| Rows | 431,877 | 305,922 | 737,799 |
| Shared features | 20 (after harmonization) | 20 (after harmonization) | 20 + `Year` |
| Diabetes prevalence | ~14% | ~15.3% | ~14.5% (estimated) |
| Status | Cleaned | Cleaned | **Exists but UNVERIFIED** |

### Critical note on the combined dataset

A combined CSV exists but has **not been verified** for correct harmonization. Before any modeling on the combined data, the team must run the verification steps in Phase 1 to confirm:
- Column names are identical across both source datasets
- Categorical encodings (income tiers, education levels, age groups, race categories) use the same values
- No NAs were introduced during the join
- Row count equals 431,877 + 305,922 = 737,799 exactly

If verification fails, the combined dataset must be rebuilt from scratch using the harmonization script.

---

## 4. Success Criteria

The project is complete when all of the following are true:

- [ ] All 6 models trained and evaluated (LR + RF × 3 datasets)
- [ ] AUC-ROC, F1, precision, and recall reported for every model on held-out test sets
- [ ] Feature importance rankings extracted and compared across 2014 vs. 2022
- [ ] Subgroup analysis completed for at least 4 dimensions (income, education, age, race)
- [ ] At least 8 publication-quality figures produced
- [ ] Final report submitted as a cohesive document with all team members contributing
- [ ] Presentation slides ready and rehearsed
- [ ] All code is reproducible: a teammate can clone the repo, set the data path, and rerun everything

---

## 5. Team Roles & Ownership

### Raj Laskar — Data & Infrastructure Lead

**Owns:** Repository setup, data loading scripts, harmonization verification, combined dataset validation, train/test splitting, class imbalance handling, data pipeline reproducibility.

**Writes in final report:** Data description, cleaning methodology, harmonization process, train/test split rationale, class imbalance approach.

### Gaurav Bidani — Modeling Lead

**Owns:** Logistic regression and random forest training scripts, hyperparameter tuning, evaluation metric computation, model comparison tables, model object storage.

**Writes in final report:** Modeling methodology, hyperparameter choices, evaluation results, model comparison discussion.

### Namya Singh — Analysis & Visualization Lead

**Owns:** EDA visualizations, feature importance comparison plots, subgroup analysis code, temporal comparison figures, all final figures for report and presentation.

**Writes in final report:** EDA findings, feature importance analysis, subgroup analysis results, temporal comparison narrative, all figure captions.

### Shared responsibilities (all three)

- Code review on PRs
- Final report editing and proofreading
- Presentation preparation and rehearsal
- GitHub Issue updates and board maintenance

---

## 6. Repository Structure

```
beyond-blood-sugar/
├── README.md                    # Setup instructions, data path config, how to run
├── .gitignore                   # Ignore data/raw/*, .Rhistory, .RData, outputs/models/*.rds
├── PROJECT_PLAN.md              # This document
│
├── data/
│   ├── raw/                     # Original CSVs — GITIGNORED, shared via Google Drive
│   │   ├── LLCP2014_model.csv
│   │   ├── LLCP2022_model.csv
│   │   └── LLCP_combined.csv    # Unverified — will be rebuilt if verification fails
│   ├── processed/               # Verified harmonized datasets, split indices
│   │   ├── combined_verified.csv
│   │   ├── train_2014.csv
│   │   ├── test_2014.csv
│   │   ├── train_2022.csv
│   │   ├── test_2022.csv
│   │   ├── train_combined.csv
│   │   └── test_combined.csv
│   └── data_dictionary.md       # Column definitions, encodings, value labels
│
├── scripts/
│   ├── 00_setup.R               # Libraries, paths, constants, seed
│   ├── 01_data_audit.R          # Inspection commands for both datasets
│   ├── 02_harmonize_verify.R    # Verify combined dataset OR rebuild it
│   ├── 03_eda.R                 # All EDA visualizations
│   ├── 04_split_balance.R       # Train/test split, class imbalance handling
│   ├── 05_model_logistic.R      # Logistic regression (all 3 datasets)
│   ├── 06_model_rf.R            # Random forest (all 3 datasets)
│   ├── 07_evaluate.R            # Metrics computation, comparison tables
│   ├── 08_feature_importance.R  # Extraction and cross-year comparison
│   ├── 09_subgroup_analysis.R   # Stratified analysis by income/edu/age/race
│   └── 10_temporal_comparison.R # Synthesis of cross-year findings
│
├── outputs/
│   ├── figures/                 # Saved plots (PNG at 300 DPI)
│   ├── tables/                  # Model comparison CSVs, subgroup tables
│   └── models/                  # Saved model objects (.rds)
│
├── report/
│   └── final_report.Rmd         # Knittable final report
│
├── presentation/
│   └── slides.Rmd               # Or .pptx
│
└── docs/
    └── proposal.pdf             # Submitted proposal
```

---

## 7. Git Workflow & Conventions

### Branching strategy

Use a simple **feature-branch workflow**:

- `main` — Always stable, working code. Never commit directly to `main`.
- Feature branches — All work happens on branches named with the convention below.

### Branch naming convention

Format: `<owner>/<phase>-<short-description>`

Examples:
- `raj/phase1-data-audit`
- `gaurav/phase4-logistic-2014`
- `namya/phase3-eda-bmi-plots`
- `raj/phase2-harmonize-verify`

### Commit message convention

Format: `[Phase X] Short description of what changed`

Examples:
- `[Phase 1] Add data audit script for 2014 dataset`
- `[Phase 4] Train logistic regression on 2022 data`
- `[Phase 3] Add side-by-side BMI distribution plot`
- `[Fix] Correct income tier encoding in harmonization`

Avoid vague messages like "update code" or "fix stuff."

### Pull request workflow

1. Create a feature branch from `main`.
2. Do your work. Commit often with clear messages.
3. Push the branch and open a PR.
4. PR title should match the GitHub Issue it closes (e.g., "Closes #5: Harmonize column names and encodings").
5. Assign **one other team member** as reviewer.
6. Reviewer checks: does the code run? Does the output look correct? Are there any hardcoded paths?
7. After approval, the **author** merges and deletes the branch.

### PR review checklist

Before approving a PR, the reviewer should check:
- [ ] Code runs without errors after pulling the branch
- [ ] No hardcoded file paths (all paths use variables from `00_setup.R`)
- [ ] Output files are saved to the correct `outputs/` subdirectory
- [ ] No large data files accidentally committed
- [ ] Commit messages are clear

---

## 8. Coding Standards

### General rules

- **Every script starts** by sourcing `00_setup.R`:
  ```r
  source("scripts/00_setup.R")
  ```
- **No hardcoded file paths.** Define all paths in `00_setup.R`:
  ```r
  PATH_RAW    <- "data/raw/"
  PATH_PROC   <- "data/processed/"
  PATH_FIG    <- "outputs/figures/"
  PATH_TABLES <- "outputs/tables/"
  PATH_MODELS <- "outputs/models/"
  SEED        <- 42
  ```
- **Set seed before any random operation:**
  ```r
  set.seed(SEED)
  ```
- **Use tidyverse style** (snake_case variable names, pipe operators, `dplyr` verbs).
- **Comment non-obvious logic.** You do not need to comment every line, but explain *why* when the *what* is not self-evident.

### Naming conventions

| Type | Convention | Example |
|------|-----------|---------|
| Variables | snake_case | `train_2014`, `auc_rf_combined` |
| Functions | snake_case with verb prefix | `compute_metrics()`, `plot_feature_importance()` |
| File names | numbered prefix + snake_case | `05_model_logistic.R` |
| Saved figures | descriptive snake_case | `fig_bmi_distribution_2014.png` |
| Saved models | model_type_dataset.rds | `rf_2014.rds`, `lr_combined.rds` |

### Library management

All libraries are loaded in `00_setup.R` and nowhere else. The required packages are:

```r
library(tidyverse)    # data manipulation and ggplot2
library(caret)        # train/test split, cross-validation, confusionMatrix
library(ranger)       # fast random forest (NOT randomForest)
library(pROC)         # AUC-ROC computation
library(vip)          # permutation-based feature importance
library(ROSE)         # class imbalance handling (or smotefamily)
library(corrplot)     # correlation heatmaps (if needed beyond ggplot)
library(scales)       # label formatting in ggplot
library(knitr)        # tables in Rmd
library(kableExtra)   # styled tables in Rmd
```

Use `ranger` instead of `randomForest` — your datasets are 300K–430K rows and `randomForest` will be unacceptably slow.

### Figure standards

- Save all figures as PNG at 300 DPI using `ggsave()`:
  ```r
  ggsave(paste0(PATH_FIG, "fig_name.png"), width = 10, height = 6, dpi = 300)
  ```
- Use a consistent color palette across all plots. Define it in `00_setup.R`:
  ```r
  COLOR_DIABETES  <- "#E07A5F"  # coral/red for diabetic
  COLOR_NO_DIAB   <- "#81B29A"  # teal/green for non-diabetic
  COLOR_2014      <- "#3D405B"  # dark blue-gray for 2014
  COLOR_2022      <- "#F2CC8F"  # warm gold for 2022
  ```
- Always include clear axis labels, titles, and legends. Never use default R plot titles.
- Use `theme_minimal()` as the base theme.

---

## 9. Execution Phases

### Phase 0 — Project Setup

**Owner:** Raj
**What:** Create GitHub repo, folder structure, `.gitignore`, `README.md`, `00_setup.R`, add this plan as `PROJECT_PLAN.md`, create the GitHub Project Board, create all Issues.
**Output:** Working repo that all 3 team members can clone and run `00_setup.R` without errors.

### Phase 1 — Data Audit & Combined Dataset Verification

**Owner:** Raj
**What:** Load all three CSVs (2014, 2022, combined). Run the audit commands listed in Section 12. Document column names, types, value ranges, missing values, and class distributions. Verify the combined dataset by checking column alignment, encoding consistency, row counts, and absence of spurious NAs.
**Output:** Completed `01_data_audit.R`, a filled-in `data_dictionary.md`, and a written verification report (as an Issue comment) on whether the combined dataset is valid or needs rebuilding.

**Parallel work while this runs:**
- Gaurav can set up the modeling script skeleton (`05_model_logistic.R`, `06_model_rf.R`) with placeholder functions.
- Namya can begin extended EDA on the individual 2014 and 2022 datasets.

### Phase 2 — Harmonization (if needed)

**Owner:** Raj
**What:** If Phase 1 reveals problems with the combined dataset, write `02_harmonize_verify.R` to: rename mismatched columns, recode inconsistent categorical levels (especially income tiers — `_INCOMG` vs `_INCOMG1`), add the `Year` column, row-bind, and validate. If verification passes, skip to saving the verified combined file.
**Output:** `data/processed/combined_verified.csv` that passes all validation checks.

### Phase 3 — Extended EDA

**Owner:** Namya (primary), with input from Raj and Gaurav
**What:** Go beyond the existing correlation heatmaps and BMI histograms. Produce:
- Side-by-side bar charts for each categorical feature vs. diabetes prevalence, split by year
- BMI × age group interaction plots by diabetes status
- Income × diabetes prevalence by year
- Education × diabetes prevalence by year
- Race × diabetes prevalence by year
- Correlation heatmap comparison (2014 vs. 2022 side by side)
**Output:** At least 8–10 figures saved to `outputs/figures/`, and a summary of EDA findings written as Issue comments.

### Phase 4 — Train/Test Split & Class Imbalance

**Owner:** Raj (split), Gaurav (imbalance strategy)
**What:**
- Create 80/20 stratified train/test splits for 2014, 2022, and combined datasets using `caret::createDataPartition()` with `set.seed(42)`.
- Save all 6 files (train + test × 3 datasets) to `data/processed/`.
- Decide on class imbalance handling: class weights in the model (preferred for `ranger`) vs. SMOTE on training data. Document rationale.
- Apply imbalance handling to training sets only. **Never touch test sets.**
**Output:** 6 CSV files in `data/processed/`, a documented imbalance strategy.

### Phase 5 — Model Training

**Owner:** Gaurav
**What:**
- Train logistic regression (`glm`, `family = "binomial"`) on train_2014, train_2022, train_combined.
- Train random forest (`ranger`) on the same three training sets.
- For random forest: tune `num.trees`, `mtry`, and `min.node.size` using 5-fold CV via `caret::trainControl()`.
- Save all 6 trained model objects as `.rds` to `outputs/models/`.
**Output:** 6 model `.rds` files, tuning results logged.

### Phase 6 — Evaluation

**Owner:** Gaurav
**What:**
- Predict on all 6 test sets.
- Compute AUC-ROC (via `pROC::roc()`), F1, precision, recall (via `caret::confusionMatrix()`).
- Create a single comparison table with all metrics across all 6 models.
- Plot ROC curves (overlaid by year for same model type).
**Output:** `outputs/tables/model_comparison.csv`, ROC curve figures.

### Phase 7 — Feature Importance & Temporal Comparison

**Owner:** Namya (plots), Gaurav (extraction)
**What:**
- Extract permutation-based feature importance from all 6 models using the `vip` package. This ensures comparable importance scores across LR and RF.
- Create side-by-side importance plots: 2014 vs. 2022 for each model type.
- Identify features that rose or fell in importance across years.
- Write the narrative interpretation of what changed.
**Output:** Feature importance plots, a ranked comparison table, written interpretation.

### Phase 8 — Subgroup Analysis

**Owner:** Namya
**What:**
- For each of 4 dimensions (income, education, age, race):
  - Compute diabetes prevalence by subgroup × year.
  - Compute model performance metrics by subgroup (if subgroup sizes permit — minimum ~500 diabetic cases per subgroup).
  - Create visualizations showing how disparities changed.
- Flag any subgroups with insufficient sample size and note the limitation.
**Output:** Subgroup prevalence tables, disparity comparison plots, written findings.

### Phase 9 — Deliverables

**Owner:** All three
**What:**
- Raj writes: data and infrastructure sections of the report.
- Gaurav writes: modeling methodology and results sections.
- Namya writes: EDA, feature importance, and subgroup analysis sections.
- One person assembles the full `final_report.Rmd` and knits it.
- Build presentation slides covering: motivation, data, methods, key results (feature importance shifts, subgroup disparities), and conclusions.
- Rehearse the presentation.
**Output:** Final report (PDF from Rmd), presentation slides.

---

## 10. GitHub Issues Plan

All issues listed below should be created in the GitHub repo. Use the labels and dependencies to manage sequencing.

### Labels

Create these labels in the repo:
- `phase-0` through `phase-9` — for phase tracking
- `data` — data loading, cleaning, harmonization
- `modeling` — model training, tuning, evaluation
- `analysis` — EDA, feature importance, subgroup analysis
- `visualization` — plot creation
- `deliverable` — report, presentation
- `infra` — repo setup, tooling
- `blocked` — waiting on a dependency

### Issue list

**Phase 0**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 1 | Create repo, folder structure, .gitignore, README | Raj | `phase-0`, `infra` | — | Set up the full repo structure per Section 6. Add `.gitignore` for `data/raw/*`, `.Rhistory`, `.RData`, `outputs/models/*.rds`. README should include: project description, how to clone, how to set up data paths, how to run scripts in order. |
| 2 | Create 00_setup.R with shared config | Raj | `phase-0`, `infra` | #1 | Define all path variables, seed, color palette, and load all required libraries per Section 8. |
| 3 | Create GitHub Project Board and Issues | Raj | `phase-0`, `infra` | #1 | Create the board with columns per Section 11. Create all issues from this table. |

**Phase 1**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 4 | Data audit: 2014 dataset | Raj | `phase-1`, `data` | #2 | Run all audit commands from Section 12 on the 2014 CSV. Post results as a comment on this issue. Document column names, types, value ranges, NAs, and target distribution. |
| 5 | Data audit: 2022 dataset | Raj | `phase-1`, `data` | #2 | Same as #4 for the 2022 dataset. Pay special attention to column name differences (e.g., `_INCOMG` vs `_INCOMG1`, presence/absence of `_SEX`). |
| 6 | Data audit: combined dataset | Raj | `phase-1`, `data` | #4, #5 | Verify the existing combined CSV: check row count = 737,799, check `table(Year)` matches source counts, compare `colnames()` across all three files, check for NAs introduced by the join. Post pass/fail verdict. |
| 7 | Create data_dictionary.md | Raj | `phase-1`, `data` | #4, #5 | Document every column: name, type, allowed values, description, and any notes about encoding differences between years. |

**Phase 2**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 8 | Harmonize and verify combined dataset | Raj | `phase-2`, `data` | #6 | If #6 failed verification: write `02_harmonize_verify.R` to rename columns, align encodings, add `Year`, row-bind, and validate. If #6 passed: document that verification passed and copy the file to `data/processed/combined_verified.csv`. |

**Phase 3**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 9 | EDA: univariate feature distributions by year | Namya | `phase-3`, `analysis`, `visualization` | #8 | Side-by-side bar charts for every categorical feature, split by diabetes status, faceted or grouped by year. Save to `outputs/figures/`. |
| 10 | EDA: bivariate interaction plots | Namya | `phase-3`, `analysis`, `visualization` | #8 | BMI × age group, income × diabetes prevalence, education × diabetes prevalence — all by year. |
| 11 | EDA: correlation heatmap comparison | Namya | `phase-3`, `analysis`, `visualization` | #8 | Side-by-side correlation heatmaps for 2014 and 2022 with consistent color scale. |

**Phase 4**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 12 | Create stratified train/test splits | Raj | `phase-4`, `data` | #8 | 80/20 stratified split on `Diabetes_Binary` for 2014, 2022, and combined. Use `set.seed(42)`. Save 6 CSVs to `data/processed/`. |
| 13 | Decide and implement class imbalance strategy | Gaurav | `phase-4`, `modeling` | #12 | Evaluate options: class weights in `ranger` (preferred) vs. SMOTE. Implement chosen approach on training sets only. Document decision and rationale in issue comment. |

**Phase 5**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 14 | Logistic regression: 2014 | Gaurav | `phase-5`, `modeling` | #13 | Train `glm(Diabetes_Binary ~ ., family = "binomial")` on train_2014. Save model to `outputs/models/lr_2014.rds`. |
| 15 | Logistic regression: 2022 | Gaurav | `phase-5`, `modeling` | #13 | Same for 2022. |
| 16 | Logistic regression: combined | Gaurav | `phase-5`, `modeling` | #13 | Same for combined, with `Year` as a feature. |
| 17 | Random forest: 2014 | Gaurav | `phase-5`, `modeling` | #13 | Train `ranger` on train_2014. Tune `num.trees`, `mtry`, `min.node.size` via 5-fold CV. Save model. |
| 18 | Random forest: 2022 | Gaurav | `phase-5`, `modeling` | #13 | Same for 2022. |
| 19 | Random forest: combined | Gaurav | `phase-5`, `modeling` | #13 | Same for combined with `Year`. |

**Phase 6**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 20 | Evaluate all models and create comparison table | Gaurav | `phase-6`, `modeling` | #14–19 | Predict on test sets. Compute AUC-ROC, F1, precision, recall for all 6 models. Save `outputs/tables/model_comparison.csv`. |
| 21 | Plot ROC curves | Namya | `phase-6`, `visualization` | #20 | Overlaid ROC curves: LR 2014 vs LR 2022 vs LR combined (one plot), same for RF (another plot). |

**Phase 7**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 22 | Extract permutation-based feature importance | Gaurav | `phase-7`, `modeling` | #14–19 | Use `vip::vip()` with `method = "permute"` on all 6 models. Save raw importance scores to `outputs/tables/`. |
| 23 | Feature importance comparison plots | Namya | `phase-7`, `analysis`, `visualization` | #22 | Side-by-side bar plots: 2014 vs 2022 importance for LR, and separately for RF. Highlight features that moved significantly in rank. |
| 24 | Temporal comparison narrative | All | `phase-7`, `analysis` | #22, #23 | Synthesize findings: which features became more/less important? Does this align with known public health trends? Write interpretation as a shared doc or issue comment. |

**Phase 8**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 25 | Subgroup analysis: income | Namya | `phase-8`, `analysis` | #8, #20 | Diabetes prevalence by income tier × year. Model performance by income subgroup if sample sizes allow. |
| 26 | Subgroup analysis: education | Namya | `phase-8`, `analysis` | #8, #20 | Same by education level. |
| 27 | Subgroup analysis: age | Namya | `phase-8`, `analysis` | #8, #20 | Same by age group. |
| 28 | Subgroup analysis: race | Namya | `phase-8`, `analysis` | #8, #20 | Same by race. Check group sizes carefully — some race categories may have too few diabetic cases for reliable subgroup modeling. |

**Phase 9**

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 29 | Final report: data & infrastructure section | Raj | `phase-9`, `deliverable` | #8, #12, #13 | Write the data description, cleaning, harmonization, and splitting sections of the report. |
| 30 | Final report: modeling & results section | Gaurav | `phase-9`, `deliverable` | #20, #22 | Write the methodology, model results, and evaluation discussion. |
| 31 | Final report: analysis & findings section | Namya | `phase-9`, `deliverable` | #23–28 | Write the EDA, feature importance, subgroup, and temporal comparison sections. |
| 32 | Assemble and finalize report | All | `phase-9`, `deliverable` | #29, #30, #31 | Combine all sections into `final_report.Rmd`. Knit to PDF. Proofread. |
| 33 | Build presentation slides | All | `phase-9`, `deliverable` | #32 | Create slide deck. Rehearse. |

---

## 11. GitHub Project Board

### Board columns

| Column | Purpose |
|--------|---------|
| **Backlog** | All issues start here after creation |
| **To Do** | Issues ready to work on (all dependencies met) |
| **In Progress** | Actively being worked on |
| **In Review** | PR opened, waiting for teammate review |
| **Done** | Merged to `main` and verified |

### Workflow

1. At the start of each work session, each team member moves 1–2 issues from **To Do** to **In Progress**.
2. When work is done and a PR is opened, move to **In Review** and assign a reviewer.
3. After merge, move to **Done**.
4. If a dependency is not met, keep the issue in **Backlog** and add the `blocked` label.
5. Check the board at the start of every team sync to unblock issues and reprioritize.

---

## 12. Technical Workflow Detail

### Phase 1: Data audit commands

Run these in RStudio **one block at a time**. Do not run everything at once — if something errors out, you need to know exactly which block failed. Post the console output for each block as a comment on the corresponding GitHub Issue.

**Block 1 — Load and inspect 2014 structure:**

```r
source("scripts/00_setup.R")

df_2014 <- read.csv(paste0(PATH_RAW, "LLCP2014_model.csv"))

dim(df_2014)
colnames(df_2014)
sapply(df_2014, class)
```

**Block 2 — 2014 target distribution, missing values, and value ranges:**

```r
head(df_2014)
table(df_2014$Diabetes_Binary)
prop.table(table(df_2014$Diabetes_Binary))
colSums(is.na(df_2014))
sapply(df_2014 %>% select(where(is.numeric)), range)
sapply(df_2014 %>% select(where(~ !is.numeric(.))), function(x) length(unique(x)))
sapply(df_2014 %>% select(where(~ !is.numeric(.))), function(x) head(unique(x), 10))
```

**Block 3 — Load and inspect 2022 structure:**

```r
df_2022 <- read.csv(paste0(PATH_RAW, "LLCP2022_model.csv"))

dim(df_2022)
colnames(df_2022)
sapply(df_2022, class)
```

**Block 4 — 2022 target distribution, missing values, and value ranges:**

```r
head(df_2022)
table(df_2022$Diabetes_Binary)
prop.table(table(df_2022$Diabetes_Binary))
colSums(is.na(df_2022))
sapply(df_2022 %>% select(where(is.numeric)), range)
sapply(df_2022 %>% select(where(~ !is.numeric(.))), function(x) length(unique(x)))
sapply(df_2022 %>% select(where(~ !is.numeric(.))), function(x) head(unique(x), 10))
```

**Block 5 — Load and inspect combined structure:**

```r
df_combined <- read.csv(paste0(PATH_RAW, "LLCP_combined.csv"))

dim(df_combined)                                         # Expect: 737,799 rows
colnames(df_combined)
sapply(df_combined, class)
```

**Block 6 — Combined dataset verification:**

```r
# Row count by year — must match source datasets exactly
table(df_combined$Year)                                  # Expect: 431877 for 2014, 305922 for 2022

# Any new NAs introduced by combining?
colSums(is.na(df_combined))

# Column name mismatches between individual datasets and combined
setdiff(colnames(df_2014), colnames(df_combined))        # Columns in 2014 but missing from combined
setdiff(colnames(df_2022), colnames(df_combined))        # Columns in 2022 but missing from combined
setdiff(colnames(df_combined), colnames(df_2014))        # Columns in combined but not in 2014 (expect: Year)
setdiff(colnames(df_combined), colnames(df_2022))        # Columns in combined but not in 2022 (expect: Year)
```

**Block 7 — Spot-check categorical encoding consistency across years:**

```r
# These check whether the same column has the same levels in both years
# If levels differ, harmonization was done incorrectly
table(df_combined$GENHLTH, df_combined$Year)
table(df_combined$_EDUCAG, df_combined$Year)             # May need backticks: `_EDUCAG`
table(df_combined$_AGE_G, df_combined$Year)              # May need backticks: `_AGE_G`
```

**What to look for (verification checklist):**

Post a pass/fail verdict on Issue #6 based on these checks:

- [ ] `dim(df_combined)[1]` equals 737,799
- [ ] `table(df_combined$Year)` shows exactly 431,877 for 2014 and 305,922 for 2022
- [ ] `colSums(is.na(df_combined))` shows zero NAs (or the same NAs that exist in the individual files)
- [ ] `setdiff()` calls show no unexpected missing or extra columns (only `Year` should be new)
- [ ] Categorical spot-checks show the same levels appearing in both years (no blank or mismatched categories)

If **any** of these fail, the combined dataset must be rebuilt in Phase 2.

### Phase 4: Train/test split

```r
source("scripts/00_setup.R")

library(caret)

split_and_save <- function(df, name) {
  set.seed(SEED)
  idx <- createDataPartition(df$Diabetes_Binary, p = 0.8, list = FALSE)
  train <- df[idx, ]
  test  <- df[-idx, ]

  write.csv(train, paste0(PATH_PROC, "train_", name, ".csv"), row.names = FALSE)
  write.csv(test,  paste0(PATH_PROC, "test_", name, ".csv"),  row.names = FALSE)

  cat(name, "- Train:", nrow(train), "Test:", nrow(test),
      "Train diabetes %:", round(mean(train$Diabetes_Binary) * 100, 1), "\n")
}

split_and_save(df_2014, "2014")
split_and_save(df_2022, "2022")
split_and_save(df_combined, "combined")
```

### Phase 5: Model training (skeleton)

```r
# Logistic Regression
train_lr <- function(train_df, name) {
  formula <- Diabetes_Binary ~ .
  model <- glm(formula, data = train_df, family = "binomial")
  saveRDS(model, paste0(PATH_MODELS, "lr_", name, ".rds"))
  return(model)
}

# Random Forest (ranger)
train_rf <- function(train_df, name) {
  set.seed(SEED)

  ctrl <- trainControl(
    method = "cv",
    number = 5,
    classProbs = TRUE,
    summaryFunction = twoClassSummary
  )

  # Note: Diabetes_Binary must be a factor with valid R names for caret
  # e.g., "Diabetic" / "NonDiabetic" — not 0/1
  grid <- expand.grid(
    mtry = c(3, 5, 7),
    splitrule = "gini",
    min.node.size = c(10, 20, 50)
  )

  model <- train(
    Diabetes_Binary ~ .,
    data = train_df,
    method = "ranger",
    trControl = ctrl,
    tuneGrid = grid,
    metric = "ROC",
    importance = "permutation"
  )

  saveRDS(model, paste0(PATH_MODELS, "rf_", name, ".rds"))
  return(model)
}
```

### Phase 6: Evaluation

```r
evaluate_model <- function(model, test_df, model_type, dataset_name) {
  if (model_type == "lr") {
    probs <- predict(model, newdata = test_df, type = "response")
    preds <- ifelse(probs > 0.5, 1, 0)
  } else {
    # For caret ranger models
    probs <- predict(model, newdata = test_df, type = "prob")[, "Diabetic"]
    preds <- predict(model, newdata = test_df)
  }

  roc_obj <- pROC::roc(test_df$Diabetes_Binary, probs)
  cm <- confusionMatrix(as.factor(preds), as.factor(test_df$Diabetes_Binary), positive = "1")

  tibble(
    model     = model_type,
    dataset   = dataset_name,
    auc       = as.numeric(roc_obj$auc),
    f1        = cm$byClass["F1"],
    precision = cm$byClass["Precision"],
    recall    = cm$byClass["Recall"]
  )
}
```

**Note:** The exact code above will need adjustment once we see the actual column names and data types from the audit. Treat this as a skeleton, not production code.

---

## 13. Risks & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Combined dataset has silent harmonization errors | Medium | High | Phase 1 verification catches this before any modeling. Rebuild if needed. |
| Random forest training is too slow on 430K rows | Medium | Medium | Use `ranger` (not `randomForest`). If still slow, subsample training data (stratified 50%) for tuning, use full data for final model. |
| Class imbalance inflates performance metrics | High | High | Apply imbalance handling ONLY to training sets. Evaluate on original-distribution test sets. Report both balanced and raw accuracy. |
| Feature importance not comparable between LR and RF | High | Medium | Use `vip` package with `method = "permute"` for both model types. Do not compare raw Gini importance to LR coefficients. |
| Subgroup analysis has small cell sizes | Medium | Medium | Check group sizes before fitting subgroup models. Minimum threshold: ~500 diabetic cases per subgroup. Report limitations for small groups. |
| Income tier encoding differs between 2014 and 2022 | High | High | The heatmaps show `_INCOMG` in 2014 and `_INCOMG1` in 2022. This needs explicit recoding during harmonization. |
| `_SEX` column exists in 2022 heatmap but not in 2014 | Medium | Low | Confirm during data audit. If `_SEX` is not in the 2014 data, it cannot be a shared feature — drop it from combined analysis or document its absence. |
| Team bottleneck: modeling blocked on data prep | Medium | High | Gaurav prototypes the modeling pipeline using just the 2014 dataset while Raj handles harmonization. Namya works on EDA in parallel. |
| Scope creep: adding more models or analyses late | Medium | Medium | The scope is locked to LR + RF on 3 datasets, 4 subgroup dimensions, and 3 research questions. Any additions require all 3 members to agree and must not jeopardize the April 16 deadline. |

---

## 14. Definition of Done

A phase is **done** when:

1. All code for that phase is merged to `main` via reviewed PRs.
2. All output files (data, figures, tables, models) are saved to the correct directories.
3. The corresponding GitHub Issues are closed and moved to **Done** on the board.
4. At least one other team member has verified the outputs make sense (e.g., row counts are correct, plots are readable, metrics are plausible).

The **project** is done when:

1. All 33 issues are closed.
2. The final report knits to PDF without errors.
3. The presentation is rehearsed and timed.
4. The repo README accurately describes how to reproduce the full pipeline.
