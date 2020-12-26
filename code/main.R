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
results <- read.csv("data/results1993-2020.csv")
# results 2005 - 2020 (15 seasons)
results <- transform(results, Date = as.Date(Date))
library(dplyr)
results <- filter(results, Date > "2005-08-01")
results$HomeTeam <- droplevels(results$HomeTeam)
results$AwayTeam <- droplevels(results$AwayTeam)
# save(results, file = "data/results.R")

# b. goalSummary is a dataframe containing a summary of the overall goals scored and conceded by each team
# in the Premier league by season
source("code/summaryGoals.R")
summaryGoals <- summaryGoals(results)
# save(summaryGoals, file = "data/summaryGoals.R")

# b. overall_goals is a function that inputs a results dataframe and returns a dataframe containing the 
# goals scored by each team in each season
source("code/dataframes/overall_goals.R")
abs_goals <- overall_goals(HomeTeam = results$HomeTeam, AwayTeam = results$AwayTeam, 
                           Season = results$Season, FTHG = results$FTHG, FTAG = results$FTAG)

# c. average_goals is a function that inputs the overall goals dataframe and returns a dataframe containing the 
# goals per game version of overall_goals with home:away ratios for goals scored and conceded
source("code/dataframes/average_goals.R")
avg_goals <- average_goals(abs_goals)

# d. team_list is a list object containing factor vectors which contain the teams for each Premier League
# season
team_list <- list(
  "2005-06" = droplevels(filter(abs_goals, Season == "2005-06")$Team[1:20]),
  "2006-07" = droplevels(filter(abs_goals, Season == "2006-07")$Team[1:20]),
  "2007-08" = droplevels(filter(abs_goals, Season == "2007-08")$Team[1:20]),
  "2008-09" = droplevels(filter(abs_goals, Season == "2008-09")$Team[1:20]),
  "2009-10" = droplevels(filter(abs_goals, Season == "2009-10")$Team[1:20]),
  "2010-11" = droplevels(filter(abs_goals, Season == "2010-11")$Team[1:20]),
  "2011-12" = droplevels(filter(abs_goals, Season == "2011-12")$Team[1:20]),
  "2012-13" = droplevels(filter(abs_goals, Season == "2012-13")$Team[1:20]),
  "2013-14" = droplevels(filter(abs_goals, Season == "2013-14")$Team[1:20]),
  "2014-15" = droplevels(filter(abs_goals, Season == "2014-15")$Team[1:20]),
  "2015-16" = droplevels(filter(abs_goals, Season == "2015-16")$Team[1:20]),
  "2015-16" = droplevels(filter(abs_goals, Season == "2016-17")$Team[1:20]),
  "2017-18" = droplevels(filter(abs_goals, Season == "2017-18")$Team[1:20]),
  "2018-19" = droplevels(filter(abs_goals, Season == "2018-19")$Team[1:20]),
  "2019-20" = droplevels(filter(abs_goals, Season == "2019-20")$Team[1:20])
)

# 2. Model - A model which predicts the overall_goals dataframe for the next season

## a. Fixture List 2020-21 (data source: https://fixturedownload.com/results/epl-2020)
url <- "https://fixturedownload.com/download/epl-2020-GMTStandardTime.csv"
# update fixture list
if (file.exists("data/fixtures-2021.csv")) {
  file.remove("data/fixtures-2021.csv")
  download.file(url, destfile = "data/fixtures-2021.csv")
}
fixtures <- read.csv("data/fixtures-2021.csv")
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
team_list$"2020-21" <- sort(unique(fixtures$Home.Team))
# split the result string into a home and away goal section
score <- as.character(fixtures$Result)
splt <- strsplit(score, " - ")
hg <- sapply(splt, function(x) x[1])
ag <- sapply(splt, function(x) x[2])
hg <- as.numeric(hg)
ag <- as.numeric(ag)
fixtures <- transform(fixtures, FTHG = hg, FTAG = ag, Season = as.factor(rep("2020-21", 380)))
# remove extra objects
rm(ag,hg,score,splt)

# c. overall_goals_predict_2021 - currently I have no model to predict this data frame and have used EDA
# to predict the dataframe 
source("code/models/model1/goals_predict.R")
abs_goals_2021 <- model1_overallGoals_predict(Teams = team_list$teams_2021)

