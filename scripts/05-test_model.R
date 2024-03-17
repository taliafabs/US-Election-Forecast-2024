#### Preamble ####
# Purpose: Test the model
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi Sundeep
# Date: 8 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 01-data_cleaning-survey.R and 03-model.R first
# Any other information needed? 

#### Workplace Setup ####
library(tidyverse)

#### Read Data ####
survey_analysis_data <- read_parquet("data/analysis_data/survey_analysis_data.parquet")

presidential_vote_model <-
  readRDS(file = "models/presidential_vote_model.rds")

# prior summary
prior_summary(presidential_vote_model)

# TESTING THE MODEL'S CLASSES
# Check Classes Exist
classes <- unique(survey_analysis_data$vote24)
if (!all(classes %in% c("Donald Trump", "Joe Biden"))) {
  stop("Classes are not properly defined")
} else {
  print("Classes are properly defined")
}
# should be - Classes are properly defined

# Testing the proportion of Trump / Biden classes (should be roughly close to each other)
test_trump_biden_class_balance <- function(data, class_column) {
  class_proportions <- prop.table(table(data[[class_column]]))
  balanced <- all(abs(diff(class_proportions)) < 0.1) 
  
  if (balanced) {
    print("Classes are balanced")
  } else {
    print("Classes are not balanced")
  }
  
  return(class_proportions)
}

# Test class balance using the function
class_proportions <- test_trump_biden_class_balance(survey_analysis_data, "vote24")
print("Class Proportions:")
print(class_proportions)


# TESTING THE MODEL'S NUMBER OF OBSERVTIONS:
# Total Number of Observations
total_observations <- nrow(survey_analysis_data)
print(paste("Total number of observations:", total_observations))

# Number of Observations per Class
for (class in classes) {
  class_count <- sum(survey_analysis_data$vote24 == class)
  print(paste("Number of observations for", class, ":", class_count))
}

additional_observation_tests <- function(data) {
  # Minimum and maximum number of observations per class
  min_obs_per_class <- min(table(data$vote24))
  max_obs_per_class <- max(table(data$vote24))
  print(paste("Minimum number of observations per class:", min_obs_per_class))
  print(paste("Maximum number of observations per class:", max_obs_per_class))
  
  # Percentage of missing values
  missing_percentage <- mean(is.na(data)) * 100
  print(paste("Percentage of missing values:", missing_percentage, "%"))
  
  # Distribution of categorical variables (excluding target variable)
  categorical_vars <- sapply(data, is.factor)
  categorical_vars <- names(categorical_vars[categorical_vars])
  categorical_distribution <- lapply(data[categorical_vars], table)
  check_zero_occurrences_cat(categorical_distribution)
}

check_zero_occurrences_cat <- function(categorical_distribution) {
  for (i in seq_along(categorical_distribution)) {
    zero_occurrences <- sum(categorical_distribution[[i]] == 0)
    if (zero_occurrences > 0) {
      cat("Warning: Category with zero occurrences found in variable:", names(categorical_distribution)[i], "\n")
    }
    else {
      cat(names(categorical_distribution)[i], "has non-zero occurences", "\n")
    }
  }
}

additional_observation_tests(survey_analysis_data)


# TESTING THE MODEL'S COEFFIENCIENTS:
# 1. DEFINING THE COEFFIENCIENTS AND SEs from presidential_vote_model

coefficients_pres <- c(0.4, -0.4, -0.4, -0.4, -0.4, 0.7, 0.1, 0.7, 
                       0.0, -0.2, 0.2, -0.1, 0.2, 0.6, -0.1, 0.5)

standard_errors <-c(0.6, 0.1, 0.2, 0.2, 0.2, 0.6, 0.7, 1.1, 0.5, 
                    0.5, 0.3, 0.2, 0.5, 0.3, 0.3, 0.1)


# ensure the length is the same
length(standard_errors)
length(coefficients_pres)

# 2. CALCULATING THE T-VALUES
t_values <- coefficients_pres / standard_errors


# 3. CALCULATING THE P-VALUES
p_values <- 2 * pt(-abs(t_values), df = length(coefficients_pres) - 1)


# 4. CALCULATING THE CI - 95%
# Degrees of freedom for the t-distribution
df <- length(coefficients_pres) - 1

# Critical value from t-distribution for 95% confidence level
t_critical <- qt(0.975, df)

# Calculate lower and upper bounds of the 95% confidence interval for each coefficient
CI_lower <- coefficients_pres - t_critical * standard_errors
CI_upper <- coefficients_pres + t_critical * standard_errors


# 5. PRESENTING THE RESULTS
results <- data.frame(
  Estimate = coefficients_pres,
  SE = standard_errors,
  t_value = t_values,
  p_value = p_values,
  CI_lower = CI_lower,
  CI_upper = CI_upper
)

# Print the results
print(results)

# ADDITIONAL MODEL TESTS
any(summary(presidential_vote_model)[, "Rhat"] > 1.1)
# Should be false







