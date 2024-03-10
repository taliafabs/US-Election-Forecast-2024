#### Preamble ####
# Purpose: Simulate a data set where the chance that a person's preferred 
# presidential candidate is Joe Biden depends on ...write variables here!
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi Sundeep
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Download the ACS 2022 data and save it to data/raw_data
# - Add it to the gitignore
# Any other information needed?


#### Workplace Setup ####
library(tidyverse)
library(janitor)
library(haven)

# Read in the raw post stratification data
raw_poststrat_data <- read_dta("data/raw_data/usa_00001.dta")

# Add labels
raw_poststrat_data <- labelled::to_factor(raw_poststrat_data)

# Select relevant variables
reduced_poststrat_data1 <- raw_poststrat_data |>
  select(
    birthyr,
    age,
    sex,
    race,
    hispan,
    racwht,
    racasian,
    racblk,
    racamind,
    educ,
    marst,
    labforce,
    ftotinc,
    stateicp,
    metro
  )

# Make age numeric so that it is easier to group it into age brackets
reduced_poststrat_data1$age <- as.numeric(reduced_poststrat_data1$age)

# Make the income numeric so it can be grouped into income brackets
reduced_poststrat_data1$ftotinc <- as.numeric(reduced_poststrat_data1$ftotinc)

# Format the IPUMS ACS 2022 data to match the format of the survey data

# filter out any observation under age 18 since they are ineligible to vote
# filter out income of 9999999 because this indicates NA
reduced_poststrat_data2 <- reduced_poststrat_data1 |>
  filter(race != "two major races", 
         race != "three or more major races", 
         age >= 18) |>
  filter(!(is.na(age))) |>
  filter(ftotinc != 9999999) |>
  filter(!is.na(educ))

reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  mutate(
    sex = ifelse(sex == "female", 1, 0),
    races = case_when(race == "white" ~ "white",
                     race == "black/african american" ~ "black",
                     race == "chinese" ~ "asian",
                     race == "japanese" ~ "asian",
                     race == "other asian or pacific islander" ~ "asian",
                     race == "american indian or alaska native" ~ "native american",
                     race == "two major races" ~ "mixed",
                     race == "three or more major races" ~ "mixed",
                     race == "other race/, nec" ~ "other"

    ),
    race_white = ifelse(race=="white", 1, 0),
    race_asian = ifelse((race == "chinese" |
                           race == "japanese" |
                           race == "other asian or pacific islander"), 1, 0),
    race_black = ifelse(race == "black/african american", 1, 0),
    race_hispanic = ifelse((hispan == 1 | hispan == 2 | hispan == 3 | hispan == 4),
                           1,
                           0),
    race_native = ifelse(race == "american indian or alaska native", 1, 0),
    urban = ifelse((metro == "in metropolitan area: in central/principal city"|
                      metro == "in metropolitan area: not in central/principal city" |
                      metro == "in metropolitan area: central/principal city status indeterminable (mixed)"),
                   1, 0)
  )
    
reduced_poststrat_data2 <- reduced_poststrat_data2 %>%
  mutate(
    education_level = case_when(
      educ == "n/a or no schooling" ~ "No HS",
      educ == "nursery school to grade 4" ~ "No HS",
      educ == "grade 5, 6, 7, or 8" ~ "No HS",
      educ == "grade 9" ~ "No HS",
      educ == "grade 10" ~ "No HS",
      educ == "grade 11" ~ "No HS",
      educ == "grade 12" ~ "High school graduate",
      educ == "1 year of college" ~ "Some college",
      educ == "2 years of college" ~ "2-year",
      educ == "3 years of college" ~ "2-year",
      educ == "4 years of college" ~ "4-year",
      educ == "5+ years of college" ~ "Post-grad"
    )
  ) %>%
  mutate(
    faminc_new = case_when(ftotinc < 10000 ~ "Less than $10000",
                                    ftotinc < 20000 ~ "$10000 - $19999",
                                    ftotinc < 30000 ~ "$20000 - $29999",
                                    ftotinc < 40000 ~ "$30000 - $39999",
                                    ftotinc < 50000 ~ "$40000 - $49999",
                                    ftotinc < 60000 ~ "$50000 - $59999",
                                    ftotinc < 70000 ~ "$60000 - $69999",
                                    ftotinc < 80000 ~ "$70000 - $79999",
                                    ftotinc < 100000 ~ "$80000 - $99999",
                                    ftotinc < 120000 ~ "$100000 - $119999",
                                    ftotinc < 150000 ~ "$120000 - $149999",
                                    ftotinc < 200000 ~ "$150000 - $199999",
                                    ftotinc < 250000 ~ "$200000 - $249999",
                                    ftotinc < 350000 ~ "$250000 - $349999",
                                    ftotinc < 500000 ~ "$350000 - $499999",
                                    ftotinc >= 500000 ~ "$500000 or more")
    ) %>%
  mutate(
    age_bracket = case_when(age < 25 ~ "18-24",
                            age < 35 ~ "25-34",
                            age < 50 ~ "36-49",
                            age < 65 ~ "50-64",
                            age < 80 ~ "65-79",
                            age >= 80 ~ "80+")
  ) %>%
  mutate(
    urban = ifelse((metro == "in metropolitan area: in central/principal city"| 
                    metro == "in metropolitan area: not in central/principal city" |
                    metro == "in metropolitan area: central/principal city status indeterminable (mixed)"), "urban", "rural")) %>%
  mutate(
    sex = ifelse(sex == "female", "female", "male")
    )

# change variables into factors
reduced_poststrat_data2$races <- as.factor(reduced_poststrat_data2$races)
reduced_poststrat_data2$education_level <- as.factor(reduced_poststrat_data2$education_level)
reduced_poststrat_data2$faminc_new <- as.factor(reduced_poststrat_data2$faminc_new)
reduced_poststrat_data2$sex <- as.factor(reduced_poststrat_data2$sex)
# reduced_poststrat_data2$stateicp <- as.factor(reduced_poststrat_data2$stateicp)

poststrat_analysis_data <- reduced_poststrat_data2 |>
  select(birthyr, age, age_bracket, sex, races, race_white,
         race_asian, race_black, race_hispanic, race_native, educ, faminc_new,
         stateicp, urban)

# write post-stratification analysis data into data/analysis_data folder 


