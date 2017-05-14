#!/bin/bash


while true
do
./rnd.py

c/skitrip input.txt>out.c.txt
if [ $? != 0 ];
then
	echo "c ERROR">>log
	cp input.txt wrong.txt
	exit

fi

cat out.c.txt
sml/skitrip input.txt>out.sml.txt
if [ $? != 0 ];
then
	echo "sml ERROR">>log
	cp test.txt wrong.txt
	exit
fi

if diff "out.c.txt" "out.sml.txt" > /dev/null ;
then
	cat out.c.txt
else
	echo "files are different ERROR">>log
	cp test.txt wrong.txt
	exit
fi
done
