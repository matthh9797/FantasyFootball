## Fantasy Football Project

## 1. Downloading and reading the data into R
# The heavy work has been done in intialDataDownload.R to download and create the 3 main data objects,
# these have been saved as R objects in the data folder and can now be loaded into the global environment

# a. result_tbl is a dataframe containing all of the resuts from the 2009/2010 premier league season to 
# the 2018/2019 season 
load("data/result_tbl.R")
# b. team_list is a list object containing factor vectors which contain the teams for each Premier League
# season
load("data/team_list.R")
# c. goalSummary is a dataframe containing a summary of the overall goals scored and conceded by each team
# in the Premier league by season
load("data/goalSummary.R")

## vector of all season and team data frame names
years <- c("0910", "1011", "1112", "1213", "1314", "1415", "1516", "1617", "1718", "1819")
season_vector <- sapply(years, function(x) {paste0("season_", x)})
team_vector <- sapply(years, function(x) {paste0("team_", x)})

## 2. Insight into the distribution of goals scored in the Premier League

## Distribution of goals scored in the Premier League between 2009 to 2020
table(result_tbl$FTHG)
table(result_tbl$FTAG)
table(rbind(result_tbl$FTHG, result_tbl$FTAG))
# Plot histograms
par(mfrow = c(1, 3), mar = c(4, 4, 2, 1), oma = c(0,0,2,0))
hist(result_tbl$FTHG, col = "blue", xlab = "Home Goals", main = "Home Goals from 2009 to 2020")
hist(result_tbl$FTAG, col = "blue", xlab = "Away Goals", main = "Away Goals from 2009 to 2020")
hist(rbind(result_tbl$FTHG, result_tbl$FTAG), col = "green", xlab = "Total Goals", main = "Total Goals from 2009 to 2020")
mtext("Distribution of Goals Scored in the Premier League", outer = TRUE)
# ggplot implementation for individual teams
g <- ggplot(data = filter(subset(result_tbl, HomeTeam == "Man City"), Season %in% c("1617", "1718", "1819")),
mapping = aes(FTHG))
g + geom_bar(fill = "blue", alpha = .4, col = "red") + labs(title = "Man City Home Goal Distribution 2016 - 2019")

g <- ggplot(data = filter(subset(result_tbl, AwayTeam == "Man City"), Season %in% c("1617", "1718", "1819")),
            mapping = aes(FTAG))
g + geom_bar(fill = "blue", alpha = .4, col = "red") + labs(title = "Man City Away Goal Distribution 2016 - 2019")
source("code/distTeam.R")

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

## 5. EDA                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
# What teams are common of the 2018/2019 / 2017/2018 / 2016/2017 seasons, hence weren't promoted or 
# relegated during these seasons
library(dplyr)
goalSummary_1319 <- filter(goalSummary, Season %in% c("1314", "1415", "1516", "1617", "1718", "1819"))
teams_1319 <- intersect(team_list$teams_1819, 
                        intersect(team_list$teams_1718, 
                                  intersect(team_list$teams_1617, 
                                            intersect(team_list$teams_1516, 
                                                      intersect(team_list$teams_1415, team_list$teams_1314)))))

goalSummary_1319 <- filter(goalSummary_1319, Team %in% teams_1319)

# plot a linear model using lattice
library(lattice)
# look at a linear model of the goals scored home and away by each of the 14 teams that have stayed in the Premier League 
# the last 3 seasons
attach(goalSummary_1319)
goalPlot_1319 <- xyplot(GoalScored ~ Season | Team * HomeorAway, pch = 19, layout = c(10,2), panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)
  panel.lmline(x, y, col = 2)
})
detach(goalSummary_1319)
print(goalPlot_1319)
# Goal conceded
attach(goalSummary_1319)
goalPlot_1319 <- xyplot(GoalAgainst ~ Season | Team * HomeorAway, pch = 19, layout = c(10,2), panel = function(x, y, ...) {
panel.xyplot(x, y, ...)
panel.lmline(x, y, col = 2)
})
detach(goalSummary_1319)
print(goalPlot_1319)
# plot shows how a linear model over the past 3 seasons would lead to unaccurate 
# predictions 

library(ggplot2)
g <- ggplot(data = goalSummary_1319, aes(as.numeric(Season), GoalScored, color = HomeorAway))
goalPlot_1319 <- g + geom_point() + 
  geom_smooth(method = "lm", se = FALSE) + facet_grid(. ~ Team) +
print(goalPlot_1319)




