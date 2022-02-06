#! /usr/bin/env bash

RESOLUTION=300

main()
{
   PATH_IN="$1" # image or PDF
   PATH_OUT="$2"
   COLOR="$4"
   name="${PATH_IN##*/}"
   bare="${name%.*}"
   extension="${name##*.}"
   convert="convert"
   if [ "${COLOR}" = "0" ]; then
      convert="convert -monochrome"
   fi
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   if [ "${extension}" != "pdf" ]; then
      if [ "${extension}" != "jpg" ] && [ "${extension}" != "png" ]; then
         continue
      fi
   fi
   echo "converting image ${PATH_IN} as ${PATH_OUT} ..."
   set -x
   ${convert} \
      -density "${RESOLUTION}" \
      "${PATH_IN}" \
      "${PATH_OUT}"
   { set +x; } 2>/dev/null
}

check()
{
   PATH_IN="$1"
   PATH_OUT="$2"
   if [ ! command -v convert &> /dev/null ]; then
      echo "Please install Imagemagick."
      exit 1
   fi
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
      exit 1
   fi
   if [ -z "${PATH_IN}" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "${PATH_OUT}" ]; then
      echo "Please provide the output file."
      exit 1
   fi
   if [ ! -f "${PATH_IN}" ]; then
      echo "First input file ${PATH_IN} is not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
