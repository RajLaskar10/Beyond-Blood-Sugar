# Data Dictionary — Beyond Blood Sugar

**Last updated:** 2026-04-03 (updated after Phase 2 harmonization)
**Source:** CDC BRFSS (Behavioral Risk Factor Surveillance System)
**Populated from:** Phase 1 audit + Phase 2 harmonization (`scripts/01_data_audit.R`, `scripts/02_harmonize_verify.R`)

---

## Datasets

| File | Rows | Columns | Status |
|------|------|---------|--------|
| `data/raw/LLCP2014_model.csv` | 431,877 | 34 | ✅ Clean, use directly |
| `data/raw/LLCP2022_model.csv` | 305,922 | 36 | ✅ Clean, use directly |
| `data/raw/LLCP_combined.csv`  | 737,799 | 20 | ❌ Partial pre-harmonization — do not use |
| `data/processed/combined_verified.csv` | 737,799 | 34 | ✅ **Use this for combined modeling** |

---

## Target Variable

| Column | Type | Values | Description |
|--------|------|--------|-------------|
| `Diabetes_Binary` | integer | 0, 1 | **Modeling target.** 0 = No Diabetes; 1 = Diabetes or Prediabetes |
| `Diabetes_Label` | character | "No Diabetes", "Diabetes/Prediabetes" | Human-readable label |

**Class distribution:**
| Dataset | No Diabetes (0) | Diabetes (1) | Positive Rate |
|---------|----------------|-------------|---------------|
| 2014 (raw) | 371,289 (85.97%) | 60,588 | **14.03%** |
| 2022 (raw) | 259,229 (84.74%) | 46,693 | **15.26%** |
| Combined (verified) | 630,518 (85.46%) | 107,281 | **14.54%** |

---

## Harmonized Feature Set (final schema for modeling)

These are the 20 raw integer features present in `combined_verified.csv` and in the individual 2014/2022 datasets after harmonization. All column names are consistent across years.

| Column | Type | Range | Description | Encoding |
|--------|------|-------|-------------|----------|
| `X_AGE_G` | integer | 1–6 | Age group | 1=18–24, 2=25–34, 3=35–44, 4=45–54, 5=55–64, 6=65+ |
| `X_EDUCAG` | integer | 1–4 | Education level | 1=No HS, 2=HS Grad, 3=Some College, 4=College Grad |
| `X_INCOMG` | integer | 1–5 | Income tier (harmonized) | 1=<$15k, 2=$15–25k, 3=$25–35k, 4=$35–50k, 5=>$50k |
| `X_RACEGR` | integer | 1–5 | Race group (harmonized) | 1=White, 2=Black, 3=Hispanic, 4=Multiracial, 5=Other |
| `GENHLTH` | integer | 1–5 | General health (self-reported) | 1=Excellent, 2=Very Good, 3=Good, 4=Fair, 5=Poor |
| `PHYSHLTH` | integer | 1–30 | Poor physical health days past 30 | ~64% missing (BRFSS skip) |
| `MENTHLTH` | integer | 1–30 | Poor mental health days past 30 | ~67% missing (BRFSS skip) |
| `DIFFWALK` | integer | 1–2 | Difficulty walking or climbing stairs | 1=Yes, 2=No |
| `X_BMI5` | integer | ~1200–9964 | BMI × 100 | Divide by 100 for actual BMI |
| `X_BMI5CAT` | integer | 1–4 | BMI category | 1=Underweight, 2=Normal, 3=Overweight, 4=Obese |
| `CVDCRHD4` | integer | 1–2 | Coronary heart disease diagnosis | 1=Yes, 2=No |
| `CVDSTRK3` | integer | 1–2 | Stroke diagnosis | 1=Yes, 2=No |
| `X_SMOKER3` | integer | 1–4 | Smoking status | 1=Daily, 2=Occasional, 3=Former, 4=Never |
| `X_TOTINDA` | integer | 1–2 | Physical activity past 30 days | 1=Active, 2=Inactive |
| `DRNKANY` | integer | 1–2 | Any alcohol past 30 days | 1=Yes, 2=No |
| `SLEPTIM1` | integer | 1–24 | Hours of sleep per night | ~36% missing (BRFSS skip) |
| `INSULIN` | integer | 1–2 | Currently using insulin | 1=Yes, 2=No; ~95% missing (asked of diabetics only) |
| `HLTHPLN` | integer | 1–2 | Has health care coverage | 1=Yes, 2=No |
| `MEDCOST` | integer | 1–2 | Couldn't see doctor due to cost | 1=Yes, 2=No |
| `Year` | integer | 2014, 2022 | Survey year | Combined dataset only |

