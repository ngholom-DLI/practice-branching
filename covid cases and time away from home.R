


#libraries
library(reshape2)
library(readxl)
library(stringr)
library(plyr)
require(data.table)
library(tidyverse)
library(lubridate)
library(zoo)
library(ggplot2)



#URLs for Mobility data:
tm_outside<-"https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/Google%20Mobility%20-%20State%20-%20Daily.csv"
covid<-"https://raw.githubusercontent.com/OpportunityInsights/EconomicTracker/main/data/COVID%20-%20State%20-%20Daily.csv"


#set directories
final<-'\\\\DLIVSPW01FILE\\ECONSECURE\\Nick\\Interesting\\'

#read in time outside data
tm_out<-read.csv(tm_outside)
covid_df<-read.csv(covid)


#subset data frames to Montana
covid_df<-subset(covid_df, statefips==30)
tm_out<-subset(tm_out, statefips==30)

#combine dataframes
comb_df<-left_join(covid_df, tm_out, by=c("statefips","year", "month", "day"))

#add date variable
comb_df$date<-as.Date(paste0(comb_df$year,"-", comb_df$month, "-", comb_df$day))

#subset dataframe
comb_df<-subset(comb_df, !is.na(gps_retail_and_recreation))
comb_df<-comb_df %>% select(date, gps_retail_and_recreation:gps_away_from_home)


#plot graph:
ggplot()+geom_line(data = comb_df, aes(x = date, y = gps_retail_and_recreation), color = "blue") +
  geom_line(data = comb_df, aes(x = date, y = gps_away_from_home), color = "red") +
  xlab('Dates') +
  ylab('Time by Location, Indexed to Pre-pandemic')


#write to csv for graph
write_csv(comb_df, paste0(final, "time_away_covid_cases.csv"), na="")

#R also has a devtools package that helps with putting your package on github and then downloading that package:
#Maybe we'll eventually be developing our own packages, in which case
#People would be able to install our packages straight from github with just two lines:
install.packages("devtools")
devtools::install_github("username/packagename")
