#import
library(readr)
library(dbplyr)
library(dplyr)
library(ggplot2)
library(qqplotr)
library(GGally)
library(matlib)
library(car)
setwd("C:/Users/tminh/Desktop/BTL XSTK")
#Data import
data = read.csv("machine.data", header = FALSE)
colnames(data) = c("vendor name", "model name", "MYCT", "MMIN", "MMAX", "CACH", "CHMIN", "CHMAX", "PRP", "ERP")
paste("Du lieu co", ncol(data), "cot,", nrow(data), "hang")

#Data cleaning
data = data %>% select(3:9)
data %>% sapply(function(col) sum(is.na(col)))


#Histogram
#MYCT
data %>% ggplot(aes(x=MYCT)) + 
  geom_histogram(binwidth = 50, color="darkblue", fill="lightblue") + 
  labs(title="Histogram plot of Machine cycle time",x="Machine cycle time (ns)", y = "Frequency")

#MMIN
data %>% ggplot(aes(x=MMIN)) +
  geom_histogram(color="darkred", fill="pink") +
  labs(title="Histogram plot of Minimum main memory size", x="Minimum main memory size (KB)", y = "Frequency")

#MMAX
data %>% ggplot(aes(x=MMAX)) +
  geom_histogram(color="darkblue", fill="lightblue") +
  labs(title="Histogram plot of Maximum main memory size", x="Maximum main memory size (KB)", y = "Frequency")

#CACH
data %>% ggplot(aes(x=CACH)) +
  geom_histogram(color="darkred", fill="pink") +
  labs(title="Histogram plot of Cache size", x="Cache size (KB)", y = "Frequency")

#CHMIN
data %>% ggplot(aes(x=CHMIN)) +
  geom_histogram(color="darkblue", fill="lightblue") +
  labs(title="Histogram plot of Minimum units of channel", x="Channels (units)", y = "Frequency")

#CHMAX
data %>% ggplot(aes(x=CHMAX)) +
  geom_histogram(color="darkred", fill="pink") +
  labs(title="Histogram plot of Maximimum units of channel", x="Channels (units)", y = "Frequency")

#PRP
data %>% ggplot(aes(x=PRP)) +
  geom_histogram(color="darkblue", fill="lightblue") +
  labs(title="Histogram plot of Published Relative Performance", x="Relative performance", y = "Frequency")

#Boxplot
par(mfrow=c(2,3))
boxplot(data$MYCT,  xlab = "MYCT")
boxplot(data$MMIN,  xlab = "MMIN")
boxplot(data$MMAX,  xlab = "MMAX")
boxplot(data$CACH,  xlab = "CACH")
boxplot(data$CHMIN, xlab = "CHMIN")
boxplot(data$CHMAX, xlab = "CHMAX")
boxplot(data$PRP, xlab = "PRP")

#Pair plot
ggpairs(data)

#Data transformation
data$MYCT <- data$MYCT %>% log()
data$MMIN <- data$MMIN %>% log()
data$MMAX <- data$MMAX %>% log()
data$CACH <- (data$CACH + 1) %>% log()
data$CHMIN <- (data$CHMIN + 1) %>% log()
data$CHMAX <- (data$CHMAX + 1) %>% log()
data$PRP <- data$PRP %>% log()

#Boxplot
boxplot(data)

#Thong ke don bien
means <- data %>% sapply(mean)
medians <- data %>% sapply(median)
sds <- data %>% sapply(sd)
mins <- data %>% sapply(min)
maxs <- data %>% sapply(max)
uniques <- data %>% sapply(function(col) length(unique(col)))
summary <- as.data.frame(cbind(means, medians, sds, mins, maxs, unique()))
names(summary) <- c("mean", "median", "sd", "min", "max", "unique")

#Pair plot
ggpairs(data)

#Spliting dataset
set.seed(5)
sample <- sample(c(TRUE, FALSE), nrow(data), replace=TRUE, prob=c(0.9,0.1))
train <- data[sample , ]
test <- data[!sample ,]

#Thong ke don bien
means <- train %>% sapply(mean)
medians <- train %>% sapply(median)
sds <- train %>% sapply(sd)
mins <- train %>% sapply(min)
maxs <- train %>% sapply(max)
uniques <- train %>% sapply(function(col) length(unique(col)))
summary <- as.data.frame(cbind(means, medians, sds, mins, maxs, uniques))
names(summary) <- c("mean", "median", "sd", "min", "max", "unique")
#covariants
covariants <- train %>% cov() %>% as.data.frame()


#Linear Regression
ggpairs(train)
model <- lm(PRP ~ MYCT + MMIN + MMAX + CACH + CHMIN + CHMAX, train)
estimate <-summary(model)$coefficients %>% as.data.frame() %>% select(1:2)


#SSE, SSR, SST
SSE <- (model$residuals ^ 2) %>% sum()
SSR <- ((model$fitted.values - mean(train$PRP)) ^ 2) %>% sum()
SST <- ((train$PRP - mean(train$PRP)) ^ 2) %>% sum()
ss <- as.data.frame(c(SSE, SSR, SST), row.names = c("SSE", "SSR", "SST"))
names(ss) <- c("Value")

#R^2
summary(model)$sigma
summary(model)$adj.r.squared
#p_value
summary(model)$coefficients %>% as.data.frame() %>% select(3:4)

#Checking assumption
par(mfrow=c(1,1))
plot(model, col = "steel blue", which = 1)

par(mfrow=c(1,1))
plot(model, col = "steel blue", which = 2)

par(mfrow=c(1,1))
plot(model, col = "steel blue", which = 3)

par(mfrow=c(1,1))
plot(model, col = "steel blue", which = 5)

#VIF
vif(model) %>% as.data.frame() %>% select(1:1)
#Predict
predicts <- predict(model, newdata = test)
actuals <- test$PRP
evaluate <- data.frame(actuals ,predicts)
summary(evaluate)

evaluate_T <- t(evaluate)
#Model accuracy
m <- lm(actuals~predicts,data=evaluate)
summary(m)

#MSE
MSE <- ((evaluate$actuals - evaluate$predicts)^2) %>% sum()
MSE <- MSE/23

#MYCT remove
model <- lm(PRP ~ MMIN + MMAX + CACH + CHMIN + CHMAX, train)
estimate <-summary(model)$coefficients %>% as.data.frame() %>% select(1:2)

SSE <- (model$residuals ^ 2) %>% sum()
SSR <- ((model$fitted.values - mean(train$PRP)) ^ 2) %>% sum()
SST <- ((train$PRP - mean(train$PRP)) ^ 2) %>% sum()
ss <- as.data.frame(c(SSE, SSR, SST), row.names = c("SSE", "SSR", "SST"))
names(ss) <- c("Value")

summary(model)$sigma
summary(model)$adj.r.squared
summary(model)$coefficients %>% as.data.frame() %>% select(3:4)

par(mfrow=c(2,2))
plot(model)
vif(model) %>% as.data.frame() %>% select(1:1)

predicts <- predict(model, newdata = test)
actuals <- test$PRP
evaluate <- data.frame(actuals ,predicts)
summary(evaluate)
evaluate

evaluate_T <- t(evaluate)
#MSE
MSE <- ((evaluate$actuals - evaluate$predicts)^2) %>% sum()
MSE <- MSE/23
#Model accuracy
m <- lm(actuals~predicts,data=evaluate)
summary(m)