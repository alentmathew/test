#!/bin/bash


cat -n file.txt  | awk '{print $1,   $6}' | grep -v "d" | awk '{print $1}' > num

value=$(wc -l num | awk '{print $1}')

#echo $value


for (( i=1; i<=$value; i++ ))
do

x="$(head -n $i num | tail -1)"
#echo $x
echo "$(head -n $x file.txt | tail -1)"

done

