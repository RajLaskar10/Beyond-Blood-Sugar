# Data Dictionary — Beyond Blood Sugar

**Last updated:** 2026-04-03
**Source:** CDC BRFSS (Behavioral Risk Factor Surveillance System)
**Populated from:** Phase 1 data audit (`scripts/01_data_audit.R`)

---

## Datasets

| File | Rows | Columns | Notes |
|------|------|---------|-------|
| `data/raw/LLCP2014_model.csv` | 431,877 | 34 | Cleaned; ready to use |
| `data/raw/LLCP2022_model.csv` | 305,922 | 36 | Cleaned; ready to use |
| `data/raw/LLCP_combined.csv` | 737,799 | 20 | Pre-harmonized; **fails verification — do not use** |
| `data/processed/combined_verified.csv` | 737,799 | TBD | Output of `02_harmonize_verify.R` (Phase 2) |

---

## Target Variable

| Column | Type | Values | Description | Both Years? |
|--------|------|--------|-------------|-------------|
| `Diabetes_Binary` | integer | 0, 1 | 0 = No Diabetes; 1 = Diabetes or Prediabetes | ✅ Yes |
| `Diabetes_Label` | character | "No Diabetes", "Diabetes/Prediabetes" | Human-readable label for `Diabetes_Binary` | ✅ Yes |

**Class distribution:**
| Year | No Diabetes (0) | Diabetes (1) | Positive Rate |
|------|----------------|-------------|---------------|
| 2014 | 371,289 (85.97%) | 60,588 | **14.03%** |
| 2022 | 259,229 (84.74%) | 46,693 | **15.26%** |

---

## Shared Features (present in both years, same column name)

| Column | Type | Range | Description | Notes |
|--------|------|-------|-------------|-------|
| `X_AGE_G` | integer | 1–6 | Age group | 1=18–24, 2=25–34, 3=35–44, 4=45–54, 5=55–64, 6=65+ |
| `X_EDUCAG` | integer | 1–4 | Education level | 1=No HS, 2=HS Grad, 3=Some College, 4=College Grad |
| `GENHLTH` | integer | 1–5 | General health (self-reported) | 1=Excellent, 2=Very Good, 3=Good, 4=Fair, 5=Poor |
| `PHYSHLTH` | integer | 1–30 | Days of poor physical health (past 30 days) | High missingness (~65%); BRFSS skip pattern |
| `MENTHLTH` | integer | 1–30 | Days of poor mental health (past 30 days) | High missingness (~70%); BRFSS skip pattern |
| `DIFFWALK` | integer | 1–2 | Difficulty walking or climbing stairs | 1=Yes, 2=No |
| `X_BMI5` | integer | ~1200–9964 | BMI × 100 (raw BRFSS code) | Divide by 100 for actual BMI |
| `X_BMI5CAT` | integer | 1–4 | BMI category | 1=Underweight, 2=Normal, 3=Overweight, 4=Obese |
| `CVDCRHD4` | integer | 1–2 | Ever told had coronary heart disease | 1=Yes, 2=No |
| `CVDSTRK3` | integer | 1–2 | Ever told had a stroke | 1=Yes, 2=No |
| `X_SMOKER3` | integer | 1–4 | Smoking status | 1=Daily, 2=Occasional, 3=Former, 4=Never |
| `X_TOTINDA` | integer | 1–2 | Physical activity in past 30 days | 1=Active, 2=Inactive |
| `SLEPTIM1` | integer | 1–24 | Hours of sleep per night | Moderate missingness (~36%) |

---

## Year-Specific Raw Columns (require harmonization)

### Diabetes Diagnosis Variable

| 2014 Column | 2022 Column | Type | Range | Description |
|-------------|-------------|------|-------|-------------|
| `DIABETE3` | `DIABETE4` | integer | 1–4 | Raw BRFSS diabetes question (survey cycle rename). 1=Yes, 3=No, 4=Prediabetes |

*Note: `Diabetes_Binary` is the derived target and should be used for modeling, not these raw codes.*

### Income

| 2014 Column | 2022 Column | Type | Range | Levels | ⚠️ Encoding Difference |
|-------------|-------------|------|-------|--------|----------------------|
| `X_INCOMG` | `X_INCOMG1` | integer | 1–5 (2014), 1–6 (2022) | See below | **YES — different scales** |

