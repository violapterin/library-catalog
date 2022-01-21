#! /usr/bin/env bash

if [ ! command -v gs &> /dev/null ]; then
   echo "Please install ghostscript."; exit
fi
if [ -z "$1" ]; then
   echo "Please provide the size of paper."; exit
fi
if [ -z "$2" ]; then
   echo "Please provide the input filename."; exit
fi
if [ -z "$3" ]; then
   echo "Please provide the output filename."; exit
fi
if [ ! -f "$2" ]; then
   echo "File $2 not found."; exit
fi
cd "$(dirname $0)"

RESOLUTION=300
PAPER="$1"
IN="$2"
OUT="$3"

set -x
gs \
   -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.7 \
   -dSAFER \
   -dBATCH \
   -dNOPAUSE \
   -dQUIET \
   -sPAPERSIZE=${PAPER} \
   -dFIXEDMEDIA \
   -dPDFFitPage \
   -dAutoRotatePages=/All \
   -dDetectDuplicateImages=true \
   -dColorImageResolution=${RESOLUTION} \
   -dGrayImageResolution=${RESOLUTION} \
   -dMonoImageResolution=${RESOLUTION} \
   -dColorImageDownsampleThreshold=1.0 \
   -dGrayImageDownsampleThreshold=1.0 \
   -dMonoImageDownsampleThreshold=1.0 \
   -dDownsampleColorImages=true \
   -dDownsampleGrayImages=true \
   -dDownsampleMonoImages=true \
   -dColorImageDownsampleType=/Average \
   -dGrayImageDownsampleType=/Average \
   -dMonoImageDownsampleType=/Subsample \
   -dColorImageFilter=/DCTEncode \
   -dGrayImageFilter=/DCTEncode \
   -dMonoImageFilter=/CCITTFaxEncode \
   -dOptimize=true \
   -dCompressPages=true \
   -sOutputFile="${OUT}" \
   "${IN}"
{ set +x; } 2>/dev/null

# # for converting to black and white:
# -sColorConversionStrategy=Gray \
# -sProcessColorModel=DeviceGray \

# # for padding, from left to right, from below to above:
# -c "<</PageOffset [12 16]>> setpagedevice" -f \