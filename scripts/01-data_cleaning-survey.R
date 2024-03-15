#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from Polarization Research Lab
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Download the America's Pulse Survey Data Week 3 Jan 12-19
# 2024 from Polarization Research Lab and save it to data/raw_data
# - Add it to the gitignore
# Any other information needed?

#### Workplace Setup ####
library(tidyverse)
library(janitor)
library(haven)
library(arrow)

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
    age_bracket = case_when(age < 30 ~ "18-29",
                            age < 45 ~ "30-44",
                            age < 60 ~ "45-59",
                            age >= 60 ~ "60+"),
    # explain how the vote_biden variable was calculated in the data section
    vote_biden = ifelse(((pid7 == "Not very strong Democrat" |
                           pid7 == "Lean Democrat" |
                           pid7 == "Strong Democrat") & presvote16post != "Donald Trump" & presvote20post != "Donald Trump"), 
                        1, 
                        0),
    vote24 = ifelse(((pid7 == "Not very strong Democrat" |
                        pid7 == "Lean Democrat" |
                        pid7 == "Strong Democrat" ) & presvote16post != "Donald Trump" & presvote20post != "Donald Trump"), 
                    "Joe Biden", 
                    "Donald Trump"),
    sex = ifelse(gender == "Female", "female", "male"),
    # create a races variable and do the same for the post stratification data
    races = case_when(race=="White" ~ "white",
                      race=="Black" ~ "black",
                      race=="Hispanic" ~ "other",
                      race=="Native American" ~ "native american",
                      race=="Asian" ~ "asian",
                      (race == "Middle Eastern" | race == "Other") ~ "other",
                      race == "Two or more races" ~ "mixed"
    ),
    # indicator variables for race
    race_white = ifelse(race == "White", 1, 0),
    race_asian = ifelse(race == "Asian", 1, 0),
    race_black = ifelse(race == "Black", 1, 0),
    race_hispanic = ifelse(race == "Hispanic", "hispanic", "not hispanic"),
    race_native = ifelse(race == "Native American", 1, 0),
    # indicator variable for whether they live in an urban or rural area
    urban = ifelse((urbanicity2 == "Big city"| urbanicity2 == "Smaller city"), "urban", "rural"),
  )


survey_analysis_data <- reduced_survey_data2 |>
  select(vote24, vote_biden, pid7, presvote16post, presvote20post, ideo5, birthyr, age, age_bracket, sex, races, race_white,
         race_asian, race_black, race_hispanic, race_native, marstat, educ, faminc_new,
         inputstate, urban)

# rename educ to education_level to make format match with poststratification data
survey_analysis_data <- survey_analysis_data|>
  rename(education_level = educ)

# # Apply state abbreviation to full name conversion using names_matcher
# survey_analysis_data <- survey_analysis_data %>%
#   left_join(names_matcher, by = c("state" = "inputstate")) %>%
#   mutate(state = stateicp) %>%
#   select(-stateicp)
# 
# # Now, state column has the full names of the states

survey_analysis_data <- survey_analysis_data |>
  rename(state = inputstate)

# make these categorical and match the post stratification formats
survey_analysis_data$sex <- as.factor(survey_analysis_data$sex)
survey_analysis_data$races <- as.factor(survey_analysis_data$races)
survey_analysis_data$state <- as.factor(survey_analysis_data$state)
survey_analysis_data$education_level <- as.factor(survey_analysis_data$education_level)
survey_analysis_data$faminc_new <- as.factor(survey_analysis_data$faminc_new)




# save survey analysis data as a parquet under data/analysis_data
# add it to the gitignore
write_parquet(survey_analysis_data, "data/analysis_data/survey_analysis_data.parquet")