**Income tier encoding:**
| Code | 2014 (`X_INCOMG`) | 2022 (`X_INCOMG1`) |
|------|-------------------|-------------------|
| 1 | < $15,000 | < $15,000 |
| 2 | $15,000–$25,000 | $15,000–$25,000 |
| 3 | $25,000–$35,000 | $25,000–$35,000 |
| 4 | $35,000–$50,000 | $35,000–$50,000 |
| 5 | > $50,000 | $50,000–$100,000 |
| 6 | *(not present)* | > $100,000 |

**Harmonization plan:** Collapse 2022 codes 5 and 6 → code 5 (">$50k") to match 2014's 5-level scale.

### Race

| 2014 Column | 2022 Column | Type | Range | Description |
|-------------|-------------|------|-------|-------------|
| `X_RACEGR3` | `X_RACEGR4` | integer | 1–5 (both) | Race group (survey variable renamed between cycles) |

Codes: 1=White, 2=Black, 3=Hispanic, 4=Multiracial, 5=Other

### Alcohol Use

| 2014 Column | 2022 Column | Type | Range | Description |
|-------------|-------------|------|-------|-------------|
| `DRNKANY5` | `DRNKANY6` | integer | 1–2 | Any alcohol in past 30 days; 1=Yes, 2=No (survey cycle rename only) |

### Insulin Use

| 2014 Column | 2022 Column | Type | Range | Description | Missingness |
|-------------|-------------|------|-------|-------------|-------------|
| `INSULIN` | `INSULIN1` | integer | 1–2 | Currently using insulin; 1=Yes, 2=No | ~94–97% missing (asked only of diabetics) |

### Health Plan

| 2014 Column | 2022 Column | Type | Range | Description |
|-------------|-------------|------|-------|-------------|
| `HLTHPLN1` | `X_HLTHPLN` | integer | 1–2 | Has health care coverage; 1=Yes, 2=No |

### Medical Cost Barrier

| 2014 Column | 2022 Column | Type | Range | Description |
|-------------|-------------|------|-------|-------------|
| `MEDCOST` | `MEDCOST1` | integer | 1–2 | Could not see doctor due to cost; 1=Yes, 2=No |

---

## 2022-Only Columns (not in 2014)

| Column | Type | Range | Description | Harmonization Action |
|--------|------|-------|-------------|---------------------|
| `X_SEX` | integer | 1–2 | Biological sex; 1=Male, 2=Female | **Drop from combined** (2022-only) |
| `Sex` | character | "Male", "Female" | Derived label for `X_SEX` | **Drop from combined** |

---

## Derived Columns (both years, character type)

These are pre-computed labels derived from the raw BRFSS integer codes. Present in both datasets.

| Column | Type | Levels | Derived From |
|--------|------|--------|-------------|
| `Age_Group` | character | 18-24, 25-34, 35-44, 45-54, 55-64, 65+ | `X_AGE_G` |
| `Education` | character | No HS, HS Grad, Some College, College Grad | `X_EDUCAG` |
| `BMI` | numeric | 12–100 | `X_BMI5` ÷ 100 |
| `BMI_Category` | character | Underweight, Normal, Overweight, Obese | `X_BMI5CAT` |
| `Gen_Health` | character | Excellent, Very Good, Good, Fair, Poor | `GENHLTH` |
| `Physical_Activity` | character | Active, Inactive | `X_TOTINDA` |
| `Smoker` | character | Never, Former, Occasional, Daily | `X_SMOKER3` |
| `Heart_Disease` | character | Yes, No | `CVDCRHD4` |
| `Stroke` | character | Yes, No | `CVDSTRK3` |
| `Income` | character | <15k, 15-25k, 25-35k, 35-50k, >50k | `X_INCOMG` (2014) / `X_INCOMG1` (2022) |
| `Race` | character | White, Black, Hispanic, Multiracial, Other | `X_RACEGR3` (2014) / `X_RACEGR4` (2022) |
| `Insulin` | character | Yes, No | `INSULIN` (2014) / `INSULIN1` (2022) |

**2022-only derived columns:**
| Column | Type | Levels | Derived From |
|--------|------|--------|-------------|
| `Sex` | character | Male, Female | `X_SEX` (2022-only) |
| `Health_Insurance` | character | Yes, No | `X_HLTHPLN` (2022-only label) |

---

## Missing Value Summary

