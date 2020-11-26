## Fantasy Football Project

## The aim of this project is to create an accurate predictor of the expected goals scored by each team in the 
## Premier League for each fixture to create attack and defensive metrics for a range of games

# PART 1 - Predict the goals scored and conceded by each team in the Premier League (Model 1)
# PART 2 - Predict the expected goals in each match in the Premier League using Model 1 (Model 2)
# PART 3 - Create attacking and defending metrics for a team over a date range using Model 2

# PART 1 - PREDICT OVERALL GOALS SCORED & CONCEDED

## 1. Summary statistics 

## data source: (https://www.kaggle.com/irkaal/english-premier-league-results)
# a. results is a dataframe containing all of the resuts from the 2005/2006 premier league season to
# the 2019/2020 season
results <- read.csv("data/results1993-2020/results.csv")
# results 2005 - 2020 (15 seasons)
results <- transform(results, Date = as.Date(Date))
library(dplyr)
results <- filter(results, Date > "2005-08-01")
# save(results, file = "data/results.R")

# b. goalSummary is a dataframe containing a summary of the overall goals scored and conceded by each team
# in the Premier league by season
source("code/summaryGoals.R")
summaryGoals <- summaryGoals(results)
# save(summaryGoals, file = "data/summaryGoals.R")

# b. overall_goals is a function that inputs a results dataframe and returns a dataframe containing the 
# goals scored by each team in each season
source("code/dataframes/overall_goals.R")
overall_goals <- overall_goals(results)
# rearrange the columns of the dataframes
overall_goals <- overall_goals[ , c(1,2,7,3,5,8,4,6)]

# c. average_goals is a function that inputs the overall goals dataframe and returns a dataframe containing the 
# goals per game version of overall_goals with home:away ratios for goals scored and conceded
source("code/dataframes/average_goals.R")
average_goals <- average_goals(overall_goals)

# d. team_list is a list object containing factor vectors which contain the teams for each Premier League
# season
team_list <- list(
  "teams_0506" = droplevels(filter(overall_goals, Season == "2005-06")$Team[1:20]),
  "teams_0607" = droplevels(filter(overall_goals, Season == "2006-07")$Team[1:20]),
  "teams_0708" = droplevels(filter(overall_goals, Season == "2007-08")$Team[1:20]),
  "teams_0809" = droplevels(filter(overall_goals, Season == "2008-09")$Team[1:20]),
  "teams_0910" = droplevels(filter(overall_goals, Season == "2009-10")$Team[1:20]),
  "teams_1011" = droplevels(filter(overall_goals, Season == "2010-11")$Team[1:20]),
  "teams_1112" = droplevels(filter(overall_goals, Season == "2011-12")$Team[1:20]),
  "teams_1213" = droplevels(filter(overall_goals, Season == "2012-13")$Team[1:20]),
  "teams_1314" = droplevels(filter(overall_goals, Season == "2013-14")$Team[1:20]),
  "teams_1415" = droplevels(filter(overall_goals, Season == "2014-15")$Team[1:20]),
  "teams_1516" = droplevels(filter(overall_goals, Season == "2015-16")$Team[1:20]),
  "teams_1617" = droplevels(filter(overall_goals, Season == "2016-17")$Team[1:20]),
  "teams_1718" = droplevels(filter(overall_goals, Season == "2017-18")$Team[1:20]),
  "teams_1819" = droplevels(filter(overall_goals, Season == "2018-19")$Team[1:20]),
  "teams_1920" = droplevels(filter(overall_goals, Season == "2019-20")$Team[1:20])
)

# 2. Model - A model which predicts the overall_goals dataframe for the next season

## a. Fixture List 2020-21
fixtures <- read.csv("data/fixtures/epl-2020-GMTStandardTime.csv")
fixtures <- transform(fixtures, Date = as.Date(Date, format = "%d/%m/%Y"))
## pre-process teams from 2020/2021 to match the format of the results data source
fixtures <- transform(fixtures, Home.Team = as.character(Home.Team), Away.Team = as.character(Away.Team))
fixtures$Home.Team[fixtures$Home.Team == "Man Utd"] <- "Man United"
fixtures$Home.Team[fixtures$Home.Team == "Sheffield Utd"] <- "Sheffield United"
fixtures$Home.Team[fixtures$Home.Team == "Spurs"] <- "Tottenham"
fixtures$Away.Team[fixtures$Away.Team == "Man Utd"] <- "Man United"
fixtures$Away.Team[fixtures$Away.Team == "Sheffield Utd"] <- "Sheffield United"
fixtures$Away.Team[fixtures$Away.Team == "Spurs"] <- "Tottenham"
fixtures <- transform(fixtures, Home.Team = as.factor(Home.Team), Away.Team = as.factor(Away.Team))
# add 2020/2021 teams to the team_list
team_list$teams_2021 <- sort(unique(fixtures$Home.Team))

