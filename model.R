
library(caret)

in_data <- read.csv('./data/clean/FullDf.csv', stringsAsFactors = FALSE)
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



nznames <- c("FantPos", 'q_l1')


fitControl <- trainControl(method='cv', number = 3)
model_cart <- train(
  quintile ~ ., 
  data=training[, c('quintile', nznames)],
  trControl=fitControl,
  #preProcess=c('center', 'scale'),
  method='rpart'
)
#save(model_cart, file='./ModelFitCART.RData')
predCART <- predict(model_cart, newdata=testing)
cmCART <- confusionMatrix(predCART, testing$quintile)



model_gbm <- train(
  quintile ~ ., 
  #data=training[, 8:ncol(training)],
  data=training[, c('quintile', nznames)],
  trControl=fitControl,
  #preProcess=c('center', 'scale'),
  method='gbm'
)
#save(model_gbm, file='./ModelFitGBM.RData')
model_rf <- train(
  quintile ~ ., 
  #data=training[, 8:ncol(training)],
  data=training[, c('quintile', nznames)],
  trControl=fitControl,
  #preProcess=c('center', 'scale'),
  method='rf',
  ntree=100
)
#save(model_rf, file='./ModelFitRF.RData')
# plot(model$finalModel)
# text(model$finalModel)

#load('./ModelFitRF.RData')

predCART <- predict(model_cart, newdata=testing)
cmCART <- confusionMatrix(predCART, testing$quintile)

predGBM <- predict(model_gbm, newdata=testing)
cmGBM <- confusionMatrix(predGBM, testing$quintile)

predRF <- predict(model_rf, newdata=testing)
cmRF <- confusionMatrix(predRF, testing$quintile)

AccuracyResults <- data.frame(
  Model = c('CART', 'GBM', 'RF'),
  Accuracy = rbind(cmCART$overall[1], cmGBM$overall[1], cmRF$overall[1])
)

future <- in_data[which(in_data$year == 2015), c('FantPos', 'quintile', 'X', 'Rk', 'Rk_l1')]
names(future)[2] <- 'q_l1'
future$Rk_fit <- predict(model_gbm, newdata = future)

future[which(future$Rk_fit == 1 & future$FantPos != 'QB'),]
