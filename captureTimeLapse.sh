#!/bin/bash
# [ 03-June-2012 ]: Captures images for Sun Time Lapse
# [ 19-March-2015 ]: Capturing solar eclipse in Saarbruecken Germany with a Canon EOS 5D Mark II
# [ 19-August-2017 ]: Capturing total (!) solar eclipse near Salem, OR, USA with a Canon Rebel T3
if [ $# -lt 1 ] || [ $# -gt 2 ];
then
    echo "Usage: $0 <OutputDirectory> [<Interval (seconds) = 15s>]";
    exit;
fi

OutputDir=$1
TimeInterval=15
if [ $# -eq 2 ]; then
    TimeInterval=$2
fi

# Imageformat works only with Canon EOS 5D Mark II. Please change for other cameras
gphoto2 --set-config flashmode=0 --set-config /main/imgsettings/imageformat=0 --interval ${TimeInterval} --capture-image-and-download --force-overwrite --filename "${OutputDir}/%Y%m%d%H%M%S.jpg"

# If one knows how many frames to capture
#gphoto2 --set-config flashmode=0 --set-config /main/imgsettings/imageformat=0 --interval ${TimeInterval} --frames 10 --capture-image-and-download --force-overwrite --filename "${OutputDir}/%Y-%m-%d_%Hh%Mm%Ss.jpg"