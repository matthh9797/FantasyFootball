## Study which teams are have similar goal scoring patterns against 
## other teams in the Premier League 

## The idea is going to be to create a matrix with the scaled
## goals scored by each team against each other team then understand
## which teams have similar goal scoring patterns using cluster analysis

results <- filter(results, Season %in% c("2016-17", "2017-18", "2019-20"))
# Number of goals scored by each home team against each other team by season
results %>% group_by(Season, HomeTeam, AwayTeam) %>% summarise(GoalScored = FTHG)
# Sum of goals scored by Season
HomeGoals <- results %>% group_by(Season, HomeTeam, AwayTeam) %>% summarise(GoalScored = sum(FTHG))
AwayGoals <- results %>% group_by(Season, AwayTeam, HomeTeam) %>% summarise(GoalScored = sum(FTAG))
# Disregard teams that have been relegated
Teams_1619 <- intersect(team_list$teams_1920, 
          intersect(team_list$teams_1819, team_list$teams_1718))
## Remove non-consistent teams from the data matrix 
HomeGoals <- HomeGoals %>% filter(HomeTeam %in% Teams_1619) %>% filter(AwayTeam %in% Teams_1619)
AwayGoals <- AwayGoals %>% filter(AwayTeam %in% Teams_1619) %>% filter(HomeTeam %in% Teams_1619)

# Create a matrix that sums the goals scored agaianst each team for the last 3 seasons
HomeGoals <- HomeGoals %>% group_by(HomeTeam, AwayTeam) %>% summarise(GoalScored = sum(GoalScored))
AwayGoals <- AwayGoals %>% group_by(HomeTeam, AwayTeam) %>% summarise(GoalScored = sum(GoalScored))
data = data.frame("HomeTeam", "AwayTeam", "GoalScored")
for (i in 1:16) {
  # Create row to add to data 
  data[i,] = c(Teams_1619[[i]], Teams_1619[[i]], meanGoals$mean[[i]])
} 










