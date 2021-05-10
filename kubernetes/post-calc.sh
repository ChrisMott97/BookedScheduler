#!/bin/bash


calc=$(head -1 $1 | awk -F, '{print $2}')
awk -F, -v awkvar="$calc" '{print $2-awkvar , $3}' $1 > simple_$1


