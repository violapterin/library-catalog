#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! command -v gs &> /dev/null ]; then
   echo "Please install ghostscript."
   exit 1
fi
if [ -z "$1" ]; then
   echo "Please provide the paper size."
   exit 1
fi
if [ -z "$2" ]; then
   echo "Please provide the input file."
   exit 1
fi
if [ -z "$2" ]; then
   echo "Please provide the output filename."
   exit 1
fi
if [ ! -f "$2" ]; then
   echo "Second input file $2 is not found."
   exit 1
fi

RESOLUTION=300
PAPER="$1"
IN="$2"
OUT="$3"
loud_pruning=
if [ "$4" = "0" ]; then
   loud_pruning="-dQUIET"
fi

main="gs"
if [ "$4" = "0" ]; then
   main="gs -dQUIET"
fi
set -x
${main} \
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