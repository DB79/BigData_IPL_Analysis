
setwd("D:/yr4/Big_Data/Project/ipl/Analysis")

#install.packages("sqldf")
#install.packages("rpart")
#install.packages('rattle')
#install.packages('rpart.plot')
#install.packages('RColorBrewer')
#install.packages("arules")
#install.packages("arulesViz")
#install.packages("sqldf")

library(sqldf)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library(sqldf)
library(rpart)
library("arules")
library("arulesViz")

#deliveries <- read.csv("deliveries.csv")
deliveries <- read.csv("deliveries.csv", stringsAsFactors=TRUE)

##############################################################################################################################
# Add Outcome Field which is used in assocciation rules
##############################################################################################################################


# Dot balls - no runs scored

#deliveries$outcome[deliveries$total_runs == 0] <- 'Dot Ball'

# Low Score - 1 to 3 runs
#deliveries$outcome[deliveries$total_runs == 1] <- 'Low Score'
#deliveries$outcome[deliveries$total_runs == 2] <-'Low Score'
#deliveries$outcome[deliveries$total_runs == 3] <-'Low Score'
  
# High Score - 4+ runs
#deliveries$outcome[deliveries$total_runs == 4] <-'High Score'
#deliveries$outcome[deliveries$total_runs == 5] <-'High Score'
#deliveries$outcome[deliveries$total_runs == 6] <-'High Score'
#deliveries$outcome[deliveries$total_runs == 7] <-'High Score'

# Wicket - wicket taken by boler
#deliveries$outcome[deliveries$player_dismissed != ""] <- 'Wicket'

#prop.table(table(deliveries$outcome, deliveries$bowling_team),2)
#deliveries <- read.csv("deliveries.csv", stringsAsFactors=TRUE)

##############################################################################################################################
# Add Outcome Field which is used in assocciation rules
##############################################################################################################################


# Dot balls - no runs scored

deliveries$outcome[deliveries$total_runs == 0] <- 'Dot Ball'

# Low Score - 1 to 3 runs
deliveries$outcome[deliveries$total_runs == 1] <- 'Low Score'
deliveries$outcome[deliveries$total_runs == 2] <-'Low Score'
deliveries$outcome[deliveries$total_runs == 3] <-'Low Score'

# High Score - 4+ runs
deliveries$outcome[deliveries$total_runs == 4] <-'High Score'
deliveries$outcome[deliveries$total_runs == 5] <-'High Score'
deliveries$outcome[deliveries$total_runs == 6] <-'High Score'
deliveries$outcome[deliveries$total_runs == 7] <-'High Score'

# Wicket - wicket taken by boler
deliveries$outcome[deliveries$player_dismissed != ""] <- 'Wicket'

deliveries$outcome <- as.factor(deliveries$outcome)

prop.table(table(deliveries$outcome, deliveries$bowling_team),2)

################################################################################################################################
# ASSOCIATION RULES
################################################################################################################################


################################################################################################################################
# GAYLE VS KKR
gayleVsKKR = sqldf('select batsman, outcome from deliveries where batsman = "CH Gayle" and bowling_team = "Kolkata Knight Riders"')
kkrRules = apriori(gayleVsKKR, parameter=list(support=0.00009, confidence=1))
inspect(kkrRules)

################################################################################################################################
#GAYLE VS MI
gayleVsMI = sqldf('select batsman, outcome from deliveries where batsman = "CH Gayle" and bowling_team = "Mumbai Indians"')
miRules = apriori(gayleVsMI, parameter=list(support=0.00009, confidence=1))
inspect(miRules)

# AB de Villiers VS MI
abVsMI = sqldf('select batsman, outcome from deliveries where batsman = "AB de Villiers" and bowling_team = "Mumbai Indians"')
abRules = apriori(abVsMI, parameter=list(support=0.00009, confidence=1))
inspect(abRules)

################################################################################################################################
#GAYLE VS SRH
gayleVsSRH = sqldf('select batsman, outcome from deliveries where batsman = "CH Gayle" and bowling_team = "Sunrisers Hyderabad"')
srhRules = apriori(gayleVsSRH, parameter=list(support=0.00009, confidence=1))
inspect(srhRules)

################################################################################################################################
#GAYLE VS Harbhajan Singh
gayleVsHS = sqldf('select batsman, outcome from deliveries where batsman = "CH Gayle" and bowler = "Harbhajan Singh"')
hsRules = apriori(gayleVsHS, parameter=list(support=0.00009, confidence=1))
inspect(hsRules)

################################################################################################################################
#GAYLE VS SL Malinga
gayleVsLM = sqldf('select batsman, outcome from deliveries where batsman = "CH Gayle" and bowler = "SL Malinga"')
lmRules = apriori(gayleVsLM, parameter=list(support=0.00009, confidence=1))
inspect(lmRules)

################################################################################################################################
#GAYLE VS P Kumar
gayleVsPK = sqldf('select batsman, outcome from deliveries where batsman = "CH Gayle" and bowler = "P Kumar"')
pkRules = apriori(gayleVsPK, parameter=list(support=0.00009, confidence=1))
inspect(pkRules)
