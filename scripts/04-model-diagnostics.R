#### Preamble ####
# Purpose: Calculate 
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
library(MASS)

#### Read Data ####
survey_analysis_data <- read_parquet("data/analysis_data/survey_analysis_data.parquet")

presidential_vote_model <-
  readRDS(file = "models/presidential_vote_model.rds")

# prior summary
prior_summary(presidential_vote_model)

# prior predictive checks
prior_parameters <- list(
  Intercept = c(median = 1.8, mad_sd = 3.7),
  sexmale = c(median = -0.6, mad_sd = 0.2),
  age_bracket_30_44 = c(median = -0.5, mad_sd = 0.3),
  age_bracket_45_59 = c(median = -0.7, mad_sd = 0.3),
  age_bracket_60_plus = c(median = -0.7, mad_sd = 0.3),
  races_hispanic = c(median = 0.0, mad_sd = 3.6),
  races_mixed = c(median = -0.3, mad_sd = 3.6),
  races_native_american = c(median = 0.2, mad_sd = 3.8),
  races_other = c(median = -0.4, mad_sd = 3.7),
  races_white = c(median = -0.4, mad_sd = 3.6),
  race_black = c(median = 1.1, mad_sd = 3.6),
  education_level_4_year = c(median = 0.5, mad_sd = 0.3),
  education_level_high_school_graduate = c(median = -0.2, mad_sd = 0.3),
  education_level_no_HS = c(median = 0.6, mad_sd = 0.5),
  education_level_post_grad = c(median = 1.2, mad_sd = 0.3),
  education_level_some_college = c(median = 0.0, mad_sd = 0.3),
  urban_urban = c(median = 0.7, mad_sd = 0.2),
  state_Alaska = c(median = -0.8, mad_sd = 1.7),
                       state_Arizona = c(median = -1.5, mad_sd = 1.0),
                       state_Arkansas = c(median = -0.2, mad_sd = 1.1),
                       state_California = c(median = -0.3, mad_sd = 0.9),
                       state_Colorado = c(median = -0.8, mad_sd = 1.0),
                       state_Connecticut = c(median = 1.3, mad_sd = 1.6),
                       state_Delaware = c(median = -1.5, mad_sd = 1.5),
                       state_District_of_Columbia = c(median = 34.4, mad_sd = 31.6),
                       state_Florida = c(median = -0.9, mad_sd = 0.9),
                       state_Georgia = c(median = -0.6, mad_sd = 1.0),
                       state_Hawaii = c(median = -2.2, mad_sd = 1.4),
                       state_Idaho = c(median = -0.8, mad_sd = 1.5),
                       state_Illinois = c(median = -0.8, mad_sd = 0.9),
                       state_Indiana = c(median = -0.3, mad_sd = 1.0),
                       state_Iowa = c(median = -1.3, mad_sd = 1.1),
                       state_Kansas = c(median = 24.8, mad_sd = 21.7),
                       state_Kentucky = c(median = -1.3, mad_sd = 1.0),
                       state_Louisiana = c(median = -1.3, mad_sd = 1.1),
                       state_Maine = c(median = -2.0, mad_sd = 1.7),
                       state_Maryland = c(median = 0.5, mad_sd = 1.3),
                       state_Massachusetts = c(median = 1.2, mad_sd = 1.2),
                       state_Michigan = c(median = -1.2, mad_sd = 0.9),
                       state_Minnesota = c(median = -0.6, mad_sd = 1.1),
                       state_Mississippi = c(median = -0.7, mad_sd = 1.3),
                       state_Missouri = c(median = -1.0, mad_sd = 1.0),
                       state_Montana = c(median = -0.7, mad_sd = 2.0),
                       state_Nebraska = c(median = -0.8, mad_sd = 1.9),
                       state_Nevada = c(median = -1.4, mad_sd = 1.2),
                       state_New_Hampshire = c(median = 0.1, mad_sd = 1.3),
                       state_New_Jersey = c(median = -0.3, mad_sd = 1.0),
                       state_New_Mexico = c(median = -1.5, mad_sd = 1.3),
                       state_New_York = c(median = -0.4, mad_sd = 0.9),
                       state_North_Carolina = c(median = -1.6, mad_sd = 1.0),
                       state_North_Dakota = c(median = -0.5, mad_sd = 1.9),
                       state_Ohio = c(median = -0.7, mad_sd = 1.0),
                       state_Oklahoma = c(median = -2.2, mad_sd = 1.2),
                       state_Oregon = c(median = 0.2, mad_sd = 1.1),
                       state_Pennsylvania = c(median = -0.3, mad_sd = 0.9),
                       state_Rhode_Island = c(median = -39.5, mad_sd = 32.7),
                       state_South_Carolina = c(median = -0.9, mad_sd = 1.0),
                       state_South_Dakota = c(median = -1.1, mad_sd = 1.4),
                       state_Tennessee = c(median = -1.4, mad_sd = 1.0),
                       state_Texas = c(median = -0.4, mad_sd = 0.9),
                       state_Utah = c(median = -2.4, mad_sd = 1.6),
                       state_Virginia = c(median = -1.6, mad_sd = 1.0),
                       state_Washington = c(median = -0.1, mad_sd = 1.0),
                       state_West_Virginia = c(median = -0.6, mad_sd = 1.3),
                       state_Wisconsin = c(median = -0.1, mad_sd = 1.1),
                       state_Wyoming = c(median = 49.0, mad_sd = 43.7))


num_samples <- 1000


# generate prior samples
generate_prior_samples <- function(parameters) {
  prior_samples <- list()
  for (predictor in names(parameters)) {
    median <- parameters[[predictor]]["median"]
    mad_sd <- parameters[[predictor]]["mad_sd"]
    prior_samples[[predictor]] <- mvrnorm(n = num_samples, mu = median, Sigma = mad_sd^2)
  }
  return(prior_samples)
}

priors <- generate_prior_samples(prior_parameters)

# checking the priors
for (predictor in names(priors)) {
  cat("Prior samples for", predictor, ":", priors[[predictor]], "\n")
}


# (a) Posterior prediction check
posterior_prediction_check <- pp_check(presidential_vote_model) +
  theme_classic() +
  theme(legend.position = "bottom")

# (b) Comparing the posterior with the prior
posterior_vs_prior_plot <- posterior_vs_prior(presidential_vote_model) +
  theme_minimal() +
  theme(legend.position = "bottom") +
  coord_flip()

# confidence interval visualizations
ci_plot <- plot(
  presidential_vote_model,
  "areas"
)

# Checking the convergence of the MCMC algorithm
# (a) trace plot
trace_plot <- plot(presidential_vote_model, "trace")

# (b) rhat plot
rhat_plot <- plot(presidential_vote_model, "rhat")

# final plots to be called in paper.qmd:
# 1.posterior_prediction_check
# 2. posterior_vs_prior_plot
# 3. trace_plot
# 4. rhat_plot


