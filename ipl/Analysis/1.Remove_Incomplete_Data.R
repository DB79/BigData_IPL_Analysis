###

# SET WORKING DIRECTORY TO SOURCE FILE LOCATION

#MAYBE SOLUTION

#this.dir <- dirname(parent.frame(2)$ofile)
#setwd(this.dir)

###

this.dir <- dirname(parent.frame(3)$ofile) # frame(3) also works.
setwd(this.dir)

setwd("../InitialDatasets")



#install.packages("sqldf")
library(sqldf)

#read all matches from csv
allMatches = read.csv("matches.csv")

#remove any matches that produced no result or were decided by DL
completedMatches <- sqldf('SELECT * FROM allMatches where dl_applied == 0 AND result != "no result"')

#write completed matches to matches.csv in Analysis folder
write.csv(completedMatches,'../Analysis/matches.csv')

#update deliveries in Analysis folder to only include completed matches
deliveries <-read.csv("deliveries.csv")
deliveriesFromCompletedMatches <- sqldf('select * from deliveries where match_id in (select id from completedMatches)')
write.csv(deliveriesFromCompletedMatches,'../Analysis/deliveries.csv')

