#!/bin/bash

kubectl get pods | awk '{if(NR>1)print}'  > file.txt

cat -n file.txt  | awk '{print $1,   $6}' | grep -v "d" | awk '{print $1}' > num.txt

value=$(wc -l num.txt | awk '{print $1}')


for (( i=1; i<=$value; i++ ))
do

x="$(head -n $i num.txt | tail -1)"
#echo $x
echo "$(head -n $x file.txt | tail -1)"

done

rm -rf file.txt num.txt
