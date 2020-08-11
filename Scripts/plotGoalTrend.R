plotGoalTrend <- function(TEAM) {
  # Plot home goals
  plot(c(2017, 2018, 2019),
       c(subset(homedata1617, HomeTeam == TEAM)$GoalScored, 
         subset(homedata1718, HomeTeam == TEAM)$GoalScored, 
         subset(homedata1819, HomeTeam == TEAM)$GoalScored), 
         col = "red",
       xlab = "Goals Scored",
       ylab = "Season")
  par(new = TRUE)
  # Plot Away Goals
  plot(c(2017, 2018, 2019),
       c(subset(awaydata1617, AwayTeam == TEAM)$GoalScored, 
         subset(awaydata1718, AwayTeam == TEAM)$GoalScored, 
         subset(awaydata1819, AwayTeam == TEAM)$GoalScored), 
       col = "green",
       xlab = "Goals Scored",
       ylab = "Season")
  
}