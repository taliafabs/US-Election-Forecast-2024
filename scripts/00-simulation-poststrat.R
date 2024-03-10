#### Preamble ####
# Purpose: Simulate a post stratification data set containing information about
# ...
# presidential candidate is Joe Biden depends on ...write variables here!
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi Sundeep
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 

#### Workspace Setup ####
library(tidyverse)
library(janitor)

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




# poststrat_analysis_data <- reduced_poststrat_data2 |>
#   select(birthyr, age, age_bracket, sex, races, race_white,
#          race_asian, race_black, race_hispanic, race_native, educ, faminc_new,
#          stateicp, urban)


