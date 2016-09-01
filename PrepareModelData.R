
library(caret)

in_data <- read.csv('./data/Pfr_FantasyData_AllSeasons.csv', stringsAsFactors = FALSE)
in_data <- in_data[which(in_data$year > 2000), ]
in_data$quintile <- as.factor(in_data$quintile)
in_data$q_l1 <- as.character(in_data$q_l1)
in_data$q_l1[is.na(in_data$q_l1)] <- 'NA'
in_data$q_l1 <- as.factor(in_data$q_l1)
in_data$FantPos <- as.factor(in_data$FantPos)


set.seed(127)
training_sample <- createDataPartition(y=in_data$quintile, p=0.7, list=FALSE)
training <- in_data[training_sample, ]
testing <- in_data[-training_sample, ]

