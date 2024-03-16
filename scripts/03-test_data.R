#### Preamble ####
# Purpose: Tests the survey data
# Author: Talia Fabregas
# Date: 16 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Download the America's Pulse Survey Data Week 3 Jan 12-19
# 2024 from Polarization Research Lab and save it to data/raw_data
# - Run data_cleaning-survey.R
# - Make sure the survey data is added to gitignore


#### Workspace setup ####
library(tidyverse)
library(arrow)

# read in cleaned survey data
survey <- read_parquet("data/analysis_data/survey_analysis_data.parquet")

#### Test data ####

# Test the categorical variables

# Test that every respondent is 18 years of age or older