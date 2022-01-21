#! /usr/bin/env bash

if [ ! command -v gs &> /dev/null ]; then
   echo "Please install ghostscript."
   exit
fi
if [ ! command -v pdfsizeopt &> /dev/null ]; then
   echo "Please install pdfsizeopt."
   exit
fi
if [ ! -f prune-all.sh ]; then
   echo "Script prune.sh is not found."
   exit
fi
if [ -z "$1" ]; then
   echo "Please provide the size of paper."
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
#PARALLEL=4
#index=1

echo "= = = = = = = = = = = = = = = = = = = = = = = ="
echo "= = = = = = = = = = = = = = = = = = = = = = = ="
echo "Pruning PDFs ..."
echo "= = = = = = = = = = = = = = = = = = = = = = = ="
echo "= = = = = = = = = = = = = = = = = = = = = = = ="
./prune-all.sh "${PAPER}" "${FOLDER_IN}" "${FOLDER_MID}"

echo "= = = = = = = = = = = = = = = = = = = = = = = ="
echo "= = = = = = = = = = = = = = = = = = = = = = = ="
echo "Optimizing PDFs ..."
echo "= = = = = = = = = = = = = = = = = = = = = = = ="
echo "= = = = = = = = = = = = = = = = = = = = = = = ="
for path_in in "${FOLDER_MID}"/*; do
   if [ ! -f "${path_in}" ]; then
      continue
   fi
   name="${path_in##*/}"
   bare="${name%.*}"
   extension="${name##*.}"
   path_out="${FOLDER_OUT}/${bare}.pdf"

   if [ "${extension}" = pdf ]; then   if [ ! -f $path_in ]; then
      echo "optimizing document" "${path_in}" "with Pdfsizeopt..."
      #((index=index%PARALLEL))
      #((index++==0)) && wait
      rm -f "${path_out}"
      set -x
      pdfsizeopt --quiet "${path_in}" "${path_out}"
      { set +x; } 2>/dev/null
   fi
done
