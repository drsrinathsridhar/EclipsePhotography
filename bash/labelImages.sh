#!/bin/bash
# This script adds labels to images from the filename. Works only if filename is
# in the specified format of yyyymmddhhmmss.jpg

TARGET="AllCropped"
NumWorkers=8 # Modify this to change number of processes
echo "Using $NumWorkers processes."

for j in `ls -1 $TARGET/*.jpg | tr '\n' '\0' | xargs -0 -n 1 basename`
do
	text=`identify -format "${j:0:4}:${j:4:2}:${j:6:2} ${j:8:2}:${j:10:2}:${j:12:2} IST  " $TARGET/$j`
	width=`identify -format %w $TARGET/$j`
	mogrify -gravity southeast -pointsize 50 \
		-stroke black -strokewidth 4 -annotate 0 "${text}" \
		-stroke white -strokewidth 1 -fill white -annotate 0 "${text}" \
		$TARGET/$j
	(( NumWorkers-- ))
	if [ $NumWorkers -eq 0 ]; then
		echo "Waiting for processes in queue to complete..."
		wait
		echo -e "Queue cleared.\n"
		NumWorkers=4
	fi
done
echo "Done labelling all images in directory $TARGET."

