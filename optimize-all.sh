#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! -f ./prune-all.sh ]; then
   echo "Script prune.sh is not found."
   exit 1
fi
if [ ! command -v pdfsizeopt &> /dev/null ]; then
   echo "Please install pdfsizeopt."
   exit 1
fi
if [ -z "$1" ]; then
   echo "Please provide the paper size."
   exit 1
fi
if [ -z "$2" ]; then
   echo "Please provide the input directory."
   exit 1
fi
if [ -z "$3" ]; then
   echo "Please provide the temporary directory."
   exit 1
fi
if [ -z "$4" ]; then
   echo "Please provide the output directory."
   exit 1
fi
if [ ! -d "$2" ]; then
   echo "Input directory $2 is not found."
   exit 1
fi
if [ ! -d "$3" ]; then
   echo "Temporary directory $3 is not found."
   exit 1
fi
if [ ! -d "$4" ]; then
   echo "Output directory $4 is not found."
   exit 1
fi

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
./prune-all.sh "${loud_pruning}" "${PAPER}" "${FOLDER_IN}" "${FOLDER_MID}" "${LOUD}"

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

   if [ "${extension}" != "pdf" ]; then
      continue
   fi
   echo "optimizing document" "${path_in}" "with Pdfsizeopt..."
   loud_optimizing=
   if [ "$5" -eq 0 ]; then
      loud_optimizing="--quiet"
   fi
   #((index=index%PARALLEL))
   #((index++==0)) && wait
   rm -f "${path_out}"
   set -x
   pdfsizeopt "${flag_loud}" "${path_in}" "${path_out}"
   { set +x; } 2>/dev/null
done
