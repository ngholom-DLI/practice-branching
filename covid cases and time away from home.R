


#libraries
library(reshape2)
library(readxl)
library(stringr)
library(plyr)
require(data.table)
library(tidyverse)
library(lubridate)
library(zoo)


#data from https://tracktherecovery.org/
#URL for mobility data:
tm_outside<-"https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/Google%20Mobility%20-%20State%20-%20Daily.csv"
covid<-"https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/COVID%20-%20State%20-%20Daily.csv"


#directory for output
final<-'\\\\DLIVSPW01FILE\\ECONSECURE\\Nick\\Interesting\\'

#read in data
tm_out<-read.csv(tm_outside)
covid_df<-read.csv(covid)


#subset data frames to Montana
covid_df<-subset(covid_df, statefips==30)
tm_out<-subset(tm_out, statefips==30)

#combined
comb_df<-left_join(covid_df, tm_out, by=c("statefips","year", "month", "day"))

#add date variable
comb_df$date<-as.Date(paste0(comb_df$year,"-", comb_df$month, "-", comb_df$day))

#write to csv for graph
write_csv(comb_df, paste0(final, "time_away_covid_cases.csv"), na="")