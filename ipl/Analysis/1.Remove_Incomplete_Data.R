###

# SET WORKING DIRECTORY TO SOURCE FILE LOCATION

# Session -> Set Working Directory -> To Sourec File Location

###

setwd("../InitialDatasets")

#install.packages("sqldf")
library(sqldf)

# read all matches from csv
allMatches = read.csv("matches.csv")

# filter to get only completed matches with a result
completedMatches <- sqldf('SELECT * FROM allMatches where dl_applied == 0 AND result != "no result"')

# write completed matches to matches.csv in Analysis folder
write.csv(completedMatches,'../Analysis/matches.csv')

# update deliveries in Analysis folder to only include completed matches
deliveries <-read.csv("deliveries.csv")
deliveriesFromCompletedMatches <- sqldf('select * from deliveries where match_id in (select id from completedMatches)')
write.csv(deliveriesFromCompletedMatches,'../Analysis/deliveries.csv')

setwd("../Analysis")

