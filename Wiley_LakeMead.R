getwd()
setwd("C:/Users/kalet/Downloads/Wiley_Kale_Project1")
mead <- read.csv('LakeMead_TimeSeries.csv', header=T)
mead$Time <- as.Date(mead$Time);mead

#Visualize the entire plot
LakeMead <- ts(mead$Elevation, frequency=12)
plot(LakeMead, main='Lake Mead Water Monthly Water Levels', xlab='Years (00-23)', ylab='Water Level')


#Split data into Training and testing
#First 75% training 25% testing
index <- 1:floor(nrow(mead)*.95)
train <- mead[index,]
test <- mead[-index,]

#Plot to visualize train and test data
LakeMeadTrain <- ts(train$Elevation, frequency=12)
plot(LakeMeadTrain,main='Lake Mead Water Level Training', xlab='Years (00-23)', ylab='Water Level')

LakeMeadTest <- ts(test$Elevation, frequency=12)
plot(LakeMeadTest,main='Lake Mead Water Level Testing', xlab='Time', ylab='Water Level')

#Find Stationary
library(tseries)
adf.test(LakeMeadTrain)
#Not Stationary p-value > 0.05

MeadDiff <- diff(LakeMeadTrain, differences=1)
adf.test(MeadDiff)
plot(MeadDiff, main = 'First Order Difference Time Series', ylab='Elevation')
#Stationary but seasonal trends present

MeadSeasonal <- diff(LakeMeadTrain, differences=12)
adf.test(MeadSeasonal)
plot(MeadSeasonal,main='Seasonal Difference Time Series', ylab='Elevation')
#Stationary no seasonal trends present

#ACF and PACF plots
acf(MeadSeasonal, lag.max=20, main='ACF Lake Mead Seasonal Differences')
pacf(MeadSeasonal, lag.max=20, main='PACF Lake Mead Seasonal Differences')
#Suggests ARIMA(2,1,3) model

library(TSA)

#ARIMA
arimaModel <- arima(MeadSeasonal, order = c(2,1,3))
print(arimaModel)
AIC(arimaModel)
BIC(arimaModel)

arimaResid <- residuals(arimaModel)
qqnorm(arimaResid)
qqline(arimaResid)

#Look at the model and how it predicts
fittedValues = fitted(arimaModel)
plot(MeadSeasonal, type = 'l',main='ARIMA(2,1,3) Plot', ylab = 'Water Level')
lines(fittedValues, col = 'blue')

#Test Model
plot(arimaModel, type='l', n.ahead=15)
Final1 <- diff(LakeMead, differences=12)
plot(Final1, main='Full Lake Mead Level Plot', ylab='Difference in Levels')

#Forecast Values
forecast <- predict(arimaModel, n.ahead = 15)
forecast$pred

#Dynamic harmonic Regression model
fouriers <- fourier(MeadDiff, K=1)
harModel <- auto.arima(MeadDiff, xreg=fouriers)
print(harModel)

#Diagnostics and visuals
tsdiag(harModel)
plot(MeadDiff, main="Dynamic Harmonic Regression Model", xlab="Time", ylab="Water Level")
lines(fitted(harModel), col='purple')

harForecast <- forecast(harModel, xreg = fourier(LakeMeadTrain,K=1, h=15))
plot(harForecast)
Lakediff <- diff(LakeMead, differences=1)
plot(Lakediff, main='First Order Differencing Full Series')
harForecast2 <- forecast(harModel, xreg = fourier(LakeMeadTrain,K=1, h=60))
plot(harForecast2)
