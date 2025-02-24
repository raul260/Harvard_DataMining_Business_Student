#' Author: Ted Kwartler
#' Date: 11-1-2020
#' Purpose: Simple Moving Avg Example As Indicator
#'

# Opts
options(scipen=999)

# Libs
library(TTR)
library(quantmod)
library(PerformanceAnalytics)

# Get Salesforce
getSymbols("CRM") #"CRM_1_TTR_C.rds"
CRM <- CRM['2018-03-01/2019-06-22'] 

# Calculate moving averages
CRMma50  <- SMA(CRM$CRM.Close, 50)
CRMma200 <- SMA(CRM$CRM.Close, 200)

# Organize data
df        <- data.frame(CRM$CRM.Close, CRMma50, CRMma200)
names(df) <- c('CRMclose', 'sma50', 'sma200')

# Construct a trading rule; 1 = buy or stay in stock, 0 = sell
# Not discussing shorting a stock (-1)
df$Lag.1 <- Lag(ifelse(df$sma50 > df$sma200, 1, 0), k = 1) 
?Lag

# Examine part1
df[199:205,] # row 200 is NA for `Lag.1` due to Lag()

# Examine part2
df[235:240,]

# Examine more 
tail(df, 25)
summary(df$Lag.1)
table(df$Lag.1)

# Now let's do it for a longer backtest with a different stock
stk   <- getSymbols("X", auto.assign = F) 
stk   <- stk['2019-01-01/']
ma50  <- SMA(Cl(stk), 50)
ma200 <- SMA(Cl(stk), 200)

# Set up the indicator
tradeSignal <- Lag(ifelse(ma50 > ma200  , 1, 0))
table(tradeSignal)
ret         <- ROC(Cl(stk))*tradeSignal #Rate of Change TTR::ROC(); not receiever operating curve

# Review your return
charts.PerformanceSummary(ret)

# Compare to buy & hold
plot(Cl(stk))

# Now let's be knight cap and switch a sign!
stk      <- getSymbols("X", auto.assign = F) 
stk      <- stk['2019-01-01/']
ma50     <- SMA(Cl(stk), 50)
ma200    <- SMA(Cl(stk), 200)
tradeSignal <- Lag(ifelse(ma50 > ma200  , 0, 1), k = 1)
ret         <- ROC(Cl(stk))*tradeSignal #Rate of Change TTR::ROC()

# Review your return
charts.PerformanceSummary(ret)
plot(Cl(stk))

# End
