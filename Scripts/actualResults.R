actualResults <- function(TEAM) {
  ## Returns the actual results of the team from the 2018/2019 season
  homeResults <- filter(season201819, HomeTeam == TEAM) %>% arrange(AwayTeam)
  homeResults <- select(homeResults, 1:6)
  awayResults <- filter(season201819, AwayTeam == TEAM) %>% arrange(HomeTeam)
  awayResults <- select(awayResults, 1:6)
  results <- cbind(homeResults, awayResults)
  return(results)
}