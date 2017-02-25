cat("\014")

if("Lahman" %in% rownames(installed.packages()) == FALSE) 
{install.packages("Lahman")}
if("dplyr" %in% rownames(installed.packages()) == FALSE) 
{install.packages("dplyr")}
if("ggplot2" %in% rownames(installed.packages()) == FALSE) 
{install.packages("ggplot2")}

library(Lahman)
library(dplyr)
library(ggplot2)

#1.Using Lahman MLB data in R, list the top 5 teams since 2000 with the largest stolen bases per at bat ratio:

# A using the team data
#also there were some team name changes so, need to reflect that
mydata = Teams %>% select(yearID, name, SB, AB) %>%
  filter(yearID>= 2000)%>%
  mutate(name = ifelse(name == "Tampa Bay Devil Rays", "Tampa Bay Rays", name)) %>%
  mutate(name = ifelse(name == "Anaheim Angels", "Los Angeles Angels of Anaheim", name)) %>%
  group_by(name) %>%
  summarise(SB = sum(SB), AB = sum(AB)) %>%
  mutate(sbpab = SB/AB) %>%
  arrange(desc(sbpab))
head(mydata,5)

#2. Using this same Batting data, plot the yearly SB.Per.AB rate.  This will be computed over the entire year rather than per team-year as above.
