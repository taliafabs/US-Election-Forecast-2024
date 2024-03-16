#### Preamble ####
# Purpose: Tests the survey and post-stratification data and the data cleaning steps
# Author: Talia Fabregas
# Date: 16 March 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Download the America's Pulse Survey Data Week 3 Jan 12-19
# 2024 from Polarization Research Lab and save it to data/raw_data
# - Run 01-data_cleaning-survey.R
# - Download the ACS 2022 Data from IPUMS
# - Run 01-data_cleaning-poststrat.R
# - Make sure the survey and poststrat data are added to gitignore


#### Work space setup ####
library(tidyverse)
library(testthat)
library(arrow)

# read in cleaned survey data
survey <- read_parquet("data/analysis_data/survey_analysis_data.parquet")
poststrat <- read_parquet("data/analysis_data/poststrat_analysis_data.parquet")

#### Test data ####

# Test that the vote_biden is equal to 1 or 0 for every observation
if(all(survey$vote_biden == 1 |survey$vote_biden==0)){
  "The survey voted_biden binary values are all 1 or 0"
} else{
  "At least one of the voted_biden values in the survey data is not 1 or 0"
}

# Test the only possible vote24 values are Joe Biden and Donald Trump
if(all(survey$vote24 == "Joe Biden" | survey$vote24 == "Donald Trump")){
  "The only possible 2024 vote choices present in the survey data are Biden and Trump"
} else{
  "There is an unexpected value present in vote24"
}


# Test that every respondent is age 18 or older
if(all(survey$age >= 18)){
  "All survey respondents are 18 or older as expected"
}else{
  "Not all survey respondents are 18 or older. Problem!"
}
if(all(poststrat$age >= 18)){
  "All poststrat individuals are 18 or older as expected"
}else{
  "Not all poststrat individuals are 18 or older. Problem!"
}


# Test that the categories of the races variable are correct for survey and poststrat

races_levels <- c("asian", "black", "mixed", "native american", "other", "white")

if(all(unique(survey$races) %in% races_levels)){
  "The survey races match the expected races"
} else{
  "Not all of the survey races match the expected races"
}

if(all(unique(poststrat$races) %in% races_levels)){
  "Poststrat race levels match the survey race levels"
}else{
  "Poststrat race levels do not all match the survey race levels. Problem!"
}

# Test that the categories of the urban variable are correct
urban_levels <- c("urban", "rural")

# survey
if(all(unique(survey$urban) %in% urban_levels)){
  "The survey urban values all match the expected urban levels"
}else{
  "Not all of the survey urban values match the expected urban levels"
}

# poststrat
if(all(unique(poststrat$urban) %in% urban_levels)){
  "The poststrat urban values all match the expected urban levels and the survey ones"
}else{
  "Not all of the poststrat urban values match the expected and survey urban levels. PROBLEM!"
}