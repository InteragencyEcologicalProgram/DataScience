# -*- coding: utf-8 -*-
"""
Created on Thu Aug  8 13:17:27 2019
fmwt.py
@author: jsaracen
"""

import pandas as pd
import requests
from bs4 import BeautifulSoup


def scrape_fmwt(url, table_number, cols, species):
    ''' Function to scrape data from the cdfw fmwt webpage
    and return data as a pandas dataframe.There are six
     tables for the various fish species'''
    res = requests.get(url)
    soup = BeautifulSoup(res.content,'lxml')
    table = soup.find_all('table')[table_number] 
    dataframe = pd.DataFrame(pd.read_html(str(table))[0])
    dataframe.columns = cols
    dataframe.index = pd.to_datetime(dataframe['Year'].astype(int),format='%Y')
    dataframe['Species'] = species
    return dataframe


fmwt_url = 'http://www.dfg.ca.gov/delta/data/fmwt/indices.asp'
#table column headers
columns = ['Year', 'Sept', 'Oct', 'Nov', 'Dec', 'Total']

#retrieve each species expensively
Age_0_Striped_Bass = scrape_fmwt(fmwt_url, 0, columns, 'Age_0_Striped_Bass')
Delta_Smelt_all_ages = scrape_fmwt(fmwt_url, 1, columns, 'Delta_Smelt')
Longfin_Smelt_all_ages = scrape_fmwt(fmwt_url, 2, columns, 'Longfin_Smelt')
American_Shad_all_ages = scrape_fmwt(fmwt_url, 3, columns,'American_Shad')
Splittail_all_ages = scrape_fmwt(fmwt_url, 4, columns, 'Splittail')
Threadfin_Shad_all_ages = scrape_fmwt(fmwt_url, 5, columns, 'Threadfin_Shad')
#combine species into long form
all_species = pd.concat([Delta_Smelt_all_ages,Age_0_Striped_Bass])

#retrieve each species elegantly???
list_of_species = ['Age_0_Striped_Bass', 'Delta_Smelt', 'Longfin_Smelt',
                   'American_Shad', 'Splittail', 'Threadfin_Shad']
list_of_counts = []

for i, species in enumerate(list_of_species):
    list_of_counts.append(scrape_fmwt(fmwt_url, i, columns, species))

#combine species into long form
all_species = pd.concat(list_of_counts)
#make a time series plot
all_species[all_species['Species']=='American_Shad']['Sept'].plot(marker='o',color='b',legend=False)
all_species[all_species['Species']=='Delta_Smelt']['Sept'].plot(marker='*',color='r',legend=False)

all_species.to_csv('fall_mwt_all_species.csv')
