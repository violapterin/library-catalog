#! /usr/bin/env bash

if [ ! command -v gs &> /dev/null ]; then
   echo "Please install ghostscript."
   exit
fi
if [ ! -f prune.sh ]; then
   echo "Script prune.sh is not found."
   exit
fi
cd "$(dirname $0)"

RESOLUTION=300
PAPER="$1"
FOLDER_IN="$2"
FOLDER_OUT="$3"
#PARALLEL=4
#index=1

for path_in in "${FOLDER_IN}"/*; do
   if [ ! -f "${path_in}" ]; then
      continue
   fi
   name="${path_in##*/}"
   bare="${name%.*}"
   extension="${name##*.}"
   path_out="${FOLDER_OUT}/${bare}.pdf"

   if [ "${extension}" = pdf ]; then
      echo "pruning document" "${path_in}" "with Ghostscript..."
      #((index=index%PARALLEL))
      #((index++==0)) && wait
      rm -f "${path_out}"
      echo ./prune.sh "${PAPER}" "${path_in}" "${path_out}"
   fi
done
