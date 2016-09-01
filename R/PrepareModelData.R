
library(caret)
source('./R/cleanPfrData.R')

CleanPfrData()

in_data <- read.csv('./data/Pfr_FantasyData_AllSeasons.csv', stringsAsFactors = FALSE)
#in_data <- in_data[which(in_data$year < 2015), ]
in_data$quintile <- as.factor(in_data$quintile)
in_data$q_f1 <- as.character(in_data$q_f1)
in_data$q_f1[is.na(in_data$q_f1)] <- 'NA'
in_data$q_f1 <- as.factor(in_data$q_f1)
in_data$FantPos <- as.factor(in_data$FantPos)
mod_data <- in_data[which(in_data$year < 2015), ]
future_data <- in_data[which(in_data$year == 2015), ]

set.seed(127)
training_sample <- createDataPartition(y=mod_data$quintile, p=0.7, list=FALSE)
training <- mod_data[training_sample, ]
testing <- mod_data[-training_sample, ]

#in_data[which(in_data$namecode == 'JameEd00'), c('year', 'Rk', 'Rk_f1', 'quintile', 'q_f1')]
