setwd('/home/hduser1/Downloads/nifty')
library(lubridate)        # For Date time
library(stringr)          # For month(Strings)
library(forecast)         # For forecasting, in general
library(forecastHybrid)   # For hybrid forecasting
library(ggvis)            # For plotting
library(dygraphs)         # For plotting timeseries
library(TTR)              # For moving averages
library(zoo)              # For irregular time series
#library(ggplot2)          # For forecastHybrid
library(car)              # For durbin-watson statistic
library(dplyr)
df<- read.csv('nifty.csv')
df$Date<- dmy(df$Date,tz = "UTC")
df<- df[complete.cases(df),]
sum(is.na(df))
#df.agg <- aggregate(df$Turnover..Rs..Cr. ~ month + year, df, FUN = sum)
#df$year<-year(df$Date)
#df$month<-month(df$Date)
#df$year<-as.factor(df$year)
#df$month<- as.factor(df$month)
#df$Date<-NULL
df$Turnover..Rs..Cr.<- as.numeric(df$Turnover..Rs..Cr.)
df<-df %>%
  mutate(month = format(Date, "%m"), year = format(Date, "%Y")) %>%
  group_by(year,month) %>%
  summarise(Turnover = sum(Turnover..Rs..Cr.))
df$year<- as.factor(df$year)
df$month<- as.factor(df$month)
df.ts<-ts(df[,3],frequency=12,start=c(1999,1))

# 4.
# 4.1 Plot timeseries
plot(df.ts)
# 4.2 Plot a window of timeseries
p_data<-window(df.ts,start=c(1999,1), end=c(2016,9)) 
plot(p_data)

# OR plot.ts(acme.ts)

dygraph(df.ts)
dygraph(df.ts) %>% dyRangeSelector()


##########Moving averages ----------------------------
# 5
# Calculate simple moving averages. Calculates trend.
df_MA<-SMA(df.ts,n=12)		  # Average 4 periods
df_MA<-lag(df_MA,1)  # lag of +1 will generally lag behind by 1

df_MA
# Plot. Note it is plot.ts() and not plot
# plot.ts(acmeforecast)
plot(df_MA)
plot(df_MA,xlab="Year",ylab="Acme Forecast")
#lines(df.ts,col="blue")      # Superimpose full time series

# 5.2
# OR use zoo package (it gives different but accurate results)
#   For 3-period MA it would be
#    Se References, Reference 2 for How rollmeans work?
ma3<-rollmeanr(df.ts,3,fill=NA)
# Lag the result by one period
ma3<-lag(ma3,1)
# Plot now both the curves
# Do not delete the first window after ploting the first figure otherwise it
# shows an error Error in plot.xy(xy.coords(x, y), type = type, ...) : 
#  plot.new has not been called yet
plot.ts(ma3)
lines(df.ts,col="red")
