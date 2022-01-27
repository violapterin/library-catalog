#! /usr/bin/env bash

if [ ! command -v gs &> /dev/null ]; then
   echo "Please install ghostscript."
   exit
fi
if [ -z "$1" ]; then
   echo "Please provide the paper size."
   exit
fi
if [ -z "$2" ]; then
   echo "Please provide the input directory."
   exit
fi
if [ -z "$3" ]; then
   echo "Please provide the temporary directory."
   exit
fi
if [ -z "$4" ]; then
   echo "Please provide the output directory."
   exit
fi
cd "$(dirname $0)"

RESOLUTION=300
PAPER="$1"
FOLDER_IN="$2"
FOLDER_MID="$3"
FOLDER_OUT="$4"

for path_in in "${FOLDER_IN}"/*; do
   if [ ! -f "${path_in}" ]; then
      continue
   fi
   name="${path_in##*/}"
   bare="${name%.*}"
   extension="${name##*.}"
   path_out="${FOLDER_OUT}/${bare}.pdf"

   if [ "${extension}" = pdf ]; then
      echo "combining document" "${path_in}" "..."
      rm -f "${path_out}"
      gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 -sPAPERSIZE=a5 -dPDFFitPage -dFIXEDMEDIA -dNOPAUSE -dBATCH -dQUIET -sOutputFile=aeneid.pdf aeneid-1-g.pdf  aeneid-2-g.pdf
      ./prune.sh "${PAPER}" "${path_in}" "${path_out}"
   fi
done
