#### Preamble ####
# Purpose: Simulate a data set where the chance that a person's preferred 
# presidential candidate is Joe Biden depends on age, gender, race, education,
# income, state, and whether they live in an urban area.
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# Any other information needed?


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)

set.seed(853)
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
          "hispanic", "pacific islander", "other")

genders_binary <- c("male", "female")

highest_education_level <- c("No high school",
                             "High school",
                             "2-year Diploma",
                             "Bachelor's Degree",
                             "Post-grad",
                             "Doctorate")

income_brackets <- c("Less than $10000",
                     "$10000 - $19999",
                     "$20000 - $29999",
                     "$30000 - $39999",
                     "$40000 - $49999",
                     "$50000 - $59999",
                     "$60000 - $69999",
                     "$70000 - $79999",
                     "$80000 - $99999",
                     "$100000 - $119999",
                     "$120000 - $149999",
                     "$150000 - $199999",
                     "$200000 - $249999",
                     "$250000 - $349999",
                     "$350000 - $499999",
                     "$500000 or more",
                     "Prefer not to say"
                     )


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
  education = sample(highest_education_level, size=num_obs, replace=TRUE),
  # income
  income = sample(income_brackets, size=num_obs, replace=TRUE),
  # state
  state = sample(us_states, size = num_obs, replace=TRUE),
  # urban or rural (1 if urban, 0 otherwise)
  urban = sample(1:0, size=num_obs, replace=TRUE)
)

#### Save data ####

# save as a parquet
write_parquet(simulated_survey_data, 
              "data/simulated_data/simulated_survey_data.parquet")

# save as a csv
write_csv(simulated_survey_data,
          "data/simulated_data/simulated_survey_data.csv")



