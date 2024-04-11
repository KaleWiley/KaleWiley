import pandas as pd
import numpy as np
import math
import matplotlib.pyplot as plt
from bs4 import BeautifulSoup
from selenium import webdriver
from lxml import html


def parse(URL):
    response = webdriver.Chrome()
    response.get(URL)
    sourceCode = response.page_source
    return sourceCode

soup = BeautifulSoup(parse("https://www.baseball-reference.com/leagues/NL/2023-standard-pitching.shtml"),'lxml')
results = soup.find("table", { 'id' : "players_standard_pitching"})

data = []
for row in results.find_all('tr'):
    row_data = []
    for cell in row.find_all('td'):
        row_data.append(cell.text)
    data.append(row_data)

pitchingStats = pd.DataFrame(data)
pitchingStats = pitchingStats.dropna(axis='index',how='all')

dataLength = len(pitchingStats.index)
row_labels = []
for num in range(0,dataLength):
    row_labels.append(num)
#blankRows = pitchingStats.iloc[np.s_[26::26]]
#pitchingStats = pd.DataFrame(data=data, index=row_labels)
pitchingStats.columns = ["Name","Age","Team","W","L","W-L%","ERA","G","GS","GF","CG","SHO","SV","IP","H","R","ER","HR","BB","IBB","SO","HBP","BK","WP","BF","ERA+","FIP","WHIP","H9","HR9","BB9","SO9","SO/W"]
pitchingStats.index = row_labels

#print(pitchingStats.head(n=15))

def histogram(pitchingStats):
    plt.style.use('fivethirtyeight')
    plt.hist(pitchingStats['ERA'],bins=20,edgecolor='k')
    plt.xlabel('ERA'); plt.ylabel('Number of Pitchers')
    plt.title('Pitcher ERA Distribution')
    plt.show()

"""
def correlation(pitchingStats,dataLength):
    pitchSum = pitchingStats['ERA'].sum()
    gameSum = pitchingStats['G'].sum()
    columnsMultiply = pitchingStats['ERA','G']
    ERAtoG = pitchingStats[columnsMultiply].product(axis=1)
    pitchingStats['ERA*G'] = ERAtoG
    ERAtoGsum = pitchingStats['ERA*G'].sum()
    ERAsquare = pitchingStats['ERA'] * pitchingStats['ERA']
    Gsquare = pitchingStats['G'] * pitchingStats['G']
    numerator = dataLength*ERAtoGsum - (pitchSum*gameSum)
    denominator = sqrt((dataLength*))
"""


histogram(pitchingStats)
print(pitchingStats.head(n=20))

