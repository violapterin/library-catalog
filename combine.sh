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
if [ ! -f "$1" ]; then
   echo "First input file $1 is not found."
   exit 1
fi
if [ ! -f "$2" ]; then
   echo "Second input file $2 is not found."
   exit 1
fi

RESOLUTION=300
PAPER="$1"
FOLDER_IN="$2"
FOLDER_MID="$3"
FOLDER_OUT="$4"

name="${path_in##*/}"
bare="${name%.*}"
extension="${name##*.}"
path_mid="${FOLDER_MID}/${bare}.pdf"
path_out="${FOLDER_OUT}/${bare}.pdf"

if [ "${extension}" != pdf ]; then
   continue
fi
echo "combining document" "${path_in}" "and" "${path_in}" "..."
rm -f "${path_out}"
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
   -sOutputFile="${path_out}" \
   "${path_in}" "${path_mid}"
