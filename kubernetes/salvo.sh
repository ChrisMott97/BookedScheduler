#!/bin/bash
cmd(){
  salvo http://10.49.167.242:32178 -c $1 -n 1 --json-output -q
}

for val in {10..1000..10}
do
  echo $val
  buffer=$(cmd $val)
  #echo -n "$val " >> mins
  echo -n "$val " >> maxs
  #echo $buffer | jq -r '.min' >> mins
  echo $buffer | jq -r '.max' >> maxs
done
