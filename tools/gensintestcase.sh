#!/bin/bash

thetas=()
precs=()
results=()

INPUTFILE=$1

function conv_prec {
	while read prec
	do
		echo "4'h$(echo "obase=16; $prec" | bc)"
	done
}

cut -d " " -f 1 $INPUTFILE | ./float2hex | ./verinit.py theta
cut -d " " -f 2 $INPUTFILE | conv_prec | ./verinit.py prec

while read theta prec
do
	./sinsim $theta $prec
done < $1 | ./verinit.py expected
