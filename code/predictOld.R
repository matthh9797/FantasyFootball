predictOld <- function(TEAM){
  # calculating home results within a tbl object
  data <- as.tbl(data.frame(Team = teams_1819))
  # predict home goal to be the total number of goals scored at home for the home team that season * the proportion of goals conceded by the 
  # away team with respect to the total goals conceded by every away team that season
  data <- mutate(data, HomeGoal =
                            homedata_1819[[which(homedata_1819$HomeTeam == TEAM), "GoalScored"]] * 
                            awaydata_1819$GoalAgainst / (totalGoal_1819[["HomeGoals"]] - 
                                                          # note: bias factor, minus number of goals scored against the home team whilst away from home
                                                          awaydata_1819[[which(awaydata_1819$AwayTeam == TEAM), "GoalAgainst"]])) %>%
    # create a rounded goals column
    mutate(RHG = round(HomeGoal, digits = 0)) %>%
    mutate(HomeConcede = awaydata_1819$GoalScored * homedata_1819[[which(homedata_1819$HomeTeam == TEAM), "GoalAgainst"]] / 
             (totalGoal_1819[["AwayGoals"]] - 
                awaydata_1819[[which(awaydata_1819$AwayTeam == TEAM), "GoalScored"]])) %>%
    mutate(RHC = round(HomeConcede, digits = 0))
  # calculating away results
  data <- mutate(data, AwayGoal = awaydata_1819[[which(awaydata_1819$AwayTeam == TEAM), "GoalScored"]] *
                            homedata_1819$GoalAgainst / (totalGoal_1819[["AwayGoals"]] - 
                                                          homedata_1819[[which(homedata_1819$HomeTeam == TEAM), "GoalAgainst"]])) %>%
    mutate(RAG = round(AwayGoal, digits = 0)) %>%
    mutate(AwayConcede = homedata_1819$GoalScored * awaydata_1819[[which(awaydata_1819$AwayTeam == TEAM), "GoalAgainst"]] / 
             (totalGoal_1819[["HomeGoals"]] - homedata_1819[[which(homedata_1819$HomeTeam == TEAM), "GoalScored"]])) %>%
    mutate(RAC = round(AwayConcede, digits = 0)) %>%
    # do not return row predicting team vs team as this has no real world value
    filter(Team != TEAM)
  return(data)

}





