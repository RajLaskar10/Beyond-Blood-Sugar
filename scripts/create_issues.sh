#!/bin/bash
# Check if connected to repo
gh repo view || exit 1

echo "Creating labels..."
gh label create "phase-0" -c "000000" -f
gh label create "phase-1" -c "111111" -f
gh label create "phase-2" -c "222222" -f
gh label create "phase-3" -c "333333" -f
gh label create "phase-4" -c "444444" -f
gh label create "phase-5" -c "555555" -f
gh label create "phase-6" -c "666666" -f
gh label create "phase-7" -c "777777" -f
gh label create "phase-8" -c "888888" -f
gh label create "phase-9" -c "999999" -f
gh label create "data" -c "0052cc" -f
gh label create "modeling" -c "bfd4f2" -f
gh label create "analysis" -c "d4c5f9" -f
gh label create "visualization" -c "fbca04" -f
gh label create "deliverable" -c "0e8a16" -f
gh label create "infra" -c "b60205" -f
gh label create "blocked" -c "d93f0b" -f

echo "Creating issues..."

# Phase 0
gh issue create --title "Create repo, folder structure, .gitignore, README" --body "Set up the full repo structure per Section 6. Add .gitignore for data/raw/*, .Rhistory, .RData, outputs/models/*.rds. README should include: project description, how to clone, how to set up data paths, how to run scripts in order." --label "phase-0,infra" --assignee "RajLaskar10"
gh issue create --title "Create 00_setup.R with shared config" --body "Define all path variables, seed, color palette, and load all required libraries per Section 8." --label "phase-0,infra" --assignee "RajLaskar10"
gh issue create --title "Create GitHub Project Board and Issues" --body "Create the board with columns per Section 11. Create all issues from this table." --label "phase-0,infra" --assignee "RajLaskar10"

# Phase 1
gh issue create --title "Data audit: 2014 dataset" --body "Run all audit commands from Section 12 on the 2014 CSV. Post results as a comment on this issue. Document column names, types, value ranges, NAs, and target distribution." --label "phase-1,data" --assignee "RajLaskar10"
gh issue create --title "Data audit: 2022 dataset" --body "Same as #4 for the 2022 dataset. Pay special attention to column name differences (e.g., _INCOMG vs _INCOMG1, presence/absence of _SEX)." --label "phase-1,data" --assignee "RajLaskar10"
gh issue create --title "Data audit: combined dataset" --body "Verify the existing combined CSV: check row count = 737,799, check table(Year) matches source counts, compare colnames() across all three files, check for NAs introduced by the join. Post pass/fail verdict." --label "phase-1,data" --assignee "RajLaskar10"
gh issue create --title "Create data_dictionary.md" --body "Document every column: name, type, allowed values, description, and any notes about encoding differences between years." --label "phase-1,data" --assignee "RajLaskar10"

# Phase 2
gh issue create --title "Harmonize and verify combined dataset" --body "If #6 failed verification: write 02_harmonize_verify.R to rename columns, align encodings, add Year, row-bind, and validate. If #6 passed: document that verification passed and copy the file to data/processed/combined_verified.csv." --label "phase-2,data" --assignee "RajLaskar10"

# Phase 3
gh issue create --title "EDA: univariate feature distributions by year" --body "Side-by-side bar charts for every categorical feature, split by diabetes status, faceted or grouped by year. Save to outputs/figures/." --label "phase-3,analysis,visualization"
gh issue create --title "EDA: bivariate interaction plots" --body "BMI × age group, income × diabetes prevalence, education × diabetes prevalence — all by year." --label "phase-3,analysis,visualization"
gh issue create --title "EDA: correlation heatmap comparison" --body "Side-by-side correlation heatmaps for 2014 and 2022 with consistent color scale." --label "phase-3,analysis,visualization"

