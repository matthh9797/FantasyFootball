cutSeason <- function(result_df, TEAM, years) {
  seasonSections <- as.factor(rep(c(rep(1,13), rep(2,12), rep(3,13)), length(years)))
  levels(seasonSections) <- c("Start of Season", "Middle of Season", "End of Season")
  teamResults <- filter(result_df, (HomeTeam == TEAM | AwayTeam == TEAM) & Season %in% years)
  teamResults <- mutate(teamResults, Period = seasonSections)
  home <- filter(teamResults, HomeTeam == TEAM) %>% group_by(Period)
  away <- filter(teamResults, AwayTeam == TEAM) %>% group_by(Period)
  home <- home %>% summarise(HomeGoal=sum(FTHG), HomeConcede=sum(FTAG))
  away <- away %>% summarise(AwayGoal=sum(FTAG), AwayConcede=sum(FTHG))
  data <- merge(home, away)
}
