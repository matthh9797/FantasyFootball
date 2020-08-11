## Fantasy Football Project

## 1. Downloading and reading the data into R

## Script to read in data from datahub on English Premier League results
library("jsonlite")
json_file <- 'https://datahub.io/sports-data/english-premier-league/datapackage.json'
json_data <- fromJSON(paste(readLines(json_file), collapse=""))
# get list of all resources:
print(json_data$resources$name)
# use function extract season to extract the 10 seasons from the json_data
source("Scripts/extractSeason.R")
## LOOKING FOR MORE ELEGANT CODE TO DO THIS PART
# season 2018/2019
season_1819 <- extractSeason(23)
teams_1819 <- sort(unique(season_1819$HomeTeam))
# season 2017/2018
season_1718 <- extractSeason(24)
teams_1718 <- sort(unique(season_1718$HomeTeam))
# season 2016/2017
season_1617 <- extractSeason(25)
teams_1617 <- sort(unique(season_1617$HomeTeam))
# season 2015/2016
season_1516 <- extractSeason(26)
teams_1516 <- sort(unique(season_1516$HomeTeam))
# season 2014/2015
season_1415 <- extractSeason(27)
teams_1415 <- sort(unique(season_1415$HomeTeam))
# season 2013/2014
season_1314 <- extractSeason(28)
teams_1314 <- sort(unique(season_1314$HomeTeam))
# season 2012/2013
season_1213 <- extractSeason(29)
teams_1213 <- sort(unique(season_1213$HomeTeam))
# season 2011/2012
season_1112 <- extractSeason(30)
teams_1112 <- sort(unique(season_1112$HomeTeam))
# season 2010/2011
season_1011 <- extractSeason(31)
teams_1011 <- sort(unique(season_1011$HomeTeam))
# season 2009/2010
season_0910 <- extractSeason(32)
teams_0910 <- sort(unique(season_0910$HomeTeam))

# dump season data frames
dump(list = list(season_1819, season_1718, season_1617, season_1516, season_1415, 
     season_1314, season_1213, season_1112, season_1011, season_0910), 
     "seasondata.R")
source("seasondata.R")
## vector of all season and team data frame names
years <- c("0910", "1011", "1112", "1213", "1314", "1415", "1516", "1617", "1718", "1819")
season_vector <- sapply(years, function(x) {paste0("season_", x)})
team_vector <- sapply(years, function(x) {paste0("team_", x)})

## 2. Insight into the distribution of goals scored in the Premier League

## Distribution of goals scored in the Premier League between 2009 to 2020
allSeason <- rbind(season_1819, season_1718, season_1617, season_1516, season_1415, 
                   season_1314, season_1213, season_1112, season_1011, season_0910)
table(allSeason$FTHG)
table(allSeason$FTAG)
allGoal <- rbind(allSeason$FTHG, allSeason$FTAG)
table(allGoal)
# Plot histograms
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0,0,2,0))
hist(allSeason$FTHG, col = "blue", xlab = "Home Goals", main = "Home Goals from 2009 to 2020")
hist(allSeason$FTAG, col = "blue", xlab = "Away Goals", main = "Away Goals from 2009 to 2020")
hist(allGoal, col = "green", xlab = "Total Goals", main = "Total Goals from 2009 to 2020")
mtext("Distribution of Goals Scored in the Premier League", outer = TRUE)

## 3. Home and Away data frames grouped by team

# home and away dataframes 2018/2019
homedata1819 <- group_by(season201819, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
awaydata1819 <- group_by(season201819, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
homedata1819 <- mutate(homedata1819, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
awaydata1819 <- mutate(awaydata1819, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
totalGoal1819 <- c(HomeGoals = sum(homedata1819$GoalScored), AwayGoals = sum(homedata1819$GoalAgainst))

# home and away dataframes 2017/2018
homedata1718 <- group_by(season1718, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
awaydata1718 <- group_by(season1718, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
homedata1718 <- mutate(homedata1718, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
awaydata1718 <- mutate(awaydata1718, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
totalGoal1718 <- c(HomeGoals = sum(homedata1718$GoalScored), AwayGoals = sum(homedata1718$GoalAgainst))

# home and away dataframes 2016/2017
homedata1617 <- group_by(season1617, HomeTeam) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))
awaydata1617 <- group_by(season1617, AwayTeam) %>% summarise(GoalScored=sum(FTAG), GoalAgainst=sum(FTHG))
homedata1617 <- mutate(homedata1617, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
awaydata1617 <- mutate(awaydata1617, GoalperGame = GoalScored / 19, ConcedeperGame = GoalAgainst / 19)
totalGoal1617 <- c(HomeGoals = sum(homedata1617$GoalScored), AwayGoals = sum(homedata1617$GoalAgainst))

## 4. Applying model to the data frames

# use functions predict and actualResults to look at the effectiveness of the model
source("Scripts/predict.R")
source("Scripts/actualResults.R")
# inspect liverpool
predict("Liverpool")
actualResults("Liverpool")
# inspect Wolves
predict("Wolves")
# inspect crystal palace
actualResults("Wolves")
predict("Crystal Palace")
actualResults("Crystal Palace")
# by inspecting the model we can see it works well for more predictable teams like liverpool
# however, an element of randomness and distribution, as well as playing style analysis is
# needed for teams like wolves and crystal palace

# exploraty graphs










