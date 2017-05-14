#!/bin/bash


c/spacedeli $1>out.c.txt
if [ $? != 0 ];
then
	echo "c ERROR"
	cp input.txt wrong.txt
	exit

fi

sml/spacedeli $1>out.sml.txt
if [ $? != 0 ];
then
	echo "sml ERROR"
	cp test.txt wrong.txt
	exit
fi

if diff "out.c.txt" "out.sml.txt" > /dev/null ;
then
	:
##	cat out.c.txt
else
	echo "files are different ERROR"
	cp $1 wrong.txt
	exit
fi
