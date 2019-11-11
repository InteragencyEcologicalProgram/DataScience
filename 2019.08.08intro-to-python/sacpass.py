# -*- coding: utf-8 -*-
"""
Created on Thu Aug  8 13:14:35 2019
sacpass.py
@author: jsaracen
"""

import numpy as np
import pandas as pd

def query_redbluff_data(start_year, end_year):
    year_data = []
    for year in np.arange(start_year, end_year+1):
        url = f'http://www.cbr.washington.edu/sacramento/data/php/rpt/redbluff_daily.php?outputFormat=csv&year={year}&biweekly=other&wtemp=default'
        year_data.append(pd.read_csv(url, na_values=['NA'], skipfooter=7, engine='python'))
    dataframe = pd.concat(year_data)
    dataframe.index=pd.to_datetime(dataframe['Date'])
    return dataframe


redbluff = query_redbluff_data(2004, 2019)
redbluff['Water Temperature (C)'].plot()
redbluff.plot(x='Water Temperature (C)', y='Bend Bridge Peak Flow (CFS)',kind='scatter')

redbluff.to_csv('redbluff_sacpass_pull_2004_2019.csv', index=False)
