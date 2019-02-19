#!/bin/bash

#kubectl get ns |  awk '{if(NR>1)print}' | awk '{print $1}' > file2.txt

grep -F -x -v -f  file2.txt  required-ns.txt  > diff.txt

if [ -s diff.txt ]
then

echo
echo "The following namespaces are deleted:"
echo "============================="
cat diff.txt
echo "============================="
echo

else
echo "no change in ns"
fi

rm -rf diff.txt file2.txt

