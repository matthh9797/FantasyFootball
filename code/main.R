## Fantasy Football Project

## 1. Downloading and reading the data into R
## New data download: (https://www.kaggle.com/irkaal/english-premier-league-results)

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

# c. team_list is a list object containing factor vectors which contain the teams for each Premier League
# season
team_list <- list(
  "teams_0506" = droplevels(filter(summaryGoals, Season == "2005-06")$Team[1:20]),
  "teams_0607" = droplevels(filter(summaryGoals, Season == "2006-07")$Team[1:20]),
  "teams_0708" = droplevels(filter(summaryGoals, Season == "2007-08")$Team[1:20]),
  "teams_0809" = droplevels(filter(summaryGoals, Season == "2008-09")$Team[1:20]),
  "teams_0910" = droplevels(filter(summaryGoals, Season == "2009-10")$Team[1:20]),
  "teams_1011" = droplevels(filter(summaryGoals, Season == "2010-11")$Team[1:20]),
  "teams_1112" = droplevels(filter(summaryGoals, Season == "2011-12")$Team[1:20]),
  "teams_1213" = droplevels(filter(summaryGoals, Season == "2012-13")$Team[1:20]),
  "teams_1314" = droplevels(filter(summaryGoals, Season == "2013-14")$Team[1:20]),
  "teams_1415" = droplevels(filter(summaryGoals, Season == "2014-15")$Team[1:20]),
  "teams_1516" = droplevels(filter(summaryGoals, Season == "2015-16")$Team[1:20]),
  "teams_1617" = droplevels(filter(summaryGoals, Season == "2016-17")$Team[1:20]),
  "teams_1718" = droplevels(filter(summaryGoals, Season == "2017-18")$Team[1:20]),
  "teams_1819" = droplevels(filter(summaryGoals, Season == "2018-19")$Team[1:20]),
  "teams_1920" = droplevels(filter(summaryGoals, Season == "2019-20")$Team[1:20])
)
# save(team_list, file = "data/team_list.R")
# Source the data objects from memory
source("data/results.R")
source("data/summaryGoals.R")
source("data/team_list.R")

# 2. Use EDA to create a prediction of how many goals each team will concede and score home and away in the 2020/2021
# season

## a. Add the list of fixtures 
fixtures <- read.csv("data/fixtures/epl-2020-GMTStandardTime.csv")
fixtures <- transform(fixtures, Date = as.Date(Date, format = "%d/%m/%Y"))
## b. pre-process teams from 2020/2021 to match the format of the results data source
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
# c. Create goal matrix which is a matrix that predicts the number of home and away goals 
# scored and conceded by each team
GoalMatrix <- matrix(ncol = 4, nrow = 20)
colnames(GoalMatrix) <- c("HomeGoals", "AwayGoals", "HomeConcede", "AwayConcede")
rownames(GoalMatrix) <- team_list$teams_2021
# based on eda of 5 seasons graphs found in eda section ...
GoalMatrix["Arsenal",] <- c(40, 22, 24, 26)
GoalMatrix["Chelsea",] <- c(35, 40, 16, 40)
GoalMatrix["Crystal Palace",] <- c(15, 20, 20, 30)
GoalMatrix["Everton",] <- c(30, 25, 21, 35)
GoalMatrix["Leicester",] <- c(37, 35, 16, 22)
GoalMatrix["Liverpool",] <- c(54, 34, 16,18)
GoalMatrix["Man City",] <- c(57, 45, 13, 20)
GoalMatrix["Man United",] <- c(44, 25, 15, 18)
GoalMatrix["Southampton",] <- c(22, 30, 36, 25)
GoalMatrix["Tottenham",] <- c(38, 16, 26, 26)
GoalMatrix["West Ham",] <- c(30, 22, 33, 30)
# based on eda of 2 seasons, graphs found in eda section ...
GoalMatrix["Brighton",] <- c(20, 30, 19, 28)
GoalMatrix["Burnley",] <- c(24,20, 25, 30)
GoalMatrix["Newcastle",] <- c(25, 20, 22, 35)
# based on last season
GoalMatrix["Wolves", ] <- c(28,25,20,22)
GoalMatrix["Aston Villa", ] <- c(22, 20, 30, 35)
GoalMatrix["Sheffield United", ] <- c(22, 20, 30, 35)
# guess
GoalMatrix["Fulham",] <- c(22, 18, 30, 35)
GoalMatrix["Leeds",] <- c(25, 22, 30, 35)
GoalMatrix["West Brom",] <- c(22, 18, 30, 35)


## 3. Prediction Model, how many goals will each team score home and away against every other time?

# a. Create a matrix with the expected goals of each team against each other team home and away
# and a sclaed version which makes the results comparable
source("code/predict.R")
homeGoalMatrix <- sapply(team_list$teams_2021, function(HomeTeam) sapply(team_list$teams_2021, function(AwayTeam) predict(HomeTeam, AwayTeam, GoalMatrix)[[1]]))
awayGoalMatrix <- sapply(team_list$teams_2021, function(AwayTeam) sapply(team_list$teams_2021, function(HomeTeam) predict(HomeTeam, AwayTeam, GoalMatrix)[[2]]))
expectedGoalMatrix <- rbind(homeGoalMatrix, awayGoalMatrix)
colnames(expectedGoalMatrix) <- team_list$teams_2021
scaledGoalMatrix <- scale(expectedGoalMatrix)
rownames(expectedGoalMatrix) <- c(sapply(team_list$teams_2021, function(x) paste0(x, "@Home")), sapply(team_list$teams_2021, function(x) paste0(x, "@Away")))
rownames(scaledGoalMatrix) <- c(sapply(team_list$teams_2021, function(x) paste0(x, "@Home")), sapply(team_list$teams_2021, function(x) paste0(x, "@Away")))
rm(homeGoalMatrix, awayGoalMatrix, predict)
expectedGoalMatrix <- t(expectedGoalMatrix)
scaledGoalMatrix <- t(scaledGoalMatrix)

## 4. Permute the rows and columns of the expected goals to be in the same order as the fixtures

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






