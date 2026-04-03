# Session Log — Phase 1: Data Audit

**Date:** 2026-04-03
**Owner:** Raj Laskar
**Issues closed:** #4, #5, #6
**Script run:** `scripts/01_data_audit.R`

---

## What was done

Ran the full Phase 1 data audit covering all three datasets (2014, 2022, combined). Results posted as comments on GitHub Issues #4, #5, #6 and all three issues are now closed.

---

## Key findings

### 2014 Dataset (Issue #4) ✅
- 431,877 rows × 34 columns — row count correct
- Target `Diabetes_Binary`: 14.03% positive (60,588 / 431,877)
- No NAs in target variable
- High missingness in PHYSHLTH (66.6%), MENTHLTH (71.4%), INSULIN (94.5%) — all BRFSS skip patterns, not errors
- Income column: `X_INCOMG`, range 1–5 (5 tiers)
- No `X_SEX` column — confirmed absent

### 2022 Dataset (Issue #5) ✅
- 305,922 rows × 36 columns — row count correct
- Target `Diabetes_Binary`: 15.26% positive (46,693 / 305,922) — higher than 2014 as expected
- No NAs in target variable
- Income column: `X_INCOMG1`, range 1–6 (6 tiers) — **encoding mismatch with 2014**
- `X_SEX` present (range 1–2) — **2022-only, drop from combined**
- Race column renamed: `X_RACEGR3` (2014) → `X_RACEGR4` (2022)
- Alcohol renamed: `DRNKANY5` → `DRNKANY6`; Insulin: `INSULIN` → `INSULIN1`

### Combined Dataset (Issue #6) ❌ FAIL
- Row count correct (737,799) and year breakdown correct (431,877 + 305,922)
- BUT: existing combined CSV was pre-harmonized to only 20 columns with renamed cols
  (`Alcohol`, `Insulin_Use`, `Income_Harmonized`, `Race_Harmonized`)
- Missing: `HLTHPLN1`/`MEDCOST`, `X_BMI5`, and several other original columns
- Verdict: **FAIL — combined dataset needs rebuilding in Phase 2**

---

## Next steps (unblocked)

| Issue | Phase | What | Status |
|-------|-------|------|--------|
| #7 | Phase 1 | Create data_dictionary.md | Ready to start |
| #8 | Phase 2 | Write `02_harmonize_verify.R` and rebuild combined | Ready to start |

**Harmonization requirements for Issue #8:**
1. Rename `X_RACEGR3` → `X_RACEGR` (or common name) in 2014; `X_RACEGR4` → same in 2022
2. Recode income: `X_INCOMG` (1–5) and `X_INCOMG1` (1–6) to a common 5-level scale
3. Rename alcohol: `DRNKANY5` → `Alcohol` in 2014; `DRNKANY6` → same in 2022
4. Rename insulin: `INSULIN` → `Insulin_Use` in 2014; `INSULIN1` → same in 2022
5. Rename health plan: `HLTHPLN1` → `Health_Plan` in 2014; `X_HLTHPLN` → same in 2022
6. Rename medical cost: `MEDCOST` → `Med_Cost` in 2014; `MEDCOST1` → same in 2022
7. Drop `X_SEX` (2022-only)
8. Add `Year` column before row-binding
9. Validate: 737,799 rows, identical column names, no new NAs, categorical consistency

**For teammates:**
- Gaurav: can prototype LR/RF skeletons against 2014 data only (431K rows, clean)
- Namya: can begin EDA on individual 2014 and 2022 datasets while combined is rebuilt
