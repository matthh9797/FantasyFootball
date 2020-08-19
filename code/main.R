## Fantasy Football Project

## 1. Downloading and reading the data into R

# ## Script to read in data from datahub on English Premier League results
# library("jsonlite")
# json_file <- 'https://datahub.io/sports-data/english-premier-league/datapackage.json'
# json_data <- fromJSON(paste(readLines(json_file), collapse=""))
# # get list of all resources:
# print(json_data$resources$name)
# # use function extract season to extract the 10 seasons from the json_data
# source("code/extractSeason.R")
# ## LOOKING FOR MORE ELEGANT CODE TO DO THIS PART
# # extract seasons
# season_1819 <- extractSeason(23)
# season_1718 <- extractSeason(24)
# season_1617 <- extractSeason(25)
# season_1516 <- extractSeason(26)
# season_1415 <- extractSeason(27)
# season_1314 <- extractSeason(28)
# season_1213 <- extractSeason(29)
# season_1112 <- extractSeason(30)
# season_1011 <- extractSeason(31)
# season_0910 <- extractSeason(32)

# dump season data frames
# dump(list = list(season_1819, season_1718, season_1617, season_1516, season_1415, 
#      season_1314, season_1213, season_1112, season_1011, season_0910), 
#      "data/seasondata.R")
# Don't know why this doesn't work: dump(team_list, file = "data/teamdata.R")

# Source season data and create team vectors for each season
source("data/seasondata.R")
season_1415 <- season_1415[1:380,]
teams_1819 <- sort(unique(season_1819$HomeTeam))
teams_1718 <- sort(unique(season_1718$HomeTeam))
teams_1617 <- sort(unique(season_1617$HomeTeam))
teams_1516 <- sort(unique(season_1516$HomeTeam))
teams_1415 <- sort(unique(season_1415$HomeTeam))
teams_1314 <- sort(unique(season_1314$HomeTeam))
teams_1213 <- sort(unique(season_1213$HomeTeam))
teams_1112 <- sort(unique(season_1112$HomeTeam))
teams_1011 <- sort(unique(season_1011$HomeTeam))
teams_0910 <- sort(unique(season_0910$HomeTeam))

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

source("code/distTeam.R")

## 3. Creating summary dataframes detailing the number of goals scored and conceded home and away
## grouped by teams
source("code/summary_df.R")
## Note: this variation will much up the predict function which will need adapted to this new format
summary_data <- rbind(
  summary_df(season = season_1819, year = "1819"),
  summary_df(season = season_1718, year = "1718"),
  summary_df(season = season_1617, year = "1617"),
  summary_df(season = season_1516, year = "1516"),
  summary_df(season = season_1415, year = "1415"),
  summary_df(season = season_1314, year = "1314"),
  summary_df(season = season_1213, year = "1213"),
  summary_df(season = season_1112, year = "1112"),
  summary_df(season = season_1011, year = "1011"),
  summary_df(season = season_0910, year = "0910")
)

## 4. Applying model to the data frames

# use functions predict and actualResults to look at the effectiveness of the model
source("code/predict.R")
source("code/teamResult.R")
# inspect liverpool
predict("Liverpool")
teamResult("Liverpool")
# inspect Wolves
predict("Wolves")
# inspect crystal palace
teamResult("Wolves")
predict("Crystal Palace")
teamResult("Crystal Palace")
# by inspecting the model we can see it works well for more predictable teams like liverpool
# however, an element of randomness and distribution, as well as playing style analysis is
# needed for teams like wolves and crystal palace

## exploraty graphs
# What teams are common of the 2018/2019 / 2017/2018 / 2016/2017 seasons, hence weren't promoted or 
# relegated during these seasons
teams_1619 <- intersect(teams_1819, intersect(teams_1718, intersect(teams_1617, teams_1516)))
homedata_1619 <- rbind(homedata_1819, homedata_1718, homedata_1617)
homedata_1619 <- transform(homedata_1619, 
                           Season = as.factor(Season), HomeorAway = as.factor(HomeorAway))
homedata_1619 <- filter(homedata_1619, HomeTeam %in% teams_1619)

# plot a linear model using lattice
attach(homedata_1619)
goalPlot <- xyplot(GoalScored ~ Season | HomeTeam, layout = c(14,1), panel = function(x, y, ...) {
panel.xyplot(x, y, ...)
panel.lmline(x, y, col = 2)
})
detach(homedata_1619)
print(goalPlot)
# plot shows how a linear model over the past 3 seasons would lead to unaccurate 
# predictions 





