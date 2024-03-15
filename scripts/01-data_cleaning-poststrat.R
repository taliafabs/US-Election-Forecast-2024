#### Preamble ####
# Purpose: Prepare and clean the post-stratification data downloaded from IPUMS
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
library(arrow)

# Read in the raw post stratification data
raw_poststrat_data <- read_dta("data/raw_data/usa_00001.dta")


# Add labels
raw_poststrat_data <- labelled::to_factor(raw_poststrat_data)

raw_poststrat_data <- raw_poststrat_data |>
  filter(stateicp != "state not identified")

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

names_matcher <- tibble(stateicp = state.name, inputstate = state.abb)

# Make age numeric so that it is easier to group it into age brackets
reduced_poststrat_data1$age <- as.numeric(reduced_poststrat_data1$age)

# Make the income numeric so it can be grouped into income brackets
reduced_poststrat_data1$ftotinc <- as.numeric(reduced_poststrat_data1$ftotinc)

# Format the IPUMS ACS 2022 data to match the format of the survey data

# filter out any observation under age 18 since they are ineligible to vote
# filter out income of 9999999 because this indicates NA

reduced_poststrat_data2 <- reduced_poststrat_data1 |>
  filter(!is.na(age))

reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  filter(age >= 18)

reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  filter(ftotinc != 9999999)

reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  filter(!is.na(educ))

reduced_poststrat_data2 <- reduced_poststrat_data2 |> 
  filter(stateicp != "state not identified")

reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  mutate(
    sex = ifelse(sex == "female", "female", "male"),
    races = case_when(race == "white" ~ "white",
                     race == "black/african american" ~ "black",
                     race == "chinese" ~ "asian",
                     race == "japanese" ~ "asian",
                     race == "other asian or pacific islander" ~ "asian",
                     race == "american indian or alaska native" ~ "native american",
                     race == "two major races" ~ "mixed",
                     race == "three or more major races" ~ "mixed",
                     race == "other race, nec" ~ "other"
    ),
    race_white = ifelse(race=="white", 1, 0),
    race_asian = ifelse((race == "chinese" |
                           race == "japanese" |
                           race == "other asian or pacific islander"), 1, 0),
    race_black = ifelse(race == "black/african american", 1, 0),
    race_hispanic = ifelse((hispan == "mexican" | hispan == "other" | hispan == "puerto rican" | hispan == "cuban"),
                           "hispanic",
                           "not hispanic"),
    race_native = ifelse(race == "american indian or alaska native", 1, 0),
    urban = ifelse((metro == "in metropolitan area: in central/principal city"|
                      metro == "in metropolitan area: not in central/principal city" |
                      metro == "in metropolitan area: central/principal city status indeterminable (mixed)"),
                   "urban", "rural")
  )

reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  filter(!is.na(educ) & educ != "n/a or no schooling") # Exclude missing values and "n/a or no schooling"

reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  mutate(
    education_level = case_when(
      educ %in% c("nursery school to grade 4", "grade 5, 6, 7, or 8", "grade 9", "grade 10", "grade 11") ~ "No HS",
      educ == "grade 12" ~ "High school graduate",
      educ %in% c("1 year of college", "2 years of college", "3 years of college") ~ "Some college",
      educ == "4 years of college" ~ "4-year",
      educ == "5+ years of college" ~ "Post-grad"
    ),
    faminc_new = cut(ftotinc,
                     breaks = c(-Inf, 10000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 100000, 120000, 150000, 200000, 250000, 350000, 500000, Inf),
                     labels = c("Less than $10000", "$10000 - $19999", "$20000 - $29999", "$30000 - $39999", "$40000 - $49999", "$50000 - $59999", "$60000 - $69999", "$70000 - $79999", "$80000 - $99999", "$100000 - $119999", "$120000 - $149999", "$150000 - $199999", "$200000 - $249999", "$250000 - $349999", "$350000 - $499999", "$500000 or more"),
                     include.lowest = TRUE)
  ) %>%
  mutate(
    age_bracket = case_when(age < 30 ~ "18-29",
                            age < 45 ~ "30-44",
                            age < 60 ~ "45-59",
                            age >= 60 ~ "60+"),
    urban = ifelse(metro %in% c("in metropolitan area: in central/principal city", "in metropolitan area: not in central/principal city", "in metropolitan area: central/principal city status indeterminable (mixed)"), "urban", "rural"),
    sex = ifelse(sex == "female", "female", "male")
  )

# remove observations with NA in any of the variables
reduced_poststrat_data2 <- reduced_poststrat_data2 |>
  filter(!is.na(races)) |>
  filter(!is.na(stateicp)) |>
  filter(!is.na(sex)) |>
  filter(!is.na(age_bracket)) |>
  filter(!is.na(urban))

# Convert variables into factors
reduced_poststrat_data2$races <- as.factor(reduced_poststrat_data2$races)
reduced_poststrat_data2$education_level <- factor(reduced_poststrat_data2$education_level, levels = c("No HS", 
                                                                                                      "High school graduate", 
                                                                                                      "Some college", 
                                                                                                      "4-year", 
                                                                                                      "Post-grad"))
reduced_poststrat_data2$faminc_new <- as.factor(reduced_poststrat_data2$faminc_new)
reduced_poststrat_data2$sex <- as.factor(reduced_poststrat_data2$sex)
reduced_poststrat_data$stateicp <- as.factor(reduced_poststrat_data$stateicp)


poststrat_analysis_data <- reduced_poststrat_data2 |>
  select(birthyr, age, age_bracket, sex, races, race_white,
         race_asian, race_black, race_hispanic, race_native, education_level, faminc_new,
         stateicp, urban)


# rename stateicp to state to match survey data
poststrat_analysis_data <- poststrat_analysis_data |>
  rename(state = stateicp)

# write post-stratification analysis data into data/analysis_data folder 
# add it to the gitignore
write_parquet(poststrat_analysis_data, "data/analysis_data/poststrat_analysis_data.parquet")

