## 2. EDA

## Insight into the distribution of goals scored in the Premier League

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

# What teams are common of the 2018/2019 / 2017/2018 / 2016/2017 seasons, hence weren't promoted or 
# relegated during these seasons
library(dplyr)
summaryGoals_1520 <- filter(summaryGoals, Season %in% c("2015-16", "2016-17", "2017-18", "2018-19", "2019-20"))
teams_1520 <- intersect(team_list$teams_1920,
                        intersect(team_list$teams_1819,
                                  intersect(team_list$teams_1718,
                                            intersect(team_list$teams_1617, team_list$teams_1516))))
summaryGoals_1520 <- filter(summaryGoals_1520, Team %in% teams_1520)

summaryGoals_1720 <- filter(summaryGoals, Season %in% c("2017-18", "2018-19", "2019-20"))
teams_1720 <- intersect(team_list$teams_1920,
                        intersect(team_list$teams_1819, team_list$teams_1718))
summaryGoals_1720 <- filter(summaryGoals_1720, Team %in% teams_1720)
filter_teams <- filter(summaryGoals_1720, Team %in% setdiff(teams_1720, teams_1520))

# plot a linear model using lattice
library(lattice)
# look at a linear model of the goals scored home and away by each of the 14 teams that have stayed in the Premier League 
# the last 3 seasons
attach(filter_teams)
goalPlot <- xyplot(GoalScored ~ Season | Team * HomeorAway, pch = 19, layout = c(3,2), panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)
  panel.lmline(x, y, col = 2)
})
detach(filter_teams)
print(goalPlot)
# Goal conceded
attach(filter_teams)
goalPlot <- xyplot(GoalAgainst ~ Season | Team * HomeorAway, pch = 19, layout = c(3,2), panel = function(x, y, ...) {
  panel.xyplot(x, y, ...)
  panel.lmline(x, y, col = 2)
})
detach(filter_teams)
print(goalPlot)
# plot shows how a linear model over the past 3 seasons would lead to unaccurate 
# predictions 

library(ggplot2)
g <- ggplot(data = summaryGoals_1520, aes(as.numeric(Season), GoalScored, color = HomeorAway))
goalPlot_1520 <- g + geom_point() + 
  geom_smooth(method = "lm", se = FALSE) + facet_grid(. ~ Team)
print(goalPlot_1520)
