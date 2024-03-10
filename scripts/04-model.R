#### Preamble ####
# Purpose: Using logistic regression to estimate a model where binary support for 
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

#### Read Data ####
survey_analysis_data <- read_parquet("data/analysis_data/survey_analysis_data.parquet")

set.seed(853)

### Model Data ###

model1 <- 
  glm(
    formula = vote_biden ~ age + sex + races + education_level + faminc_new + inputstate + urban,
    data = survey_analysis_data,
    family = binomial(link = "logit")
    # prior = normal(location = 0, scale = 2.5, autoscale=TRUE),
    # prior_intercept = normal(location=0, scale=2.5, autoscale=TRUE),
    # seed = 853
  )

model2 <- 
  glm(
    formula = vote_biden ~ age + sex + races,
    data = survey_analysis_data
    # family = binomial(link = "logit"),
    # prior = normal(location = 0, scale = 2.5, autoscale=TRUE),
    # prior_intercept = normal(location=0, scale=2.5, autoscale=TRUE),
    # seed = 853
  )

#### Save Model ####

# #### Read data ####
# analysis_data <- read_csv("data/analysis_data/analysis_data.csv")
# 
# ### Model data ####

# 
# 
# #### Save model ####
# saveRDS(
#   first_model,
#   file = "models/first_model.rds"
# )
# 

