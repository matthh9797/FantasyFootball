## Reshaping the results table to analyse a count of goals scored
## by each team each season

## 1. Read results table
## data source: (https://www.kaggle.com/irkaal/english-premier-league-results)
# a. results is a dataframe containing all of the resuts from the 2005/2006 premier league season to
# the 2019/2020 season
results <- read.csv("data/results1993-2020/results.csv")
# results 2005 - 2020 (15 seasons)
results <- transform(results, Date = as.Date(Date))
library(dplyr)
results <- filter(results, Date > "2005-08-01")
results$HomeTeam <- droplevels(results$HomeTeam)
results$AwayTeam <- droplevels(results$AwayTeam)

## 2. HomeGoal Table
HomeGoalTable <- results[c(1,3,5)]
# create a table of the count of FTHG grouped by Season and HomeTeam
HomeGoalTable <- HomeGoalTable %>% group_by(Season, HomeTeam, FTHG) %>% count(FTHG)
HomeGoalTable <- as.data.frame(HomeGoalTable)
# Reshape the results to have number of goals as columns
HomeGoalTable <- reshape(HomeGoalTable, idvar = c("Season", "HomeTeam"), 
                         timevar = "FTHG", v.names = "n", direction = "wide")
# re-arrange columns in order
HomeGoalTable <- HomeGoalTable[,c(1,2,3,4,5,6,7,8,10,9,11, 12)]
# chnage NA values to 0
HomeGoalTable[is.na(HomeGoalTable)] <- 0
# rename columns
HomeGoalTable <- transform(HomeGoalTable, HoA = "Home")
names(HomeGoalTable) <- c("Season", "Team", as.character(0:9), "HoA")

# 3. AwayGoal Table
AwayGoalTable <- results[c(1,4,6)]
# create a table of the count of FTAG grouped by Season and AwayTeam
AwayGoalTable <- AwayGoalTable %>% group_by(Season, AwayTeam, FTAG) %>% count(FTAG)
AwayGoalTable <- as.data.frame(AwayGoalTable)
# Reshape the results to have number of goals as columns
AwayGoalTable <- reshape(AwayGoalTable, idvar = c("Season", "AwayTeam"), 
                         timevar = "FTAG", v.names = "n", direction = "wide")
# Add in an 8 goal columns
AwayGoalTable <- transform(AwayGoalTable, n.8 = NA)
# re-arrange columns in order
AwayGoalTable <- AwayGoalTable[,c(1,2,3,4,5,6,7,8,10,9,12,11)]
# chnage NA values to 0
AwayGoalTable[is.na(AwayGoalTable)] <- 0
# rename columns
AwayGoalTable <- transform(AwayGoalTable, HoA = "Away")
names(AwayGoalTable) <- c("Season", "Team", as.character(0:9), "HoA")

# 4. Goals table
GoalTable <- rbind(HomeGoalTable, AwayGoalTable)










