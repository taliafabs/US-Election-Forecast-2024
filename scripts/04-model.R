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

# set seed for repoducibility
set.seed(853)

### Model Data ###
# model1 <- 
#   glm(
#     formula = vote_biden ~ age + sex + races + education_level + faminc_new + inputstate + urban,
#     data = survey_analysis_data,
#     family = binomial(link = "logit")
#     # prior = normal(location = 0, scale = 2.5, autoscale=TRUE),
#     # prior_intercept = normal(location=0, scale=2.5, autoscale=TRUE),
#     # seed = 853
#   )
# 
# model2 <- 
#   glm(
#     formula = vote_biden ~ age + sex + races,
#     data = survey_analysis_data,
#     family = binomial(link="logit")
#     # family = binomial(link = "logit"),
#     # prior = normal(location = 0, scale = 2.5, autoscale=TRUE),
#     # prior_intercept = normal(location=0, scale=2.5, autoscale=TRUE),
#     # seed = 853
#   )
# 
# model3 <- glm(
#   formula = vote_biden ~ age + sex + race_asian + race_black + race_hispanic + inputstate,
#   data = survey_analysis_data,
#   family = binomial(link = "logit") 
# )

# Want to explain vote choice based on various explanatory variables
# Use logistic regression
# Model fit, diagnostics,

# start with simpler model then make it more complicated if needed
# state seems to be causing the warnings but this is not something we want to exclude
presidential_vote_model <- stan_glm(
  formula = vote_biden ~ sex + age_bracket + races + education_level + state + urban,
  data = survey_analysis_data,
  family = binomial(link="logit"),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 853
)

# # alternative option
# # simpler model
# # does not take urban or rural into account
# presidential_vote_model1 <- stan_glm(
#   formula = vote_biden ~ sex + age_bracket + races + education_level + urban,
#   data = survey_analysis_data,
#   family = binomial(link="logit"),
#   prior = normal(location=0, scale=2.5, autoscale=TRUE),
#   prior_intercept = normal(location=0, scale=2.5, autoscale=TRUE),
#   seed = 853
# )
# 
# presidential_vote_model_state <- stan_glm(
#   formula = vote_biden ~ sex + age_bracket + state,
#   data = survey_analysis_data,
#   family = binomial(link="logit"),
#   prior = normal(location=0, scale=2.5, autoscale=TRUE),
#   prior_intercept = normal(location=0, scale=2.5, autoscale=TRUE),
#   seed = 853
# )

# coefficients <- broom::tidy(presidential_vote_model, conf.int = T)

#### Save Model ####

saveRDS(presidential_vote_model, file = "models/presidential_vote_model.rds")

modelsummary(presidential_vote_model)