---

## Derived Character Columns (EDA and visualization)

Pre-computed human-readable labels. Present in all datasets after harmonization.

| Column | Type | Levels | Derived From |
|--------|------|--------|-------------|
| `BMI` | numeric | 12–100 | `X_BMI5` ÷ 100 |
| `Age_Group` | character | 18-24, 25-34, 35-44, 45-54, 55-64, 65+ | `X_AGE_G` |
| `Education` | character | No HS, HS Grad, Some College, College Grad | `X_EDUCAG` |
| `Income` | character | <15k, 15-25k, 25-35k, 35-50k, >50k | `X_INCOMG` (harmonized) |
| `Race` | character | White, Black, Hispanic, Multiracial, Other | `X_RACEGR` (harmonized) |
| `BMI_Category` | character | Underweight, Normal, Overweight, Obese | `X_BMI5CAT` |
| `Gen_Health` | character | Excellent, Very Good, Good, Fair, Poor | `GENHLTH` |
| `Physical_Activity` | character | Active, Inactive | `X_TOTINDA` |
| `Smoker` | character | Never, Former, Occasional, Daily | `X_SMOKER3` |
| `Heart_Disease` | character | Yes, No | `CVDCRHD4` |
| `Stroke` | character | Yes, No | `CVDSTRK3` |
| `Insulin` | character | Yes, No | `INSULIN` |

---

## Year-Specific Raw Columns (individual datasets only)

These columns exist in the raw source files but are **not present in `combined_verified.csv`** — either dropped (2022-only) or renamed to harmonized names above.

### 2014-only original names (renamed in harmonization)
| Original | Harmonized to | Note |
|----------|--------------|------|
| `X_RACEGR3` | `X_RACEGR` | Race column, survey variable rename |
| `X_INCOMG` | `X_INCOMG` | Same name, no rename needed in 2014 |
| `DRNKANY5` | `DRNKANY` | Alcohol, survey cycle suffix removed |
| `HLTHPLN1` | `HLTHPLN` | Health plan rename |
| `DIABETE3` | *(dropped)* | Raw diabetes question — use `Diabetes_Binary` |

### 2022-only original names (renamed or dropped in harmonization)
| Original | Action | Note |
|----------|--------|------|
| `X_RACEGR4` | → `X_RACEGR` | Race column, survey variable rename |
| `X_INCOMG1` | → `X_INCOMG` + recode | 6 tiers → 5 tiers (codes 5+6 collapsed to 5) |
| `DRNKANY6` | → `DRNKANY` | Alcohol, survey cycle suffix removed |
| `INSULIN1` | → `INSULIN` | Insulin rename |
| `X_HLTHPLN` | → `HLTHPLN` | Health plan rename |
| `MEDCOST1` | → `MEDCOST` | Medical cost rename |
| `X_SEX` | **Dropped** | 2022-only — absent from 2014 |
| `Sex` | **Dropped** | Derived label for `X_SEX` |
| `Health_Insurance` | **Dropped** | Derived label for `HLTHPLN` (already captured) |
| `DIABETE4` | **Dropped** | Raw diabetes question — use `Diabetes_Binary` |

---

## Missing Value Summary (combined_verified.csv)

| Column | NAs | % Missing | Reason |
|--------|-----|-----------|--------|
| `INSULIN` | 704,867 | 95.5% | BRFSS skip — asked only of people with diabetes |
| `MENTHLTH` | 496,987 | 67.4% | BRFSS skip pattern |
| `PHYSHLTH` | 481,491 | 65.3% | BRFSS skip pattern |
| `SLEPTIM1` | 265,694 | 36.0% | BRFSS skip pattern |
| `DRNKANY` | 32,614 | 4.4% | Non-response |
| `X_INCOMG` / `Income` | 56,589 | 7.7% | Non-response (2014 only; 2022 has 0 NAs) |
| `X_SMOKER3` / `Smoker` | 22,418 | 3.0% | Non-response |
| `X_RACEGR` / `Race` | 12,696 | 1.7% | Non-response |
| `Diabetes_Binary` | **0** | 0% | ✅ Target is complete |
| `Year` | **0** | 0% | ✅ Complete |
