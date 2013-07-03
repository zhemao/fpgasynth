#!/bin/bash

thetas=()
precs=()
results=()

INPUTFILE=$1

cut -d " " -f 1 $INPUTFILE | ./float2int | ./verinit.py theta
cut -d " " -f 2 $INPUTFILE | ./float2int | ./verinit.py prec

while read theta prec
do
	./sinsim $theta $prec
done < $1 | ./float2int | ./verinit.py expected
