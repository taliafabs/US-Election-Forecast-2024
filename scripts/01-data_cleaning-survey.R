#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from ...
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Download and save the survey data from ---
# - Add the file to the gitignore
# Any other information needed?

#### Workplace Setup ####
library(janitor)
library(tidyverse)
# Read in the raw data
raw_survey_data <- read_csv("data/raw_data/2024_week3_Jan-12--Jan-19.csv")
# Add labels
raw_survey_data <- labelled::to_factor(raw_survey_data)

# Choose the variables that we want
reduced_survey_data <- raw_survey_data 