#! /usr/bin/env bash

if [ ! command -v gs &> /dev/null ]; then
   echo "Please install ghostscript."
   exit
fi
if [ -z "$1" ]; then
   echo "Please provide the input directory."
   exit
fi
if [ -z "$2" ]; then
   echo "Please provide the output directory."
   exit
fi
cd "$(dirname $0)"

RESOLUTION=150
FOLDER_IN="$1"
FOLDER_OUT="$2"

for path_in in "${FOLDER_IN}"/*; do
   if [ ! -f "${path_in}" ]; then
      continue
   fi
   name="${path_in##*/}"
   bare="${name%.*}"
   extension="${name##*.}"

   if [ "${extension}" != pdf ]; then
      continue
   fi
   mkdir "${FOLDER_OUT}/${bare}-hold"
   echo "combining document" "${path_in}" "and" "${path_in}" "..."
   gs \
      -sDEVICE=jpeggray \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -dQUIET \
      -r"${RESOLUTION}" \
      -sOutputFile="${FOLDER_OUT}/${bare}-hold/page-%03d.jpg" \
      "${path_in}"
done
