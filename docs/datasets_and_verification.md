# Datasets & Verification

## Dataset Summary

| Property | 2014 BRFSS | 2022 BRFSS | Combined |
|----------|-----------|-----------|----------|
| Source | CDC BRFSS via UCI ML Repository | CDC BRFSS (raw, cleaned by team) | Row-bind of both |
| Rows | 431,877 | 305,922 | 737,799 |
| Shared features | 20 (after harmonization) | 20 (after harmonization) | 20 + `Year` |
| Diabetes prevalence | ~14% | ~15.3% | ~14.5% (estimated) |
| File | `LLCP2014_model.csv` | `LLCP2022_model.csv` | `LLCP_combined.csv` |
| Status | Cleaned | Cleaned | **Exists but UNVERIFIED** |

Target variable: `Diabetes_Binary`. ~14% positive rate — class imbalance must be handled. Apply handling to training sets only; **never touch test sets**.

Use `ranger` for random forest (not `randomForest` — datasets are 300K–430K rows and `randomForest` will be unacceptably slow).

## Critical Note on the Combined Dataset

A combined CSV exists but has **not been verified** for correct harmonization. Before any modeling on the combined data, Phase 1 must confirm:

- Column names are identical across both source datasets
- Categorical encodings (income tiers, education levels, age groups, race categories) use the same values
- No NAs were introduced during the join
- Row count equals 431,877 + 305,922 = 737,799 exactly

If verification fails, the combined dataset must be rebuilt from scratch in Phase 2.

**Known encoding risk:** `_INCOMG` (2014) vs `_INCOMG1` (2022) — income tier column names differ and need explicit recoding during harmonization.

**Known column risk:** `_SEX` column appears in 2022 heatmap but may not exist in 2014. Confirm during audit; if absent from 2014, drop it from combined analysis.

## Combined Dataset Verification Checklist

Post a pass/fail verdict on Issue #6 based on these checks:

- [ ] `dim(df_combined)[1]` equals 737,799
- [ ] `table(df_combined$Year)` shows exactly 431,877 for 2014 and 305,922 for 2022
- [ ] `colSums(is.na(df_combined))` shows zero NAs (or same NAs as individual files)
- [ ] `setdiff()` calls show no unexpected missing or extra columns (only `Year` should be new)
- [ ] Categorical spot-checks show the same levels in both years (no blank or mismatched categories)

If **any** of these fail, the combined dataset must be rebuilt in Phase 2.
