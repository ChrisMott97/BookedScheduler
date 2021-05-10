#set datafile separator ','
set terminal png size 2000,1000
set output 'new.png'
#set xdata time
#set timefmt "%s"
plot 'simple_web_duration_data_2gb.csv' using 1:2, 'simple_web_duration_data_2gb_2c.csv' using 1:2
#plot 'web_duration.csv' using 2:3 , 'index_duration.csv' using 2:3 , 'dashboard_duration.csv' using 2:3
