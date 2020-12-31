# read in data of match results
result <- read.csv("data/results1993-2020.csv")
result <- result[, c(1,3,4,5,6)]
# filter for the 2009/10 seaon
result_1920 <- filter(result, Season == "2019-20")
# read in the absolute goals dataframe to observe the overall goals scored by each team 
source("code/dataframes/overall_goals.R")
abs_goal <- overall_goals(HomeTeam = result$HomeTeam, AwayTeam = result$AwayTeam, 
                          Season = result$Season, FTHG = result$FTHG, FTAG = result$FTAG)
# filter for the 2009/10 season
abs_goal_1920 <- filter(abs_goal, Season == "2019-20")

# create a matrix of FTHG of the home team against the opposition
home_arr <- arrange(result_1920, HomeTeam, AwayTeam)
home <- reshape(home_arr, idvar = "HomeTeam", v.names = "FTHG", timevar = "AwayTeam", direction = "wide")
nms <- as.character(sort(home$HomeTeam))
home <- home[,4:23]
home <- home[,c(20,1:19)]
rownames(home) <- nms
colnames(home) <- nms
home[is.na(home)] <- 0
home <- as.matrix(home)
# create a matrix of FTAG of Away team against the opposition
away_arr <- arrange(result_1920, AwayTeam, HomeTeam)
away <- reshape(away_arr, idvar = "AwayTeam", v.names = "FTAG", timevar = "HomeTeam", direction = "wide")
nms <- as.character(sort(away$AwayTeam))
away <- away[,4:23]
away <- away[,c(20,1:19)]
rownames(away) <- nms
colnames(away) <- nms
away[is.na(away)] <- 0
away <- as.matrix(away)
# create a diagonal matrix of the 1 / homegoalpermatch of each team
hg <- abs_goal_1920$home_goal
hg <- hg / 19
hg <- 1 / hg
hg <- diag(hg)
# create a distribution of home goals
distr_hg <- hg %*% home
rownames(distr_hg) <- nms
# create a diagonal matrix of the 1 / awaygoalpermatch of each team
ag <- abs_goal_1920$away_goal
ag <- ag / 19
ag <- 1 / ag
ag <- diag(ag)
# create a distribution of away goals
distr_ag <- ag %*% away
rownames(distr_ag) <- nms

# create a heatmpa of the goal distribution of home and away teams
library(pheatmap)
pheatmap(distr_hg, cutree_rows = 6, main = "Heatmap of the Goal Distribution of English Premier League Home Teams (2019/2020)")
pheatmap(distr_ag, cutree_rows = 6, main = "Heatmap of the Goal Distribution of English Premier League Away Teams (2019/2020)")




