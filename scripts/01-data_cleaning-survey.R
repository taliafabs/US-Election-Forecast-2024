#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from ...
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Download the America's Pulse Survey Data Week 3 Jan 12-19
# 2024 from Polarization Research Lab and save it to data/raw_data
# - Add the file to the gitignore
# Any other information needed?

#### Workplace Setup ####
library(tidyverse)
library(janitor)
library(haven)

# Read in the raw data
raw_survey_data <- read_csv("data/raw_data/2024_week3_Jan-12--Jan-19.csv")
# Add labels
raw_survey_data <- labelled::to_factor(raw_survey_data)

# add an age column
raw_survey_data <- raw_survey_data |>
  mutate(age = 2024 - birthyr)

# Select relevant columns
reduced_survey_data1 <- raw_survey_data |>
  select(pid3,
         pid7,
         presvote16post,
         presvote20post,
         ideo5,
         birthyr,
         age,
         gender,
         race,
         hispanic,
         educ,
         marstat,
         employ, 
         faminc_new,
         inputstate,
         urbanicity2
         )

# clean state names to match IPUMS ACS post stratification data set
names_matcher <- tibble(stateicp = state.name, inputstate = state.abb)

# Filter out people who:
#   - 1. have no party affiliation or leaning  
#   - 2. did not vote for Trump or Biden in 2020
# it is not practical to decipher their 2024 vote choice from this survey data set.

reduced_survey_data2 <- reduced_survey_data1 |>
  filter(presvote20post == "Joe Biden" | 
           presvote20post == "Donald Trump" |
           pid7 != "Independent")

reduced_survey_data2 <- reduced_survey_data2 |>
  mutate(
    age_groups = case_when(age < 25 ~ "18-24",
                           age < 35 ~ "25-34",
                           age < 50 ~ "36-49",
                           age < 65 ~ "50-64",
                           age < 80 ~ "65-79",
                           age >= 80 ~ "80+"),
    vote_biden = ifelse((presvote20post == "Joe Biden" | 
                           pid7 == "Not very strong Democrat" |
                           pid7 == "Lean Democrat" |
                           pid7 == "Strong Democrat"), 
                        1, 
                        0),
    sex = ifelse(gender == "Female", 1, 0),
    # indicator variables for race
    race_white = ifelse(race == "White", 1, 0),
    race_asian = ifelse(race == "Asian", 1, 0),
    race_black = ifelse(race == "Black", 1, 0),
    race_hispanic = ifelse(race == "Hispanic", 1, 0),
    race_native = ifelse(race == "Native American", 1, 0),
    race_mideast = ifelse(race == "Middle Eastern", 1, 0),
    urban = ifelse((urbanicity2 == "Big city"| urbanicity == "Smaller city"), 1, 0)
  )

# do something with the education level here
# reduced_survey_data2 |> 
#   mutate(
#     education_level = casewhen(
#       
#     )
#   )
