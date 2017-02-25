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

# Ans: using the Team data
#also there were some team name changes so, need to reflect that
mydata = Teams %>% select(yearID, name, SB, AB, teamID) %>%
  filter(yearID>= 2000)%>%
  mutate(name = ifelse(name == "Tampa Bay Devil Rays", "Tampa Bay Rays", name)) %>%
  mutate(name = ifelse(name == "Anaheim Angels", "Los Angeles Angels of Anaheim", name)) %>%
  group_by(name) %>%
  summarise(SB = sum(SB), AB = sum(AB)) %>%
  mutate(sbpab = SB/AB) %>%
  arrange(desc(sbpab))
head(mydata %>% select(name),5)

#head(Batting)

#2. Using this same Batting data, plot the yearly SB.Per.AB rate.  This will be computed over the entire year rather than per team-year as above.
mydata = Batting %>% select(yearID, teamID, SB, AB) %>%
  filter(!is.na(SB)) %>%
  filter(!is.na(AB)) %>%
  group_by(yearID) %>%
  summarise(SB = sum(SB), AB = sum(AB)) %>%
  filter(AB != 0) %>%
  mutate(sbpab = SB/AB) %>%
  arrange(yearID)
mydata %>%
  ggplot(., aes(x = yearID, y = sbpab)) + geom_line()
#head(mydata)


#2a.  Same plot but color each plot by lgID (LeagueID).  For this problem we only care about NL and AL, everything else can be filtered out.
mydata = Batting %>% select(yearID, teamID, SB, AB, lgID) %>%
  filter(lgID == "NL" | lgID == "AL" ) %>%
  filter(!is.na(SB)) %>%
  filter(!is.na(AB)) %>%
  group_by(yearID, lgID) %>%
  summarise(SB = sum(SB), AB = sum(AB)) %>%
  filter(AB != 0) %>%
  mutate(sbpab = SB/AB) %>%
  arrange(yearID)
ggplot(mydata, aes(x=yearID, y=sbpab,group=lgID, colour=lgID)) +
  geom_line()


#3.  Use this Year, SB.PerAB dataset (generated in #2 above) to create a model for how year relates to SB.PerAB.  In this problem you are using only yearID to predict SB.PerAB.  Try a few model fits and determine which one is best.
  


#4. A baseball player is said to be continuously playing if he's playing for consequent years. Given the years that some baseball player played in, write the function activeYears which computes the sequence of the lengths of the continuous playing. 