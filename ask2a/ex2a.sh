#!/bin/bash

input="$1"
echo $input

cd java
java Villages ../$input>../out.java.txt
if [ $? != 0 ];
then
	echo "java ERROR">>log
	exit

fi
cd ..

cat out.java.txt
sml/villages $input>out.sml.txt
if [ $? != 0 ];
then
	echo "sml ERROR">>log
	exit
fi

if diff "out.java.txt" "out.sml.txt" > /dev/null ;
then
	cat out.sml.txt
else
	echo "files are different ERROR">>log
	exit
fi
