#### Preamble ####
# Purpose: Simulate a data set where the chance that a person's preferred 
# presidential candidate is Joe Biden depends on age, gender, race, education,
# state, and whether they live in an urban area.
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi Sandeep
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: None


#### Workspace setup ####
# install.packages("arrow")
library(tidyverse)
library(janitor)
library(arrow)

# set seed for reproducibility
set.seed(853)

# set the number of observations to 1000
num_obs <- 1000

us_states <- c(
  "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", 
  "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", 
  "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
  "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", 
  "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", 
  "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
  "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", 
  "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", 
  "Washington", "West Virginia", "Wisconsin", "Wyoming"
)

candidates <- c("Joe Biden", "Donald Trump")

races <- c("white","black", "asian", "middle eastern", "native american",
          "hispanic", "pacific islander", "other", "chinese", "japanese", 
          "asian", "south asian")

genders_binary <- c("male", "female")

highest_education_level <- c("No HS",
                             "High school graduate",
                             "Some college",
                             "2-year",
                             "4-year",
                             "Post-grad")

urban_or_rural <- c("urban", "rural")



#### Simulate data ####
simulated_survey_data <- tibble(
  # preferred candidate
  preferred_candidate <- sample(candidates, size=num_obs, replace=TRUE),
  # age
  age = sample(18:99, size=num_obs, replace=TRUE),
  # gender
  gender = sample(genders_binary, size = num_obs, replace = TRUE, 
                  prob = c(0.5, 0.5)),
  # race
  race = sample(races, size = num_obs, replace = TRUE),
  # highest level of education
  education_level = sample(highest_education_level, size=num_obs, replace=TRUE),
  # state
  state = sample(us_states, size = num_obs, replace=TRUE),
  # urban or rural (1 if urban, 0 otherwise)
  urban = sample(urban_or_rural, size=num_obs, replace=TRUE)
)

simulated_survey_data$race <- as.factor(simulated_survey_data$race)
simulated_survey_data$education_level <- as.factor(simulated_survey_data$education_level)

#### Save data ####

# save as a parquet under data/simulated_data
write_parquet(simulated_survey_data, 
              "data/simulated_data/simulated_survey_data.parquet")

# save as a csv under data/simulated_data
write_csv(simulated_survey_data,
          "data/simulated_data/simulated_survey_data.csv")



