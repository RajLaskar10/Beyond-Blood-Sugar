# Execution Phases

## Phase 0 — Project Setup ✅ DONE

**Owner:** Raj
**Output:** Working repo that all 3 team members can clone and run `00_setup.R` without errors.

## Phase 1 — Data Audit & Combined Dataset Verification

**Owner:** Raj
**What:** Load all three CSVs (2014, 2022, combined). Run the audit commands in `docs/technical_workflow.md`. Document column names, types, value ranges, missing values, and class distributions. Verify the combined dataset by checking column alignment, encoding consistency, row counts, and absence of spurious NAs.
**Output:** Completed `01_data_audit.R`, a filled-in `data/data_dictionary.md`, and a written verification report (as an Issue comment) on whether the combined dataset is valid or needs rebuilding.

**Parallel work while this runs:**
- Gaurav can set up the modeling script skeleton (`05_model_logistic.R`, `06_model_rf.R`) with placeholder functions.
- Namya can begin extended EDA on the individual 2014 and 2022 datasets.

## Phase 2 — Harmonization (if needed)

**Owner:** Raj
**What:** If Phase 1 reveals problems with the combined dataset, write `02_harmonize_verify.R` to rename mismatched columns, recode inconsistent categorical levels (especially income tiers — `_INCOMG` vs `_INCOMG1`), add the `Year` column, row-bind, and validate. If verification passes, skip to saving the verified combined file.
**Output:** `data/processed/combined_verified.csv` that passes all validation checks.

## Phase 3 — Extended EDA

**Owner:** Namya (primary), with input from Raj and Gaurav
**What:** Produce:
- Side-by-side bar charts for each categorical feature vs. diabetes prevalence, split by year
- BMI × age group interaction plots by diabetes status
- Income × diabetes prevalence by year
- Education × diabetes prevalence by year
- Race × diabetes prevalence by year
- Correlation heatmap comparison (2014 vs. 2022 side by side)

**Output:** At least 8–10 figures saved to `outputs/figures/`, and a summary of EDA findings written as Issue comments.

## Phase 4 — Train/Test Split & Class Imbalance

**Owner:** Raj (split), Gaurav (imbalance strategy)
**What:**
- Create 80/20 stratified train/test splits for 2014, 2022, and combined datasets using `caret::createDataPartition()` with `set.seed(42)`.
- Save all 6 files (train + test × 3 datasets) to `data/processed/`.
- Decide on class imbalance handling: class weights in the model (preferred for `ranger`) vs. SMOTE on training data. Document rationale.
- Apply imbalance handling to training sets only. **Never touch test sets.**

> **Professor's note:** The professor indicated that resampling techniques for class imbalance will be covered in an upcoming lecture. Wait for that lecture before finalizing the resampling strategy in Issue #13. In the meantime, proceed with the train/test split (Issue #12) and prototype modeling using class weights as a temporary approach. Update Issue #13 after the lecture with the chosen method and rationale.

**Output:** 6 CSV files in `data/processed/`, a documented imbalance strategy.

## Phase 5 — Model Training

**Owner:** Gaurav
**What:**
- Train logistic regression (`glm`, `family = "binomial"`) on train_2014, train_2022, train_combined.
- Train random forest (`ranger`) on the same three training sets.
- For random forest: tune `num.trees`, `mtry`, and `min.node.size` using 5-fold CV via `caret::trainControl()`.
- Save all 6 trained model objects as `.rds` to `outputs/models/`.

**Output:** 6 model `.rds` files, tuning results logged.

## Phase 6 — Evaluation

**Owner:** Gaurav
**What:**
- Predict on all 6 test sets.
- Compute AUC-ROC (via `pROC::roc()`), F1, precision, recall (via `caret::confusionMatrix()`).
- Create a single comparison table with all metrics across all 6 models.
- Plot ROC curves (overlaid by year for same model type).

**Output:** `outputs/tables/model_comparison.csv`, ROC curve figures.

## Phase 7 — Feature Importance & Temporal Comparison

**Owner:** Namya (plots), Gaurav (extraction)

> **Priority note:** The professor singled out the 2014 vs. 2022 comparison as the most interesting part of this project. Phase 7 is **not** a secondary analysis — it is the **core intellectual contribution**. Allocate the most time and polish here. The logistic regression coefficient comparison and feature importance comparison should be the centerpiece of the final report and presentation.

**What:**
- Extract permutation-based feature importance from all 6 models using the `vip` package (`method = "permute"` ensures comparable scores across LR and RF).
- **Logistic Regression Coefficient Comparison:**
  - Extract coefficient table (estimates, SE, z-values, p-values) from 2014 and 2022 LR models using `broom::tidy()`.
  - Build side-by-side table: Variable, Coefficient_2014, PValue_2014, Coefficient_2022, PValue_2022, Direction_of_Change.
  - Flag variables significant (p < 0.05) in one year but not the other.
  - Flag variables where coefficient magnitude changed substantially.
  - Create a coefficient comparison plot (dumbbell chart or forest plot with confidence intervals).
  - Owner: Gaurav (extraction — Issue #34), Namya (visualization — Issue #35).
- Create side-by-side importance plots: 2014 vs. 2022 for each model type.
- Identify features that rose or fell in importance across years.
- Write the narrative interpretation of what changed.

**Output:** `outputs/tables/lr_coefficient_comparison.csv`, `outputs/figures/fig_lr_coefficient_comparison.png`, feature importance plots, a ranked comparison table, written interpretation.

## Phase 8 — Subgroup Analysis

**Owner:** Namya
**What:** For each of 4 dimensions (income, education, age, race):
- Compute diabetes prevalence by subgroup × year.
- Compute model performance metrics by subgroup (if subgroup sizes permit — minimum ~500 diabetic cases per subgroup).
- Create visualizations showing how disparities changed.
- Flag any subgroups with insufficient sample size and note the limitation.

**Output:** Subgroup prevalence tables, disparity comparison plots, written findings.

## Phase 9 — Deliverables

**Owner:** All three
**What:**
- Raj writes: data and infrastructure sections of the report.
- Gaurav writes: modeling methodology and results sections.
- Namya writes: EDA, feature importance, and subgroup analysis sections.
- One person assembles the full `final_report.Rmd` and knits it.
- Build presentation slides: motivation, data, methods, key results (feature importance shifts, subgroup disparities), conclusions.
- Rehearse the presentation.

**Output:** Final report (PDF from Rmd), presentation slides.
