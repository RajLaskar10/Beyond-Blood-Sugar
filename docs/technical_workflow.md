# Technical Workflow — Code Skeletons

All skeletons below are starting points. Adjust column names and data types once the data audit (Phase 1) confirms actual structure.

## Phase 1: Data Audit Commands

Run in RStudio **one block at a time**. Post console output as a comment on the corresponding GitHub Issue.

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

dim(df_combined)            # Expect: 737,799 rows
colnames(df_combined)
sapply(df_combined, class)
```

**Block 6 — Combined dataset verification:**
```r
# Row count by year — must match source datasets exactly
table(df_combined$Year)     # Expect: 431877 for 2014, 305922 for 2022

# Any new NAs introduced by combining?
colSums(is.na(df_combined))

# Column name mismatches
setdiff(colnames(df_2014), colnames(df_combined))   # Missing from combined (expect none)
setdiff(colnames(df_2022), colnames(df_combined))   # Missing from combined (expect none)
setdiff(colnames(df_combined), colnames(df_2014))   # New in combined (expect: Year)
setdiff(colnames(df_combined), colnames(df_2022))   # New in combined (expect: Year)
```

**Block 7 — Spot-check categorical encoding consistency across years:**
```r
table(df_combined$GENHLTH, df_combined$Year)
table(df_combined$`_EDUCAG`, df_combined$Year)
table(df_combined$`_AGE_G`, df_combined$Year)
```

## Phase 4: Train/Test Split

```r
source("scripts/00_setup.R")

split_and_save <- function(df, name) {
  set.seed(SEED)
  idx   <- createDataPartition(df$Diabetes_Binary, p = 0.8, list = FALSE)
  train <- df[idx, ]
  test  <- df[-idx, ]

  write.csv(train, paste0(PATH_PROC, "train_", name, ".csv"), row.names = FALSE)
  write.csv(test,  paste0(PATH_PROC, "test_",  name, ".csv"), row.names = FALSE)

  cat(name, "- Train:", nrow(train), "Test:", nrow(test),
      "Train diabetes %:", round(mean(train$Diabetes_Binary) * 100, 1), "\n")
}

split_and_save(df_2014,     "2014")
split_and_save(df_2022,     "2022")
split_and_save(df_combined, "combined")
```

## Phase 5: Model Training

```r
# Logistic Regression
train_lr <- function(train_df, name) {
  model <- glm(Diabetes_Binary ~ ., data = train_df, family = "binomial")
  saveRDS(model, paste0(PATH_MODELS, "lr_", name, ".rds"))
  return(model)
}

# Random Forest (ranger via caret)
train_rf <- function(train_df, name) {
  set.seed(SEED)

  ctrl <- trainControl(
    method          = "cv",
    number          = 5,
    classProbs      = TRUE,
    summaryFunction = twoClassSummary
  )

  # Note: Diabetes_Binary must be a factor with valid R names for caret
  # e.g., "Diabetic" / "NonDiabetic" — not 0/1
  grid <- expand.grid(
    mtry          = c(3, 5, 7),
    splitrule     = "gini",
    min.node.size = c(10, 20, 50)
  )

  model <- train(
    Diabetes_Binary ~ .,
    data       = train_df,
    method     = "ranger",
    trControl  = ctrl,
    tuneGrid   = grid,
    metric     = "ROC",
    importance = "permutation"
  )

  saveRDS(model, paste0(PATH_MODELS, "rf_", name, ".rds"))
  return(model)
}
```

## Phase 6: Evaluation

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
  cm      <- confusionMatrix(as.factor(preds), as.factor(test_df$Diabetes_Binary), positive = "1")

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

## Phase 7: LR Coefficient Comparison

```r
library(broom)

# Extract tidy coefficient tables
coef_2014 <- tidy(lr_2014, conf.int = TRUE) %>%
  rename(estimate_2014  = estimate,
         p_2014         = p.value,
         conf_low_2014  = conf.low,
         conf_high_2014 = conf.high) %>%
  select(term, estimate_2014, p_2014, conf_low_2014, conf_high_2014)

coef_2022 <- tidy(lr_2022, conf.int = TRUE) %>%
  rename(estimate_2022  = estimate,
         p_2022         = p.value,
         conf_low_2022  = conf.low,
         conf_high_2022 = conf.high) %>%
  select(term, estimate_2022, p_2022, conf_low_2022, conf_high_2022)

# Join and compare
coef_comparison <- coef_2014 %>%
  inner_join(coef_2022, by = "term") %>%
  mutate(
    sig_2014    = p_2014 < 0.05,
    sig_2022    = p_2022 < 0.05,
    sig_changed = sig_2014 != sig_2022,
    coef_change = estimate_2022 - estimate_2014
  ) %>%
  arrange(desc(abs(coef_change)))

write.csv(coef_comparison,
          paste0(PATH_TABLES, "lr_coefficient_comparison.csv"),
          row.names = FALSE)
```

`lr_2014` and `lr_2022` are the loaded model objects from `outputs/models/lr_2014.rds` and `lr_2022.rds`.
