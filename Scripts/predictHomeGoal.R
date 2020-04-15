predictHomeGoal <- function(HomeTeam, AwayTeam) {
  OvAwayConcede <- sum(Stat_1819$HG)
  prediction <- Stat_1819$HG[[HomeTeam]] * 
    Stat_1819$AC[[AwayTeam]]/(OvAwayConcede - Stat_1819$AC[[HomeTeam]])
  return(prediction)
}
