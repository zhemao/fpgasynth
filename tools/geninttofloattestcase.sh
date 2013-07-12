#!/bin/bash

DATFILE=$1

while read int
do
	hex=$(printf "%.8x" $int | tail -c 4)
	echo "16'h$hex"
done < $DATFILE | python verinit.py test_inputs

./float2hex < $DATFILE | python verinit.py expected
