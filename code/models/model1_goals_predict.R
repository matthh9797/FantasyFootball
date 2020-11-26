model1_goals_predict <- function(Teams = team_list$teams_2021) {
  ## currently I have no model for this stage and have simply guessed the results using eda
  overall_goals_predict <- matrix(ncol = 6, nrow = 20)
  colnames(overall_goals_predict) <- c("overall_goal", "home_goal", "away_goal", 
                                       "overall_concede", "home_concede", "away_concede")
  rownames(overall_goals_predict) <- Teams
  # based on eda of 5 seasons graphs found in eda section ...
  overall_goals_predict["Arsenal",] <- c(62, 40, 22, 50, 24, 26)
  overall_goals_predict["Chelsea",] <- c(75, 35, 40, 56, 16, 40)
  overall_goals_predict["Crystal Palace",] <- c(35, 15, 20, 50, 20, 30)
  overall_goals_predict["Everton",] <- c(55, 30, 25, 66, 21, 35)
  overall_goals_predict["Leicester",] <- c(72, 37, 35, 38, 16, 22)
  overall_goals_predict["Liverpool",] <- c(88, 54, 34, 34, 16,18)
  overall_goals_predict["Man City",] <- c(102, 57, 45, 33, 13, 20)
  overall_goals_predict["Man United",] <- c(69, 44, 25, 33, 15, 18)
  overall_goals_predict["Southampton",] <- c(52, 22, 30, 61, 36, 25)
  overall_goals_predict["Tottenham",] <- c(54, 38, 16, 52, 26, 26)
  overall_goals_predict["West Ham",] <- c(52, 30, 22, 63, 33, 30)
  # based on eda of 2 seasons, graphs found in eda section ...
  overall_goals_predict["Brighton",] <- c(50, 20, 30, 47, 19, 28)
  overall_goals_predict["Burnley",] <- c(44, 24,20, 55, 25, 30)
  overall_goals_predict["Newcastle",] <- c(45, 25, 20, 57, 22, 35)
  # based on last season
  overall_goals_predict["Wolves", ] <- c(53, 28, 25, 42, 20, 22)
  overall_goals_predict["Aston Villa", ] <- c(42, 22, 20, 65, 30, 35)
  overall_goals_predict["Sheffield United", ] <- c(42, 22, 20, 65, 30, 35)
  # guess
  overall_goals_predict["Fulham",] <- c(40, 22, 18, 65, 30, 35)
  overall_goals_predict["Leeds",] <- c(47, 25, 22, 65, 30, 35)
  overall_goals_predict["West Brom",] <- c(40, 22, 18, 65, 30, 35)
  return(overall_goals_predict)
}