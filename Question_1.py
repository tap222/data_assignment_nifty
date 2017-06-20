import pandas as pd
import datetime
import os
from subprocess import check_output
from datetime import timedelta
os.chdir('/home/hduser1/Downloads/nifty')
print(check_output(["ls"]).decode("utf8"))
df = pd.read_csv('nifty.csv',low_memory = False)
df.shape
df.columns
df.isnull().sum().sum()
df['Date'] = pd.to_datetime(df.Date)
df['day'] = df.Date.dt.day
df['month'] = df.Date.dt.month
df['year'] = df.Date.dt.year
df['weekday'] = df.Date.dt.dayofweek
df['day_of_year'] = df.Date.dt.dayofyear
df.columns
df.head(5)
cnt_neg = 0
cnt_pos= 0
count = 0
turnover=[]
date=[]
for i in range(len(df)-1):
    ...:     row1,row2 = df.iloc[i],df.iloc[i+1]
    ...:     if (row2['Turnover (Rs. Cr)']- row1['Turnover (Rs. Cr)']) < 0 :
    ...:         count += 1
    ...:         if count % 5 == 0:
    ...:             date.append(row2['Date'])
    ...:             turnover.append(row2['Turnover (Rs. Cr)'])
    ...:             cnt_neg += 1
    ...:     else:
    ...:         continue
    ...:     
print('Negative:',cnt_neg)
dt = pd.DataFrame(date,columns=['Date'])
trnover = pd.DataFrame(turnover,columns=['Turnover'])
comb = pd.concat([dt,trnover],axis=1)
comb.head(5)
