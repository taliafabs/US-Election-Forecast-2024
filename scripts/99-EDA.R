#### Preamble ####
# Purpose: Exploratory data analysis for the paper
# Author: Talia Fabregas, Fatimah Yunusa, Aamishi Avarsekar
# Date: 10 March 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Pre-requisites:
# - Download
# - todo(?) add it to gitignore


# packages
library(tidyverse)
library(knitr)
library(broom) ## Needed to make the regression output 'tidy'
library(ggplot2)
library(dplyr)
library(readr)

install.packages("reshape2")
library(reshape2)
# raw_data <- read.csv("raw_data.csv")


# filter the variables that could be interesting
#### Read Data ####
survey_analysis_data <- read_parquet("Users/aamishiavarsekar/UofT/4th/WINTER_2024/PAPER_3/US-Election-Forecast-2024/data/analysis_data/survey_analysis_data.parquet")
first_look_vars <- c("vote_biden", "pid7", "presvote16post", "presvote20post", "ideo5",
                     "birthyr", "age", "age_bracket", "sex", "races", "marstat", "education_level",
                     "faminc_new", "state", "urban")
first_look <- survey_analysis_data


# remove N/A and stuff
first_look_clean <- na.omit(survey_analysis_data)


# unique values
age_bracket_uniq <- unique(first_look_clean$age_bracket)
urban_uniq <- unique(first_look_clean$urban)
presvote16post_uniq <- unique(first_look_clean$presvote16post)
presvote20post_uniq <- unique(first_look_clean$presvote20post)
vote24_uniq <- unique(first_look_clean$vote24)
sex_uniq <- unique(first_look_clean$sex)
races_uniq <- unique(first_look_clean$races)
education_level_uniq <- unique(first_look_clean$education_level)
urban_uniq <- unique(first_look_clean$urban)


# categorical -> numerical
first_look_maps <- first_look_clean |>
  mutate(urban = case_when(
    urban == "urban" ~ 1,
    urban == "rural" ~ 2,
    TRUE ~ NA_integer_
  )) |>
  
  mutate(presvote20post = case_when(
    presvote20post == "Joe Biden" ~ 1,
    presvote20post == "Jo Jorgensen" ~ 2,
    presvote20post == "Donald Trump" ~ 3,
    presvote20post == "Howie Hawkins" ~ 4,
    presvote20post == "Did not vote for President" ~ 5,
    presvote20post == "Evan McMullin" ~ 6,
    TRUE ~ NA_integer_
  )) |>
  
  mutate(presvote16post = case_when(
    presvote16post == "Hillary Clinton" ~ 1,
    presvote16post == "Donald Trump" ~ 2,
    presvote16post == "Did not vote for President" ~ 3,
    presvote16post == "Jill Stein" ~ 4,
    presvote16post == "Gary Johnson" ~ 5,
    presvote16post == "Evan McMullin" ~ 6,
    presvote16post == "Other" ~ 7,
    TRUE ~ NA_integer_
  )) |>
  mutate(sex = case_when(
    sex == "male" ~ 1,
    sex == "female" ~ 2,
    TRUE ~ NA_integer_
  )) |>
  
  mutate(vote24 = case_when(
    vote24 == "Joe Biden" ~ 1,
    vote24 == "Donald Trump" ~ 2,
    TRUE ~ NA_integer_
  )) |>
  
  mutate(age_bracket = case_when(
    age_bracket == "18-29" ~ 1,
    age_bracket == "30-44" ~ 2,
    age_bracket == "45-59" ~ 3,
    age_bracket == "60+" ~ 4,
    TRUE ~ NA_integer_
  )) |>
  
  mutate(races = case_when(
    races == "white" ~ 1,
    races == "other" ~ 2,
    races == "asian" ~ 3,
    races == "black" ~ 4,
    races == "mixed" ~ 5,
    races == "native american" ~ 6,
    TRUE ~ NA_integer_
  )) |>
  
  mutate(education_level = case_when(
    education_level == "No HS" ~ 1,
    education_level == "2-year" ~ 2,
    education_level == "4-year" ~ 3,
    education_level == "Post-grad" ~ 4,
    education_level == "High school graduate" ~ 5,
    education_level == "Some college" ~ 6,
    TRUE ~ NA_integer_
  ))


example <- first_look_maps[, c("vote24", "vote_biden","sex", "age_bracket", "races", "education_level", 
                                "urban")]

example_clean <- na.omit(example)



# Let's begin by calculating and saving correlation matrix
corr_matrix <- cor(example_clean)

# Melt correlation matrix to long format
melted_correlation <- reshape2::melt(corr_matrix)

# Next let's plot the correlation
ggplot(data = melted_correlation) + 
  geom_tile(aes(x = Var1, y = Var2, fill = value)) +
  scale_fill_gradient2(low = "blue", high = "red", midpoint = 0, name = "Correlation") +
  labs(title = "Correlation heatmap", subtitle = "Variables from 'survey_analysis_data' dataset") +
  xlab("Variable 1") + ylab("Variable 2") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1),
        axis.text.y = element_text(angle = 0, vjust = 0.5, hjust=1),
        panel.background = element_rect(fill = "white"),
        panel.grid.major = element_line(colour = "gray90"),
        panel.grid.minor = element_blank(),
        legend.title = element_blank(),
        legend.key.width = unit(1, "cm"),
        legend.key.height = unit(0.5, "cm"),
        legend.text = element_text(size = 10),
        plot.title = element_text(size = 18, face = "bold"))
