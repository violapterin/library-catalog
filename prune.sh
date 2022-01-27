#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! command -v gs &> /dev/null ]; then
   echo "Please install ghostscript."
   exit
fi
if [ -z "$1" ]; then
   echo "Please provide the paper size."
   exit
fi
if [ -z "$2" ]; then
   echo "Please provide the input file."
   exit
fi
if [ -z "$2" ]; then
   echo "Please provide the output filename."
   exit
fi
if [ ! -f "$2" ]; then
   echo "Input file $2 not found."; exit
fi

RESOLUTION=300
PAPER="$1"
IN="$2"
OUT="$3"
loud_pruning=
if [ "$5" -eq 0 ]; then
   loud_pruning="-dQUIET"
fi

set -x
gs \
   -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.7 \
   -dSAFER \
   -dBATCH \
   -dNOPAUSE \
   -dFIXEDMEDIA \
   -dPDFFitPage \
   -dAutoRotatePages=/All \
   -dDetectDuplicateImages=true \
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
   "${loud_pruning}" \
   -sPAPERSIZE="${PAPER}" \
   -dColorImageResolution="${RESOLUTION}" \
   -dGrayImageResolution="${RESOLUTION}" \
   -dMonoImageResolution="${RESOLUTION}" \
   -sOutputFile="${OUT}" \
   "${IN}"
{ set +x; } 2>/dev/null

# # for converting to black and white:
# -sColorConversionStrategy=Gray \
# -sProcessColorModel=DeviceGray \

# # for padding, from left to right, from below to above:
# -c "<</PageOffset [12 16]>> setpagedevice" -f \