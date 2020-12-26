# Fantasy Football

This project will focus on how to use data from the Premier League to make predctions about the coming season. This was motivated by my desire to beat my friends at Sky Fantasy Football in order to make some money. 

The 3 main questions this project will look to answer are 

1. How to predict the number of goals a team will score in a season
2. How to use the number of goals scored to predict the score in each match 
3. How to create a metric for attack and defence for each team over a range of dates 

The results of past seasons will be used throughout this project to make predictions.

The data object overall_goals has been used to summarise the overall number of goals scored by each team by season and average_goals is a data object which summarises the averege goals scored per game and the home:away ratios.


## Future Models

The first implementation of this project will not consider any factors as the season goes on and hence will aim to predict all results in each match before the season has started. I would like to add in the future factors that consider team lineups and focus on weather the premier league scores are a stochastics process, hence, do certain teams have a pattern in form.

In future versions of the model I would like to include categorical data such as: transfers made, weather, manager, formation, lineup ...