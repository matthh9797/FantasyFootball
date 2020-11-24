# Fantasy Football

## Aim 

1. Create a score predictor for teams in the Premier League
2. Use model to create a web app that displays the team with the best fixtures between a date range 

# Part 1 - Score Predictor 

## Data Objects

 - overall_goals (*data.frame*) - The overall goals scored by each team Home, Away and Overall for each season from 2005-06 - 2019-20
 - average_goals (*data.frame*) - The average goals scored and conceded by each team Home and Away each season from 2005-06 - 2019-20
 - overall_goals_predict_2020-21 (*matrix*) - A model that predicts the overall goals scored and conceded by each team in the 2020-21 season
 - expected_goals_2020-21 (*matrix*) - A matrix that uses the overall_goals_predict_2020-21 model to predict the expected goals for each team against each other team home and away
 - scaled_goals_2020-21 (*matrix*) - A matrix containing a the results of the overall_goals_predict_2020-21 model scaled for each team

## Problems

1. How to calculate the prediction model for goals in 2020-21
2. How to deal with newly promoted teams
3. How to use the overall goal prediction model to predict the expected goals for each team against the other 

# Part 2 - Web App

## Data Objects

 - fixture_predict_2020-21 (*data.frame*) - A dataframe that contains the expected and scaled goal for each team against an opponent on the date of the fixture
 - attack_metric_2020-21 (*data.tbl*) - A data tibble containing the average expected and scaled goals for a team between a given date
 - defence_metric_2020-21 (*data.tbl*) - A data tibble containing the average expected and scaled goals to concede for a team between a given date

## Problems

1. How to scale the sum of the expected goals
2. How to scale the sum of probabilities of clean sheets