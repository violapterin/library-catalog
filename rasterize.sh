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
IN="$2" # image or PDF
OUT="$3"
name="${IN##*/}"
bare="${name%.*}"
mid_one="${bare}-x.pdf"
mid_two="${bare}-y.pdf"
color=
if [ "$4" = "0" ]; then
   color="-monochrome"
fi

echo "resizing document ${IN} as ${mid_one} ..."
rm -f "${mid_one}"
set -x
gs \
   -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.7 \
   -dSAFER \
   -dBATCH \
   -dNOPAUSE \
   -dQUIET \
   -dFIXEDMEDIA \
   -dPDFFitPage \
   -sPAPERSIZE=${PAPER} \
   -sOutputFile="${mid_one}" \
   "${IN}"
{ set +x; } 2>/dev/null

echo "rasterizing document ${mid_one} as ${mid_two} ..."
rm -f "${mid_two}"
convert_option="convert"
if [ "$4" = "0" ]; then
   convert_option="convert -monochrome"
fi

set -x
${convert_option} \
   -density "${RESOLUTION}" \
   -page "${PAPER}" \
   "${mid_one}" \
   "${mid_two}"
{ set +x; } 2>/dev/null
rm -f "${mid_one}"

echo "resizing document" "${mid_two}" "..."
rm -f "${OUT}"
set -x
gs \
   -sDEVICE=pdfwrite \
   -dCompatibilityLevel=1.7 \
   -dSAFER \
   -dBATCH \
   -dNOPAUSE \
   -dQUIET \
   -dFIXEDMEDIA \
   -dPDFFitPage \
   -sPAPERSIZE=${PAPER} \
   -sOutputFile="${OUT}" \
   "${mid_two}"
{ set +x; } 2>/dev/null
rm -f "${mid_two}"

