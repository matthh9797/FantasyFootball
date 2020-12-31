model1_overallGoals_predict <- function(Teams = team_list$teams_2021, Season = "2020-21") {
  ## currently I have no model for this stage and have simply guessed the results using eda
  overall_goals_predict <- data.frame(Season = rep(Season, 20), Team = Teams, 
                                      overall_goal = 0, home_goal = 0, away_goal = 0,
                                      overall_concede = 0, home_concede = 0, away_concede = 0)
  
  # based on eda of 5 seasons graphs found in eda section ...
  overall_goals_predict[which(overall_goals_predict$Team == "Arsenal"), 3:8] <- c(62, 40, 22, 50, 24, 26)
  overall_goals_predict[which(overall_goals_predict$Team == "Chelsea"), 3:8] <- c(75, 35, 40, 56, 16, 40)
  overall_goals_predict[which(overall_goals_predict$Team == "Crystal Palace"), 3:8] <- c(35, 15, 20, 50, 20, 30)
  overall_goals_predict[which(overall_goals_predict$Team == "Everton"), 3:8] <- c(55, 30, 25, 66, 21, 35)
  overall_goals_predict[which(overall_goals_predict$Team == "Leicester"), 3:8] <- c(72, 37, 35, 38, 16, 22)
  overall_goals_predict[which(overall_goals_predict$Team == "Liverpool"), 3:8] <- c(88, 54, 34, 34, 16,18)
  overall_goals_predict[which(overall_goals_predict$Team == "Man City"), 3:8] <- c(102, 57, 45, 33, 13, 20)
  overall_goals_predict[which(overall_goals_predict$Team == "Man United"), 3:8] <- c(69, 44, 25, 33, 15, 18)
  overall_goals_predict[which(overall_goals_predict$Team == "Southampton"), 3:8] <- c(52, 22, 30, 61, 36, 25)
  overall_goals_predict[which(overall_goals_predict$Team == "Tottenham"), 3:8] <- c(54, 38, 16, 52, 26, 26)
  overall_goals_predict[which(overall_goals_predict$Team == "West Ham"), 3:8] <- c(52, 30, 22, 63, 33, 30)
  # based on eda of 2 seasons, graphs found in eda section ...
  overall_goals_predict[which(overall_goals_predict$Team == "Brighton"), 3:8] <- c(50, 20, 30, 47, 19, 28)
  overall_goals_predict[which(overall_goals_predict$Team == "Burnley"), 3:8] <- c(44, 24,20, 55, 25, 30)
  overall_goals_predict[which(overall_goals_predict$Team == "Newcastle"), 3:8] <- c(45, 25, 20, 57, 22, 35)
  # based on last season
  overall_goals_predict[which(overall_goals_predict$Team == "Wolves"), 3:8] <- c(53, 28, 25, 42, 20, 22)
  overall_goals_predict[which(overall_goals_predict$Team == "Aston Villa"), 3:8] <- c(42, 22, 20, 65, 30, 35)
  overall_goals_predict[which(overall_goals_predict$Team == "Sheffield United"), 3:8] <- c(42, 22, 20, 65, 30, 35)
  # guess
  overall_goals_predict[which(overall_goals_predict$Team == "Fulham"), 3:8] <- c(40, 22, 18, 65, 30, 35)
  overall_goals_predict[which(overall_goals_predict$Team == "Leeds"), 3:8] <- c(47, 25, 22, 65, 30, 35)
  overall_goals_predict[which(overall_goals_predict$Team == "West Brom"), 3:8] <- c(40, 22, 18, 65, 30, 35)
  return(overall_goals_predict)
}