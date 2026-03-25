# 00_setup.R
# Core configuration script for Beyond Blood Sugar

# 1. Package Installation & Verification
# Function to check and install missing packages
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    cat("Installing missing packages:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, repos = "http://cran.us.r-project.org")
  } else {
    cat("All required packages are already installed.\n")
  }
}

required_packages <- c(
  "tidyverse",  # data manipulation and ggplot2
  "caret",      # train/test split, cv, confusionMatrix
  "ranger",     # fast random forest
  "pROC",       # AUC-ROC computation
  "vip",        # permutation-based feature importance
  "ROSE",       # class imbalance handling
  "corrplot",   # correlation heatmaps
  "scales",     # label formatting in ggplot
  "knitr",      # tables in Rmd
  "kableExtra"  # styled tables in Rmd
)

install_if_missing(required_packages)

# Load libraries
suppressPackageStartupMessages({
  library(tidyverse)
  library(caret)
  library(ranger)
  library(pROC)
  library(vip)
  library(ROSE)
  library(corrplot)
  library(scales)
  library(knitr)
  library(kableExtra)
})

# 2. Path Configurations
PATH_RAW    <- "data/raw/"
PATH_PROC   <- "data/processed/"
PATH_FIG    <- "outputs/figures/"
PATH_TABLES <- "outputs/tables/"
PATH_MODELS <- "outputs/models/"

# 3. Constants
SEED <- 42

# 4. Color Palette
COLOR_DIABETES  <- "#E07A5F"  # coral/red for diabetic
COLOR_NO_DIAB   <- "#81B29A"  # teal/green for non-diabetic
COLOR_2014      <- "#3D405B"  # dark blue-gray for 2014
COLOR_2022      <- "#F2CC8F"  # warm gold for 2022

# Ensure seed is set when this script is sourced
set.seed(SEED)
cat("Project environment loaded successfully. Seed is set to", SEED, "\n")
