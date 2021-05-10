import pandas as pd
import seaborn as sb
import matplotlib.pyplot as plt

def graph(filename):
  df = pd.read_csv(filename)
  df = df[df.metric_name == 'http_req_duration']
  df2 = df.filter(['timestamp', 'metric_value'])
  smallest = df2.iloc[0]['timestamp']
  df2['timestamp'] = df2['timestamp'] - smallest
  df3 = df2.groupby(df2.timestamp, as_index=False).mean()    
  sb.scatterplot(x='timestamp', y='metric_value', marker='+', data=df3)
  sb.regplot(x='timestamp', y='metric_value', order=8, scatter=False, marker='+', data=df3)
    #print(df3.head())

one = graph("data_4gb_2c.csv")
two = graph("data_2gb_2c.csv")
plt.savefig('test.png')
