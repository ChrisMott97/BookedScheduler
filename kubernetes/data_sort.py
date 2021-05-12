import pandas as pd
import seaborn as sb
import matplotlib.pyplot as plt

def graph(filenames):
  dfs = []
  for i in filenames:
    df = pd.read_csv(i)
    df = df[df.metric_name == 'http_req_duration']
    df2 = df.filter(['timestamp', 'metric_value'])
    smallest = df2.iloc[0]['timestamp']
    df2['timestamp'] = df2['timestamp'] - smallest
    #df2.to_csv("python_out.csv", index=False)
    df3 = df2.groupby(df2.timestamp, as_index=False).mean()
    df3['type']=i
    dfs.append(df3) 
  df_final = dfs[0]
  for i in range(len(dfs)):
    if i == 0:
      continue
    df_final = df_final.append(dfs[i], ignore_index=True)
  
  
  fig, scatter = plt.subplots(figsize = (15,10))
  scatter=sb.scatterplot(x='timestamp', y='metric_value', hue='type', marker='+', data=df_final)
  scatter.set(xlabel='Time since test start (s)', ylabel='Total request time (ms)')

one = graph(["data_2gb.csv","data_2gb_2c.csv", "data_2gb_3c.csv", "data_2gb_4c.csv"])
plt.savefig('test.png')
