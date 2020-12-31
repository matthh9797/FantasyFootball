average_goals <- function(overall_goals) {
  # average_goals is a dataframe containing the goals per game version of overall_goals
  average_goals <- transform(overall_goals, 
                             # per game rates rounded to two significant figures
                             overall_goal = round((overall_goal / 38), 2), overall_concede = round((overall_concede / 38), 2),
                             home_goal = round((home_goal / 19), 2), away_goal = round((away_goal / 19), 2), 
                             home_concede = round((home_concede / 19), 2), away_concede = round((away_concede / 19), 2), 
                             # home/away ratio of goals scored, away/home ratio of goals conceded
                             ha_ratio_goal = round((home_goal / away_goal), 2), 
                             ah_ratio_concede = round((away_concede / home_concede), 2))
  return(average_goals)
}