## PART 2 - PREDICT EXPECTED GOALS IN EACH MATCH

overall_goals_0506 <- filter(overall_goals, Season == "2005-06")
expected_goals_0506_home <- data.frame(Season = "2005-06", HomeTeam = rep(team_list$`2005-06`, each = 20), AwayTeam = rep(team_list$`2005-06`, 20), HomeGoal = 0, AwayGoal = 0)
# need a function that uses row 1 as arguement 1 and row 2 as argument 2

# a. Create a matrix with the expected goals of each team against each other team home and away
# and a sclaed version which makes the results comparable
source("code/models/model2/model2_score_predict.R")
homeGoalMatrix <- sapply(team_list$teams_2021, 
                         function(HomeTeam) sapply(team_list$teams_2021, 
                                                   function(AwayTeam) model2_score_predict(HomeTeam, AwayTeam, overall_goals_predict_2021)[[1]]))
awayGoalMatrix <- sapply(team_list$teams_2021, 
                         function(AwayTeam) sapply(team_list$teams_2021, 
                                                   function(HomeTeam) model2_score_predict(HomeTeam, AwayTeam, overall_goals_predict_2021)[[2]]))
expectedGoalMatrix <- rbind(homeGoalMatrix, awayGoalMatrix)
colnames(expectedGoalMatrix) <- team_list$teams_2021
# use min_max method to normalise data
# min_max_norm <- function(x) {
#   (x - min(x)) / (max(x) - min(x))
# }
# scaledGoalMatrix <- apply(expectedGoalMatrix, 2, min_max_norm)
scaledGoalMatrix <- scale(expectedGoalMatrix)
rownames(expectedGoalMatrix) <- c(sapply(team_list$teams_2021, function(x) paste0(x, "@Home")), sapply(team_list$teams_2021, function(x) paste0(x, "@Away")))
rownames(scaledGoalMatrix) <- c(sapply(team_list$teams_2021, function(x) paste0(x, "@Home")), sapply(team_list$teams_2021, function(x) paste0(x, "@Away")))
rm(homeGoalMatrix, awayGoalMatrix)
expectedGoalMatrix <- t(expectedGoalMatrix)
scaledGoalMatrix <- t(scaledGoalMatrix)

## Will add analysis about the distribution of goals scored by premier league teams to this model to make a more accurate 
## prediction


## PART 3 - PREDICT ATTACK AND DEFENCE METRICS FOR A DATE RANGE

## The following code is messy however gives a working goalDF which contains the expected goals
## scored by each team against an opponent by date. 
## This data frame can then be subset to answer the question: between these dates which team
## has a good run of fixtures for scoring goals?

# add expected and scaled goals to the fixtures dataframe
fixtures <- transform(fixtures, Home.Team = as.character(Home.Team), Away.Team = as.character(Away.Team))
# df1 contains the set of home teams for the season and predicted goals
df1 <- data.frame(Date = fixtures$Date, Week = fixtures$Round.Number, Team = fixtures$Home.Team, Opponent = paste0(fixtures$Away.Team, "@Home"))
df1 <- transform(df1, Team = as.character(Team), Opponent = as.character(Opponent))
EGHome <- rep(0, 380)
SHome <- rep(0, 380)
for (i in 1:380) {
  EGHome[i] <- expectedGoalMatrix[[ df1[[i, 3]], df1[[i, 4]] ]]
  SHome[i] <- scaledGoalMatrix[[ df1[[i, 3]], df1[[i, 4]] ]]
}
df1 <- transform(df1, expectedGoal = EGHome, scaledGoal = SHome)
# df2 contains the set of away teams and the expected goals for the season
df2 <- data.frame(Date = fixtures$Date, Week = fixtures$Round.Number, Team = fixtures$Away.Team, Opponent = paste0(fixtures$Home.Team, "@Away"))
df2 <- transform(df2, Team = as.character(Team), Opponent = as.character(Opponent))
EGAway <- rep(0, 380)
SAway <- rep(0, 380)
for (i in 1:380) {
  EGAway[i] <- expectedGoalMatrix[[ df2[[i, 3]], df2[[i, 4]] ]]
  SAway[i] <- scaledGoalMatrix[[ df2[[i, 3]], df2[[i, 4]] ]]
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