### 2014
| Column | NAs | % Missing | Reason |
|--------|-----|-----------|--------|
| `INSULIN` / `Insulin` | 408,070 | 94.5% | BRFSS skip — asked only of diabetics |
| `MENTHLTH` | 308,518 | 71.4% | BRFSS skip pattern |
| `PHYSHLTH` | 287,489 | 66.6% | BRFSS skip pattern |
| `SLEPTIM1` | 157,002 | 36.4% | BRFSS skip pattern |
| `X_INCOMG` / `Income` | 56,589 | 13.1% | Non-response |
| `X_SMOKER3` / `Smoker` | 12,671 | 2.9% | Non-response |
| `X_RACEGR3` / `Race` | 6,200 | 1.4% | Non-response |
| `Diabetes_Binary` | **0** | 0% | ✅ Complete |

### 2022
| Column | NAs | % Missing | Reason |
|--------|-----|-----------|--------|
| `INSULIN1` / `Insulin` | 296,797 | 97.0% | BRFSS skip — asked only of diabetics |
| `MENTHLTH` | 188,469 | 61.6% | BRFSS skip pattern |
| `PHYSHLTH` | 194,002 | 63.4% | BRFSS skip pattern |
| `SLEPTIM1` | 108,692 | 35.5% | BRFSS skip pattern |
| `X_SMOKER3` / `Smoker` | 9,747 | 3.2% | Non-response |
| `X_RACEGR4` | 6,496 | 2.1% | Non-response |
| `X_HLTHPLN` / `Health_Insurance` | 7,281 | 2.4% | Non-response |
| `Diabetes_Binary` | **0** | 0% | ✅ Complete |

---

## Harmonization Map (for `02_harmonize_verify.R`)

| Concept | 2014 Raw | 2022 Raw | Harmonized Name | Action |
|---------|----------|----------|-----------------|--------|
| Diabetes (raw) | `DIABETE3` | `DIABETE4` | *(drop — use `Diabetes_Binary`)* | Drop both raw codes |
| Target | `Diabetes_Binary` | `Diabetes_Binary` | `Diabetes_Binary` | Keep as-is |
| Age | `X_AGE_G` | `X_AGE_G` | `X_AGE_G` | Keep as-is |
| Education | `X_EDUCAG` | `X_EDUCAG` | `X_EDUCAG` | Keep as-is |
| Income | `X_INCOMG` (1–5) | `X_INCOMG1` (1–6) | `X_INCOMG` | Recode 2022 codes 5+6 → 5; rename to `X_INCOMG` |
| Race | `X_RACEGR3` (1–5) | `X_RACEGR4` (1–5) | `X_RACEGR` | Rename both to `X_RACEGR` |
| General health | `GENHLTH` | `GENHLTH` | `GENHLTH` | Keep as-is |
| Physical health days | `PHYSHLTH` | `PHYSHLTH` | `PHYSHLTH` | Keep as-is |
| Mental health days | `MENTHLTH` | `MENTHLTH` | `MENTHLTH` | Keep as-is |
| Walk difficulty | `DIFFWALK` | `DIFFWALK` | `DIFFWALK` | Keep as-is |
| BMI (raw) | `X_BMI5` | `X_BMI5` | `X_BMI5` | Keep as-is |
| BMI category | `X_BMI5CAT` | `X_BMI5CAT` | `X_BMI5CAT` | Keep as-is |
| Heart disease | `CVDCRHD4` | `CVDCRHD4` | `CVDCRHD4` | Keep as-is |
| Stroke | `CVDSTRK3` | `CVDSTRK3` | `CVDSTRK3` | Keep as-is |
| Smoking | `X_SMOKER3` | `X_SMOKER3` | `X_SMOKER3` | Keep as-is |
| Physical activity | `X_TOTINDA` | `X_TOTINDA` | `X_TOTINDA` | Keep as-is |
| Alcohol | `DRNKANY5` | `DRNKANY6` | `DRNKANY` | Rename both to `DRNKANY` |
| Sleep | `SLEPTIM1` | `SLEPTIM1` | `SLEPTIM1` | Keep as-is |
| Insulin | `INSULIN` | `INSULIN1` | `INSULIN` | Rename 2022 to `INSULIN` |
| Health plan | `HLTHPLN1` | `X_HLTHPLN` | `HLTHPLN` | Rename both to `HLTHPLN` |
| Medical cost | `MEDCOST` | `MEDCOST1` | `MEDCOST` | Rename 2022 to `MEDCOST` |
| Sex | *(absent)* | `X_SEX` | *(drop)* | Drop — 2022-only |
| Year | *(absent)* | *(absent)* | `Year` | Add before row-bind: 2014 / 2022 |
