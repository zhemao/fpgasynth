#!/bin/bash

thetas=()
precs=()
results=()

INPUTFILE=$1

function conv_prec {
	while read prec
	do
		printf "4'h%x\n" $prec
	done
}

cut -d " " -f 1 $INPUTFILE | ./float2hex | ./verinit.py theta
cut -d " " -f 2 $INPUTFILE | conv_prec | ./verinit.py prec

while read theta prec
do
	./sinsim $theta $prec
done < $1 | ./verinit.py expected
