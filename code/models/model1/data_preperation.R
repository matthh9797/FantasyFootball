## Data preperation for machine learning model to predict the goals scored by each team in 
## the Premier League

# filter for the last 5 seasons and select just the overall goals 
goals_per_season <- filter(average_goals, Season %in% c("2015-16", "2016-17", "2017-18", "2018-19", "2019-20"))
goals_per_season <- select(goals_per_season, 1:3)
# reshape the dataframe to mkae the seasons the column headers 
library(reshape2)
goals_per_season <- reshape(goals_per_season, idvar = "Team", v.names = "overall_goal", timevar = "Season", direction = "wide")
goals_per_season <- na.omit(goals_per_season)
colnames(goals_per_season) <- c("Team", "Season-4", "Season-3", "Season-2", "Season-1", "Season(y)")
Team <- goals_per_season$Team
goals_per_season <- as.matrix(goals_per_season[,2:6])
rownames(goals_per_season) <- Team