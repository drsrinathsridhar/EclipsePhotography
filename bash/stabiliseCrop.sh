#!/bin/bash
# This script stabilises the disc of the Sun and crops to a given dimension

SRC="img"
DEST="crop"
WIDTH="400"
HEIGHT="300"
NumWorkers=3 # Modify this to change number of processes
echo "Using $NumWorkers processes."

for j in `ls -1 $SRC/*.jpg | tr '\n' '\0' | xargs -0 -n 1 basename`
do
#	echo $SRC/$j $DEST/$j $WIDTH $HEIGHT &
	./discdetector $SRC/$j $DEST/$j $WIDTH $HEIGHT &
	(( NumWorkers-- ))
	if [ $NumWorkers -eq 0 ]; then
		echo "Waiting for processes in queue to complete..."
		wait
		echo -e "Queue cleared.\n"
		NumWorkers=3
	fi
done
echo "Done stabilising all images in directory $SRC."




