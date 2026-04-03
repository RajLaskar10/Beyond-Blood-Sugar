# GitHub Issues & Project Board

## Labels

| Label | Purpose |
|-------|---------|
| `phase-0` – `phase-9` | Phase tracking |
| `data` | Data loading, cleaning, harmonization |
| `modeling` | Model training, tuning, evaluation |
| `analysis` | EDA, feature importance, subgroup analysis |
| `visualization` | Plot creation |
| `deliverable` | Report, presentation |
| `infra` | Repo setup, tooling |
| `blocked` | Waiting on a dependency |

## Issue List

### Phase 0

| # | Title | Owner | Labels | Depends on |
|---|-------|-------|--------|------------|
| 1 | Create repo, folder structure, .gitignore, README | Raj | `phase-0`, `infra` | — |
| 2 | Create 00_setup.R with shared config | Raj | `phase-0`, `infra` | #1 |
| 3 | Create GitHub Project Board and Issues | Raj | `phase-0`, `infra` | #1 |

### Phase 1

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 4 | Data audit: 2014 dataset | Raj | `phase-1`, `data` | #2 | Run all audit commands on 2014 CSV. Post results as issue comment. Document column names, types, value ranges, NAs, target distribution. |
| 5 | Data audit: 2022 dataset | Raj | `phase-1`, `data` | #2 | Same as #4 for 2022. Pay attention to column name differences (`_INCOMG` vs `_INCOMG1`, presence/absence of `_SEX`). |
| 6 | Data audit: combined dataset | Raj | `phase-1`, `data` | #4, #5 | Verify existing combined CSV: row count = 737,799, `table(Year)` matches source counts, `colnames()` aligned, no NAs introduced. Post pass/fail verdict. |
| 7 | Create data_dictionary.md | Raj | `phase-1`, `data` | #4, #5 | Document every column: name, type, allowed values, description, encoding differences between years. |

### Phase 2

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 8 | Harmonize and verify combined dataset | Raj | `phase-2`, `data` | #6 | If #6 failed: write `02_harmonize_verify.R` to rename columns, align encodings, add `Year`, row-bind, validate. If #6 passed: copy to `data/processed/combined_verified.csv`. |

### Phase 3

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 9 | EDA: univariate feature distributions by year | Namya | `phase-3`, `analysis`, `visualization` | #8 | Side-by-side bar charts for every categorical feature, by diabetes status, faceted by year. |
| 10 | EDA: bivariate interaction plots | Namya | `phase-3`, `analysis`, `visualization` | #8 | BMI × age group, income × diabetes prevalence, education × diabetes prevalence — all by year. |
| 11 | EDA: correlation heatmap comparison | Namya | `phase-3`, `analysis`, `visualization` | #8 | Side-by-side correlation heatmaps for 2014 and 2022 with consistent color scale. |

### Phase 4

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 12 | Create stratified train/test splits | Raj | `phase-4`, `data` | #8 | 80/20 stratified split on `Diabetes_Binary` for all 3 datasets. `set.seed(42)`. Save 6 CSVs to `data/processed/`. |
| 13 | Decide and implement class imbalance strategy | Gaurav | `phase-4`, `modeling` | #12 | Evaluate class weights (preferred) vs. SMOTE. Implement on training sets only. Document decision. Hold off on finalizing until professor covers resampling in class. |

### Phase 5

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 14 | Logistic regression: 2014 | Gaurav | `phase-5`, `modeling` | #13 | Train `glm(Diabetes_Binary ~ ., family = "binomial")` on train_2014. Save to `outputs/models/lr_2014.rds`. |
| 15 | Logistic regression: 2022 | Gaurav | `phase-5`, `modeling` | #13 | Same for 2022. |
| 16 | Logistic regression: combined | Gaurav | `phase-5`, `modeling` | #13 | Same for combined, with `Year` as a feature. |
| 17 | Random forest: 2014 | Gaurav | `phase-5`, `modeling` | #13 | Train `ranger` on train_2014. Tune `num.trees`, `mtry`, `min.node.size` via 5-fold CV. Save model. |
| 18 | Random forest: 2022 | Gaurav | `phase-5`, `modeling` | #13 | Same for 2022. |
| 19 | Random forest: combined | Gaurav | `phase-5`, `modeling` | #13 | Same for combined with `Year`. |

