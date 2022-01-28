#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! command -v convert &> /dev/null ]; then
   echo "Please install ghostscript."
   exit 1
fi
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
if [ -z "$3" ]; then
   echo "Please provide the output filename."
   exit 1
fi
if [ ! -f "$2" ]; then
   echo "First input file $2 is not found."
   exit 1
fi

RESOLUTION=300
PAPER="$1"
IN="$2"
OUT="$3"
name="${IN##*/}"
bare="${name%.*}"
mid="${bare}-hold.pdf"

echo "rasterizing document" "${IN}" "..."
rm -f "${path_out}"
set -x
convert \
   -density "${RESOLUTION}" \
   "${IN}" \
   "${mid}"
{ set +x; } 2>/dev/null

echo "resizing document" "${IN}" "..."
rm -f "${OUT}"
set -x
gs \
   -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.7 \
   -dSAFER \
   -dBATCH \
   -dNOPAUSE \
   -dFIXEDMEDIA \
   -dPDFFitPage \
   -dQUIET \
   -sPAPERSIZE=${PAPER} \
   -sOutputFile="${OUT}" \
   "${mid}"
{ set +x; } 2>/dev/null
rm -f "${mid}"

