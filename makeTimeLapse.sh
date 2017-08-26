#!/bin/bash
# Makes a time lapse video from discrete (jpg) images
mencoder "mf://*.jpg" -mf fps=5:type=jpg -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vbitrate=7000 -vf scale=640:480 -oac copy -o SunTimeLapse.avi
