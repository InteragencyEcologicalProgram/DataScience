#daysince_3_clean.py
#2021-02-03
#Derek Acomb
#convert daily precipitation totals to days since threshold precipitation

#get your data here:
#https://www.ncdc.noaa.gov/cdo-web/datatools/findstation
#daily totals
#precipitation
#custom csv
#station name
#geographic location
#precipitation

#needed libraries
import datetime
import pandas as pd
import numpy as np

#variables for importing csv to dataframe
file = '2021-02-10_KSTS.csv'
fields = ['DATE', 'PRCP', 'PRCP_ATTRIBUTES']

#only impport the columns we want to df, the dataframe
df = pd.read_csv(file, usecols=fields)

#convert the date field to date time object
datetime_series = pd.to_datetime(df['DATE'])

# create datetime index using the 'DATE' field
datetime_index = pd.DatetimeIndex(datetime_series.values)

#set the index to the datetime object
df = df.set_index(datetime_index)

#Drop the DATE columnsince we don't need it anymore
df.drop('DATE',axis=1,inplace=True)


#clean the data
#find cells where prcp = 0 AND the first character of prcp_attributes = 'T' then replace PRCP 0.00 with 0.001

#create field TRACE and set all cells to 0, this is needed so we later compare two values of same data type
df['TRACE'] = 0 

#where the first character of attributes is T write 1 to TRACE
df.loc[df['PRCP_ATTRIBUTES'].astype(str).str[0] =='T',['TRACE']] = 1

#ASSUMPTION ALERT
#where prcp is 0 and attributes first is T, write 0.001 to PRCP #### do this and this not do this if this and that are true
df.loc[(df['PRCP'] == 0) & (df['TRACE'] == 1),['PRCP']] = 0.001

#remove the prcp_attributes and trace fields as thet are no longer needed
del df['PRCP_ATTRIBUTES'] #drop function can do this in one line, del is also appropriate
del df['TRACE']
#you might be able to use the .where function to avoid making and deleting the 'TRACE' field


#create list of precip total values to test for
#infinity is cool, but takes up too much space
#~ ptot = [0.001, 0.01, 0.1, 1, 10, 100, 1000,10000] #inch decade
#~ ptotm = [0.01, 0.1, 1, 10, 100, 1000, 10000, 100000, 1000000] #millimeter decade
ptot = [0.001, 0.01, 0.1, 1, 2.5, 5, 7.5, 10, 25, 35, 50, 75, 100, 1000, 10000] #inch custom

#create the dataframe columns for each ptot value from list and fill them with nan
for x in ptot:
	df['days_' + str(x)] = np.nan


#setting up a loop
#set rows to the number of rows in the dataframe
rows = len(df.index)

#set up big loop here to contain the whole thing
for i in range(rows-1,-1,-1):   #-1 step go in reverse
	startdate = df.iloc[[i]].index  #sets index of the maximum date for the big loop.

	#Create new field 'CUMSUM_DATE' and fill it with cumsum() for index i and make it go backwards -1 from the end to start of teh 'PRCP' column
	df['CUMSUM_DATE'] = df['PRCP'][i::-1].cumsum()

#another loop to step across the columns
	for x in ptot:
		#test if column maximum greater than ptot 
		colmax = df.CUMSUM_DATE.gt(x).max()
		
		#run up teh column backwards, test to see if the cumsum value is greater than or equal to the threshold value from the ptot list
		#idxmax() If multiple values equal the maximum, the first row index with that value is returned
		ptot_index = df.CUMSUM_DATE[i::-1].ge(x).idxmax() 
		
		#take the difference of the days
		diff_days = ((startdate) - (ptot_index)).days


	#Write diff_days to cells where idxmax is greater than or equal to ptot
	#Write NaN to cells where idxmax is less than ptot
	#idxmax defaults to the first value instead of returning error or NaN if it never finds the maximum.
		if colmax == True:
			df.at[startdate,'days_' + str(x)] =  diff_days  # write the days since for each ptot value to the correct column for the day under test
		elif colmax == False:
			df.at[startdate,'days_' + str(x)] =  np.nan  # write NaN for each ptot value where colmax is FALSE

#text output to let me know the program did something
print('exit main loop')

#Final dataframe cleanup
del df['CUMSUM_DATE'] # delete the 'CUMSUM_DATE'column because we don't need it anymore

#export dataframe to csv file in same directory
df.to_csv('daysince_OUT.csv')







