#!/bin/bash

input="$1"
echo $input

cd java
java Moredeli ../$input>../out.java.txt
if [ $? != 0 ];
then
	echo "java ERROR">>log
	exit

fi
cd ..
echo "java:"
cat out.java.txt
sml/moredeli $input>out.sml.txt
if [ $? != 0 ];
then
	echo "sml ERROR">>log
	exit
fi

echo "sml:"
cat out.sml.txt
exit

echo "Result:"
cat inputs
if diff "out.java.txt" "out.sml.txt" > /dev/null ;
then
	cat out.sml.txt
else
	echo "files are different ERROR">>log
	exit
fi
