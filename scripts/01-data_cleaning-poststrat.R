#### Preamble ####
# Purpose: Simulate a data set where the chance that a person's preferred 
# presidential candidate is Joe Biden depends on ...write variables here!
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi Sundeep
# Date: 5 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Download the ACS 2022 data and save it to data/raw_data
# - Gitignore it
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

