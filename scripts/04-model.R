#### Preamble ####
# Purpose: Use logistic regression to estimate a model where binary support for
# President Joe Biden (D) versus GOP nominee Donald Trump is explained by
# age, gender, race, education,
# Using logistic regression to estimate a model where binary support for 
# President Joe Biden versus GOP nominee Donald Trump is explained by age, gender, race
# education, marital status, employment, income, state, and urban
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi Sundeep
# Date: 8 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 01-data_cleaning-survey.R
# Any other information needed? 

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)
library(modelsummary)

#### Read Data ####
survey_analysis_data <- read_parquet("data/analysis_data/survey_analysis_data.parquet")

# set seed for reproducibility
set.seed(853)

### Model Data ###

# Want to explain vote choice based on various explanatory variables
# Use logistic regression
# Model fit, diagnostics,

# start with simpler model then make it more complicated if needed
# state seems to be causing the warnings but this is not something we want to exclude
# removed state for now
presidential_vote_model <- stan_glm(
  formula = vote_biden ~ sex + age_bracket + races + education_level + urban,
  data = survey_analysis_data,
  family = binomial(link="logit"),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 853
)

# coefficients <- broom::tidy(presidential_vote_model, conf.int = T)

#### Save Model ####

saveRDS(presidential_vote_model, file = "models/presidential_vote_model.rds")

modelsummary(presidential_vote_model)