# c. overall_goals_predict_2021 - currently I have no model to predict this data frame and have used EDA
# to predict the dataframe 
source("code/models/model1_goals_predict.R")
overall_goals_predict_2021 <- model1_goals_predict(Teams = team_list$teams_2021)


## PART 2 - PREDICT EXPECTED GOALS IN EACH MATCH

# a. Create a matrix with the expected goals of each team against each other team home and away
# and a sclaed version which makes the results comparable
source("code/predict.R")
homeGoalMatrix <- sapply(team_list$teams_2021, function(HomeTeam) sapply(team_list$teams_2021, function(AwayTeam) predict(HomeTeam, AwayTeam, GoalMatrix)[[1]]))
awayGoalMatrix <- sapply(team_list$teams_2021, function(AwayTeam) sapply(team_list$teams_2021, function(HomeTeam) predict(HomeTeam, AwayTeam, GoalMatrix)[[2]]))
expectedGoalMatrix <- rbind(homeGoalMatrix, awayGoalMatrix)
colnames(expectedGoalMatrix) <- team_list$teams_2021
# use min_max method to normalise data
min_max_norm <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
scaledGoalMatrix <- apply(expectedGoalMatrix, 2, min_max_norm)
rownames(expectedGoalMatrix) <- c(sapply(team_list$teams_2021, function(x) paste0(x, "@Home")), sapply(team_list$teams_2021, function(x) paste0(x, "@Away")))
rownames(scaledGoalMatrix) <- c(sapply(team_list$teams_2021, function(x) paste0(x, "@Home")), sapply(team_list$teams_2021, function(x) paste0(x, "@Away")))
rm(homeGoalMatrix, awayGoalMatrix, predict)
expectedGoalMatrix <- t(expectedGoalMatrix)
scaledGoalMatrix <- t(scaledGoalMatrix)


## PART 3 - PREDICT ATTACK AND DEFENCE METRICS FOR A DATE RANGE

## The following code is messy however gives a working goalDF which contains the expected goals
## scored by each team against an opponent by date. 
## This data frame can then be subset to answer the question: between these dates which team
## has a good run of fixtures for scoring goals?

# add expected and scaled goals to the fixtures dataframe
fixtures <- transform(fixtures, Home.Team = as.character(Home.Team), Away.Team = as.character(Away.Team))
# df1 contains the set of home teams for the season and predicted goals
df1 <- data.frame(Date = fixtures$Date, Team = fixtures$Home.Team, Opponent = paste0(fixtures$Away.Team, "@Home"))
df1 <- transform(df1, Team = as.character(Team), Opponent = as.character(Opponent))
EGHome <- rep(0, 380)
SHome <- rep(0, 380)
for (i in 1:380) {
  EGHome[i] <- expectedGoalMatrix[[ df1[[i, 2]], df1[[i, 3]] ]]
  SHome[i] <- scaledGoalMatrix[[ df1[[i, 2]], df1[[i, 3]] ]]
}
df1 <- transform(df1, expectedGoal = EGHome, scaledGoal = SHome)
# df2 contains the set of away teams and the expected goals for the season
df2 <- data.frame(Date = fixtures$Date, Team = fixtures$Away.Team, Opponent = paste0(fixtures$Home.Team, "@Away"))
df2 <- transform(df2, Team = as.character(Team), Opponent = as.character(Opponent))
EGAway <- rep(0, 380)
SAway <- rep(0, 380)
for (i in 1:380) {
  EGAway[i] <- expectedGoalMatrix[[ df2[[i, 2]], df2[[i, 3]] ]]
  SAway[i] <- scaledGoalMatrix[[ df2[[i, 2]], df2[[i, 3]] ]]
}
df2 <- transform(df2, expectedGoal = EGAway, scaledGoal = SAway)
goalDF <- rbind(df1, df2)
rm(df1, EGHome, SHome, df2, EGAway, SAway, i)

# subsetting the data frame
# ! make generic functions for this part
goalDF %>% filter(Date < "2020-10-06") %>% group_by(Team) %>% summarise(Total = sum(expectedGoal))
goalDF %>% filter(Date < "2020-10-06") %>% group_by(Team) %>% summarise(Total = sum(scaledGoal))
filter(goalDF, Team == "Arsenal", Date < "2020-10-06")
filter(goalDF, Team == "Fulham", Date < "2020-10-06")
filter(goalDF, Team == "Tottenham", Date < "2020-10-06")