### Phase 6

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 20 | Evaluate all models and create comparison table | Gaurav | `phase-6`, `modeling` | #14–19 | Predict on test sets. Compute AUC-ROC, F1, precision, recall for all 6 models. Save `outputs/tables/model_comparison.csv`. |
| 21 | Plot ROC curves | Namya | `phase-6`, `visualization` | #20 | Overlaid ROC curves: LR 2014 vs LR 2022 vs LR combined (one plot), same for RF (another plot). |

### Phase 7

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 22 | Extract permutation-based feature importance | Gaurav | `phase-7`, `modeling` | #14–19 | Use `vip::vip()` with `method = "permute"` on all 6 models. Save raw importance scores to `outputs/tables/`. |
| 23 | Feature importance comparison plots | Namya | `phase-7`, `analysis`, `visualization` | #22 | Side-by-side bar plots: 2014 vs 2022 importance for LR, and separately for RF. Highlight features that moved significantly in rank. |
| 24 | Temporal comparison narrative | All | `phase-7`, `analysis` | #22, #23 | Synthesize: which features became more/less important? Alignment with known public health trends? Write as shared doc or issue comment. |
| 34 | Extract and compare LR coefficients across years | Gaurav | `phase-7`, `modeling`, `analysis` | #14, #15 | Extract coefficient tables with p-values from both LR models. Build comparison table highlighting variables that changed in significance or magnitude. Specifically requested by professor. |
| 35 | Visualize LR coefficient comparison | Namya | `phase-7`, `visualization` | #34 | Publication-quality coefficient comparison plot (dumbbell chart or forest plot showing 2014 vs 2022 coefficients with CIs). |

### Phase 8

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 25 | Subgroup analysis: income | Namya | `phase-8`, `analysis` | #8, #20 | Diabetes prevalence by income tier × year. Model performance by income subgroup if sample sizes allow (≥500 diabetic cases). |
| 26 | Subgroup analysis: education | Namya | `phase-8`, `analysis` | #8, #20 | Same by education level. |
| 27 | Subgroup analysis: age | Namya | `phase-8`, `analysis` | #8, #20 | Same by age group. |
| 28 | Subgroup analysis: race | Namya | `phase-8`, `analysis` | #8, #20 | Same by race. Check group sizes carefully — some race categories may have too few diabetic cases. |

### Phase 9

| # | Title | Owner | Labels | Depends on | Description |
|---|-------|-------|--------|------------|-------------|
| 29 | Final report: data & infrastructure section | Raj | `phase-9`, `deliverable` | #8, #12, #13 | Data description, cleaning, harmonization, splitting sections. |
| 30 | Final report: modeling & results section | Gaurav | `phase-9`, `deliverable` | #20, #22 | Methodology, model results, evaluation discussion. |
| 31 | Final report: analysis & findings section | Namya | `phase-9`, `deliverable` | #23–28 | EDA, feature importance, subgroup, temporal comparison sections. |
| 32 | Assemble and finalize report | All | `phase-9`, `deliverable` | #29, #30, #31 | Combine sections into `final_report.Rmd`. Knit to PDF. Proofread. |
| 33 | Build presentation slides | All | `phase-9`, `deliverable` | #32 | Create slide deck. Rehearse. |

## Project Board Workflow

| Column | Purpose |
|--------|---------|
| **Backlog** | All issues start here after creation |
| **To Do** | Dependencies met — ready to start |
| **In Progress** | Actively being worked on |
| **In Review** | PR opened, awaiting teammate review |
| **Done** | Merged to `main` and verified |

Rules:
- Move 1–2 issues from **To Do** to **In Progress** at the start of each work session.
- When a PR is opened, move to **In Review** and assign a reviewer.
- After merge, move to **Done**.
- If a dependency is not met, keep in **Backlog** and add `blocked` label.
- Check the board at the start of every team sync to unblock issues and reprioritize.
