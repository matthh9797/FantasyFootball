## Fantasy Football Project

## 1. Downloading and reading the data into R
## New data download: (https://www.kaggle.com/irkaal/english-premier-league-results)

# # a. results is a dataframe containing all of the resuts from the 2005/2006 premier league season to 
# # the 2019/2020 season 
# results <- read.csv("data/results1993-2020/results.csv")
# # results 2005 - 2020 (15 seasons)
# results <- transform(results, Date = as.Date(Date))
# library(dplyr)
# results <- filter(results, Date > "2005-08-01")
# save(results, file = "data/results.R")
# 
# # b. goalSummary is a dataframe containing a summary of the overall goals scored and conceded by each team
# # in the Premier league by season
# source("code/summaryGoals.R")
# summaryGoals <- summaryGoals(results)
# save(summaryGoals, file = "data/summaryGoals.R")
#
# # c. team_list is a list object containing factor vectors which contain the teams for each Premier League
# # season
# team_list <- list(
#   "teams_0506" = droplevels(filter(summaryGoals, Season == "2005-06")$Team[1:20]),
#   "teams_0607" = droplevels(filter(summaryGoals, Season == "2006-07")$Team[1:20]),
#   "teams_0708" = droplevels(filter(summaryGoals, Season == "2007-08")$Team[1:20]),  
#   "teams_0809" = droplevels(filter(summaryGoals, Season == "2008-09")$Team[1:20]),
#   "teams_0910" = droplevels(filter(summaryGoals, Season == "2009-10")$Team[1:20]),
#   "teams_1011" = droplevels(filter(summaryGoals, Season == "2010-11")$Team[1:20]),
#   "teams_1112" = droplevels(filter(summaryGoals, Season == "2011-12")$Team[1:20]),
#   "teams_1213" = droplevels(filter(summaryGoals, Season == "2012-13")$Team[1:20]),  
#   "teams_1314" = droplevels(filter(summaryGoals, Season == "2013-14")$Team[1:20]),
#   "teams_1415" = droplevels(filter(summaryGoals, Season == "2014-15")$Team[1:20]),
#   "teams_1516" = droplevels(filter(summaryGoals, Season == "2015-16")$Team[1:20]),  
#   "teams_1617" = droplevels(filter(summaryGoals, Season == "2016-17")$Team[1:20]),
#   "teams_1718" = droplevels(filter(summaryGoals, Season == "2017-18")$Team[1:20]),
#   "teams_1819" = droplevels(filter(summaryGoals, Season == "2018-19")$Team[1:20]),
#   "teams_1920" = droplevels(filter(summaryGoals, Season == "2019-20")$Team[1:20])
# )
# save(team_list, file = "data/team_list.R")
# Source the data objects from memory
source("data/results.R")
source("data/summaryGoals.R")
source("data/team_list.R")

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
library(dplyr)
library(ggplot2)
g <- ggplot(data = filter(subset(result_tbl, HomeTeam == "Man City"), Season %in% c("1718", "1819")),
mapping = aes(FTHG))
g + geom_bar(fill = "skyblue3", col = "white") + 
  labs(x = "Goals Scored", title = "Man City Home Goal Distribution 2017 - 2019")

g <- ggplot(data = filter(subset(result_tbl, AwayTeam == "Man City"), Season %in% c("1718", "1819")),
            mapping = aes(FTAG))
g + geom_bar(fill = "skyblue3", col = "white") + 
  labs(x = "Goals Scored", title = "Man City Away Goal Distribution 2017 - 2019")
source("code/distTeam.R")

# Spliting the seasons by part (e.g start end middle)
v1 <- c(rep(1, 130), rep(2, 120), rep(3, 130))
v2 <- rep(v1, 10)
cut <- factor(v2, levels = c(1,2,3), labels = c("Start", "Middle", "End"))
result_tbl <- transform(result_tbl, SeasonCut = cut)
str
home <- group_by(result_tbl, HomeTeam, Season, SeasonCut) %>% summarise(GoalScored=sum(FTHG), GoalAgainst=sum(FTAG))

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
  geom_smooth(method = "lm", se = FALSE) + facet_grid(. ~ Team)
print(goalPlot_1319)

# 6. Fixture Data Model
fixtures <- read.csv("data/fixtures/epl-2020-GMTStandardTime.csv")
head(fixtures)
str(fixtures)

goalSummary1415 <- filter(goalSummary, Season == "1415")predictHome1415 <- t(sapply(teams1415, function(x) sapply(teams1415, function(y) predict(x, y, GoalMatrix1415)[[1]])))
predictAway1415 <- sapply(teams1415, function(x) sapply(teams1415, function(y) predict(x, y, GoalMatrix1415)[[2]]))

GoalMatrix1415 <- matrix(ncol = 4, nrow = 20)
rownames(GoalMatrix1415) <- goalSummary1415$Team
colnames(GoalMatrix1415) <- c("HomeGoals", "AwayGoals", "HomeConcede", "AwayConcede")
teams1415 <- rownames(GoalMatrix1415)
GoalMatrix1415[,1] <- goalSummary1415$GoalScored[1:20]
GoalMatrix1415[,2] <- goalSummary1415$GoalScored[21:40]
GoalMatrix1415[,3] <- goalSummary1415$GoalAgainst[1:20]
GoalMatrix1415[,4] <- goalSummary1415$GoalAgainst[21:40]
diag(predictHome1415) <- 0
diag(predictAway1415) <- 0
predict1415 <- cbind(predictHome1415, predictAway1415)
colNames <- c(sapply(teams1415, function(x) paste0(x, ".Home")), sapply(teams1415, function(x) paste0(x, ".Away")))
fixtures <- transform(fixtures, Predict.Home = NA, Predict.Away = NA)