# Phase 4
gh issue create --title "Create stratified train/test splits" --body "80/20 stratified split on Diabetes_Binary for 2014, 2022, and combined. Use set.seed(42). Save 6 CSVs to data/processed/." --label "phase-4,data" --assignee "RajLaskar10"
gh issue create --title "Decide and implement class imbalance strategy" --body "Evaluate options: class weights in ranger (preferred) vs. SMOTE. Implement chosen approach on training sets only. Document decision and rationale in issue comment." --label "phase-4,modeling"

# Phase 5
gh issue create --title "Logistic regression: 2014" --body "Train glm(Diabetes_Binary ~ ., family = \"binomial\") on train_2014. Save model to outputs/models/lr_2014.rds." --label "phase-5,modeling"
gh issue create --title "Logistic regression: 2022" --body "Same for 2022." --label "phase-5,modeling"
gh issue create --title "Logistic regression: combined" --body "Same for combined, with Year as a feature." --label "phase-5,modeling"
gh issue create --title "Random forest: 2014" --body "Train ranger on train_2014. Tune num.trees, mtry, min.node.size via 5-fold CV. Save model." --label "phase-5,modeling"
gh issue create --title "Random forest: 2022" --body "Same for 2022." --label "phase-5,modeling"
gh issue create --title "Random forest: combined" --body "Same for combined with Year." --label "phase-5,modeling"

# Phase 6
gh issue create --title "Evaluate all models and create comparison table" --body "Predict on test sets. Compute AUC-ROC, F1, precision, recall for all 6 models. Save outputs/tables/model_comparison.csv." --label "phase-6,modeling"
gh issue create --title "Plot ROC curves" --body "Overlaid ROC curves: LR 2014 vs LR 2022 vs LR combined (one plot), same for RF (another plot)." --label "phase-6,visualization"

# Phase 7
gh issue create --title "Extract permutation-based feature importance" --body "Use vip::vip() with method = \"permute\" on all 6 models. Save raw importance scores to outputs/tables/." --label "phase-7,modeling"
gh issue create --title "Feature importance comparison plots" --body "Side-by-side bar plots: 2014 vs 2022 importance for LR, and separately for RF. Highlight features that moved significantly in rank." --label "phase-7,analysis,visualization"
gh issue create --title "Temporal comparison narrative" --body "Synthesize findings: which features became more/less important? Does this align with known public health trends? Write interpretation as a shared doc or issue comment." --label "phase-7,analysis"

# Phase 8
gh issue create --title "Subgroup analysis: income" --body "Diabetes prevalence by income tier × year. Model performance by income subgroup if sample sizes allow." --label "phase-8,analysis"
gh issue create --title "Subgroup analysis: education" --body "Same by education level." --label "phase-8,analysis"
gh issue create --title "Subgroup analysis: age" --body "Same by age group." --label "phase-8,analysis"
gh issue create --title "Subgroup analysis: race" --body "Same by race. Check group sizes carefully — some race categories may have too few diabetic cases for reliable subgroup modeling." --label "phase-8,analysis"

# Phase 9
gh issue create --title "Final report: data & infrastructure section" --body "Write the data description, cleaning, harmonization, and splitting sections of the report." --label "phase-9,deliverable" --assignee "RajLaskar10"
gh issue create --title "Final report: modeling & results section" --body "Write the methodology, model results, and evaluation discussion." --label "phase-9,deliverable"
gh issue create --title "Final report: analysis & findings section" --body "Write the EDA, feature importance, subgroup, and temporal comparison sections." --label "phase-9,deliverable"
gh issue create --title "Assemble and finalize report" --body "Combine all sections into final_report.Rmd. Knit to PDF. Proofread." --label "phase-9,deliverable"
gh issue create --title "Build presentation slides" --body "Create slide deck. Rehearse." --label "phase-9,deliverable"

echo "Creating GitHub Project..."
gh project create --owner RajLaskar10 --title "Beyond Blood Sugar"

echo "Done."
