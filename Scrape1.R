
library(ffanalytics)
ffnAPI <- '2b4ju69v5akw'

analysts[analysts$analystId == 4, "weight", with=FALSE] <- 0.5

scrapeData <- runScrape(
  week = 0, season = 2016, 
  analysts = c(-1, 5, 7, 18, 27), 
  positions = c("QB", "RB", "WR", "TE", "K", "DST")
)