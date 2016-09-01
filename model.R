

library(caret)

#mod_data[which(mod_data$namecode == 'JameEd00'), ]

# this is the forward looking outcome we are trying to predict 
outcome_var <- 'q_f1'

# These are the variables we'd like to use for modeling
nznames <- c(
  "FantPos", 'quintile', 'Age'
)  
# , 'Cmp', 'Att', 'Yds', 'TD', 'Int',
#   'Att.1', 'Yds.1', 'Y.A', 'TD.1', 'Tgt', 'Rec', 'Yds.2', 'Y.R',
#   'TD.2'
# )


fitControl <- trainControl(method='cv', number = 3)
model_cart <- train(
  q_f1 ~ ., 
  data=training[, c('q_f1', nznames)],
  trControl=fitControl,
  #preProcess=c('center', 'scale'),
  method='rpart'
)
#save(model_cart, file='./ModelFitCART.RData')
model_gbm <- train(
  q_f1 ~ ., 
  data=training[, c('q_f1', nznames)],
  trControl=fitControl,
  #preProcess=c('center', 'scale'),
  method='gbm'
)
#save(model_gbm, file='./ModelFitGBM.RData')
model_rf <- train(
  q_f1 ~ ., 
  data=training[, c('q_f1', nznames)],
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
cmCART <- confusionMatrix(predCART, testing$q_f1)

predGBM <- predict(model_gbm, newdata=testing)
cmGBM <- confusionMatrix(predGBM, testing$q_f1)

predRF <- predict(model_rf, newdata=testing)
cmRF <- confusionMatrix(predRF, testing$q_f1)

AccuracyResults <- data.frame(
  Model = c('CART', 'GBM', 'RF'),
  Accuracy = rbind(cmCART$overall[1], cmGBM$overall[1], cmRF$overall[1])
)
AccuracyResults

future <- future_data[, c('X', "FantPos", 'quintile', 'Age', 'Rk')]
#names(future)[2] <- 'q_f1'
future$Rk_fit <- predict(model_gbm, newdata = future)

future[which(future$Rk_fit == 1 & future$FantPos != 'QB'),]









