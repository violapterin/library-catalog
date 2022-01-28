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

RESOLUTION=300
PAPER="$1"
size_in="$(($#-2))" # length minus one
MANY_IN="${@:2:$size_in}"
OUT="${@: -1}" # keep the space

echo "combining document" "${MANY_IN}" "and" "${OUT}" "..."
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
   ${MANY_IN}
{ set +x; } 2>/dev/null
