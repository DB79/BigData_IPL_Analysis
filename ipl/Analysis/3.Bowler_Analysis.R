###

# SET WORKING DIRECTORY TO SOURCE FILE LOCATION

# Session -> Set Working Directory -> To Sourec File Location

###

#install.packages("ggrepel")
#install.packages("dplyr")
#install.packages("sqldf")
#install.packages("ggplot2") 

library(sqldf)
library(ggplot2) 
library(dplyr)
library(ggrepel)

deliveries <- read.csv('deliveries.csv')


########################################################################################################################
# Perform Analysis of Data to create new data which will be used in ANalysis
########################################################################################################################

# get total number of matches played by each platyer
matches_per_player <- sqldf('
  select bowler, 
  count(DISTINCT(match_id)) as "total_matches" 
  from deliveries group by bowler')

# dot balls, total balls, runs conceded by each player
bowler_stats <- group_by(deliveries, bowler)%>%
  summarise(dot_balls = sum(ifelse(batsman_runs ==0 & extra_runs == 0 , 1, 0 )),
                                   total_balls = sum(ifelse(wide_runs == 1 & noball_runs == 1, 0, 1 )), 
                                   total_runs = sum(batsman_runs+extra_runs))

# add number of games played per player
bowler_stats <- merge(bowler_stats, matches_per_player, by.x = "bowler", by.y = "bowler")


# total wickets per player
total_wickets_per_player <- group_by(deliveries, bowler)%>%
  summarise(wickets = sum(ifelse(dismissal_kind 
  %in% c("caught", "bowled", "lbw", "caught and bowled"), 1,0)))

bowler_stats <- merge(bowler_stats, 
                      total_wickets_per_player, 
                      by.x = "bowler", 
                      by.y = "bowler")

# remove bowler name to allow for creation of boxplots
bowler_overall_stats <- sqldf('
  select dot_balls as "Dots" ,
  total_balls as "Deliveries", 
  total_runs as "Runs_Conceded", 
  wickets, 
  total_matches 
  from bowler_stats')

bowler_stats_Per_match <- sqldf('
  select (total_balls/total_matches) as "Deliveries_Per_Match",
  (total_runs/total_matches) as "Runs_Conceded_Per_Match",
  (dot_balls/total_matches) as "Dots_Per_Match",
  (wickets/total_matches) as "Wickets_Per_Match" 
  from bowler_stats')

########################################################################################################################
# boxplot of Deliveries per player per match
########################################################################################################################

png(filename="Images/Boxplot_Player_Deliveries_Per_Match.png")
boxplot(bowler_stats_Per_match$Deliveries_Per_Match, 
        main="Boxplot of Deliveries per player per match", 
        ylab="Number of Deliveries")
dev.off()

summary(bowler_stats_Per_match$Deliveries_Per_Match)

########################################################################################################################
# Scatter Plot of Run Conceeded Vs Number of Deliveries
########################################################################################################################

png(filename="Images/Scatter_Plot_Runs_Conceded_Vs_Deliveries.png")
plot(bowler_stats_Per_match$Deliveries_Per_Match,
     bowler_stats_Per_match$Runs_Conceded_Per_Match,
     main = "Scatter Plot	of Runs Conceded vs No. of Deliveries",
     xlab = "Average No. Of Deliveries",
     ylab = "Average Runs Conceded")

dev.off()

cor(bowler_stats_Per_match$Deliveries_Per_Match, bowler_stats_Per_match$Runs_Conceded_Per_Match)

########################################################################################################################
# Scatter Plot of Dot Balls Vs Number of Deliveries 
########################################################################################################################

png(filename="Images/Scatter_Plot_Dots_Balls_Vs_Deliveries.png")

plot(bowler_stats_Per_match$Deliveries_Per_Match,
     bowler_stats_Per_match$Dots_Per_Match,
     main = "Scatter Plot of No. of Dot Balls vs No. of Deliveries",
     xlab = "Average No. Of Deliveries",
     ylab = "Average Dot Balls")

dev.off()

cor(bowler_stats_Per_match$Deliveries_Per_Match, bowler_stats_Per_match$Dots_Per_Match)

########################################################################################################################
# Scatter Plot of Wicets Taken Vs Number of Deliveries
########################################################################################################################

png(filename="Images/Scatter_Plot_Wickets_Taken_Vs_Deliveries.png")

plot(bowler_stats_Per_match$Deliveries_Per_Match,
     bowler_stats_Per_match$Wickets_Per_Match,
     main = "Scatter Plot of Wickets Taken vs No. of Deliveries",
     xlab = "Average No. Of Deliveries",
     ylab = "Average Wickets Taken")

dev.off()

cor(bowler_stats_Per_match$Deliveries_Per_Match, bowler_stats_Per_match$Wickets_Per_Match)

