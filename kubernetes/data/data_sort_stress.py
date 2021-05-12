import pandas as pd
import seaborn as sb
import matplotlib.pyplot as plt

def graph(filenames):
  dfs = []
  for i in filenames:
    df = pd.read_csv(i)
    df_reqs = df[df.metric_name == 'http_req_duration']
    df_checks = df[df.metric_name == 'checks'].filter(['metric_value']).reset_index()
    df2 = df_reqs.filter(['timestamp', 'metric_value']).reset_index()
    smallest = df2.iloc[0]['timestamp']
    df2['timestamp'] = df2['timestamp'] - smallest
    df2['checks'] = df_checks['metric_value']
    #df2 = df2.groupby([df2.timestamp,df2.checks],dropna=False, as_index=False).mean()
    df2['type']=i
    dfs.append(df2)
  df_final = dfs[0]
  for i in range(len(dfs)):
    if i == 0:
      continue
    df_final = df_final.append(dfs[i], ignore_index=True)
    #print(df2.shape)
    #print(df2.query('checks<1').shape)
  #df2.to_csv("python_out.csv", index=False)
  df_final = df_final.query('metric_value<15000')
  #print(df2.head())
  #df_final = df_final.groupby([df_final.timestamp,df_final.checks],dropna=False, as_index=False).mean()
  #print(df_final.head())
  fig, scatter = plt.subplots(figsize = (10,7))
  scatter=sb.scatterplot(x='timestamp', y='metric_value', hue='type', style='checks', linewidth=0,s=2,markers=['o','.'], data=df_final)
  scatter.set(xlabel='Time since test start (s)', ylabel='Total request time (ms)')
  #scatter = sb.scatterplot(x='timestamp', y='metric_value', hue='checks', marker='+', data=df2)
  #sb.regplot(x='timestamp', y='metric_value', order=12, scatter=False, marker='+', data=df2)
    #print(df3.head())

one = graph(["data_4gb_2c_stressv3.csv","data_4gb_4c_2n_stressv3.csv","data_4gb_4c_stressv3.csv"])
#two = graph(["data_1gb_stressv2.csv"])
plt.savefig('test.png')
