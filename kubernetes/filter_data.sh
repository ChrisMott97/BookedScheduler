#!/bin/bash

grep "http_req_duration" $1 > duration_$1
grep "/Web/,HTTP" duration_$1 > web_duration_$1
#grep "index.php,HTTP" duration.csv > index_duration.csv
#grep "dashboard.php,HTTP" duration.csv > dashboard_duration.csv
