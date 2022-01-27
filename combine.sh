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
   echo "Please provide the first input file."
   exit 1
fi
if [ -z "$3" ]; then
   echo "Please provide the second input file."
   exit 1
fi
if [ -z "$4" ]; then
   echo "Please provide the output filename."
   exit 1
fi
if [ ! -f "$2" ]; then
   echo "First input file $2 is not found."
   exit 1
fi
if [ ! -f "$3" ]; then
   echo "Second input file $3 is not found."
   exit 1
fi

RESOLUTION=300
PAPER="$1"
IN="$2"
MID="$3"
OUT="$4"

echo "combining document" "${MID}" "and" "${OUT}" "..."
rm -f "${path_out}"
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
   "${IN}" "${MID}"
{ set +x; } 2>/dev/null
