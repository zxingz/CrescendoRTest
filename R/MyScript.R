cat("\014")

if("Lahman" %in% rownames(installed.packages()) == FALSE) 
{install.packages("Lahman")}
if("dplyr" %in% rownames(installed.packages()) == FALSE) 
{install.packages("dplyr")}
if("ggplot2" %in% rownames(installed.packages()) == FALSE) 
{install.packages("ggplot2")}
if("party" %in% rownames(installed.packages()) == FALSE) 
{install.packages("party")}


library(Lahman)
library(dplyr)
library(ggplot2)
library(party)

#data for python
wd <- dirname(sys.frame(1)$ofile)
write.csv(Batting, file = paste(wd, "/Batting.csv", sep = ""), row.names = TRUE)
write.csv(Teams, file = paste(wd, "/Teams.csv", sep = ""), row.names = TRUE)

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
mydata = Batting %>% select(yearID, teamID, SB, AB) %>%
  filter(!is.na(SB)) %>%
  filter(!is.na(AB)) %>%
  group_by(yearID) %>%
  summarise(SB = sum(SB), AB = sum(AB)) %>%
  filter(AB != 0) %>%
  mutate(sbpab = SB/AB) %>%
  arrange(yearID)

set.seed(10)
#linear regression
model <- lm(sbpab~yearID, data = mydata)
predicted <- predict(model, mydata["yearID"])
mean1 <- mean((mydata["sbpab"] - predicted)^2)
print(mean1)

#polynomial regression : degree 2
model <- lm(sbpab~poly(yearID,2), data = mydata)
predicted <- predict(model, mydata["yearID"])
mean2 <- mean((mydata["sbpab"] - predicted)^2)
print(mean2)

#polynomial regression : degree 3
model <- lm(sbpab~poly(yearID,3), data = mydata)
predicted <- predict(model, mydata["yearID"])
mean3 <- mean((mydata["sbpab"] - predicted)^2)
print(mean3)

#regression tree
model <- ctree(sbpab~yearID, data = mydata)
predicted <- predict(model, mydata["yearID"])
meant <- mean((mydata["sbpab"] - predicted)^2)
print(meant)

print("Best model is regression tree !")


#4. A baseball player is said to be continuously playing if he's playing for consequent years. Given the years that some baseball player played in, write the function activeYears which computes the sequence of the lengths of the continuous playing. 
activeYears <- function(nvec)
{
  #unique values for dates
  temp <- union(sort(unique(nvec)), c(-1))
  #removing NA
  temp <- temp[!is.na(temp)]
  #removing empty values
  temp <- temp[temp != ""]
  res = c()
  counter <- 1
  for (i in 1:(length(temp)-1))
  {
    #checking for only numeric values eg "1988" to 1998
    if (as.numeric(temp[i+1]) == as.numeric(temp[i])+1)
    {
      counter = counter + 1
    }
    else
    {
      res <- c(res, c(counter))
      counter <- 1
    }
  } 
  return(res)
}
nvec <- c(1999,1995,1996,1998,1999,2000,2001,2003,2004,2006)
activeYears(nvec)



