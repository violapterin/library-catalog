#! /usr/bin/env bash

HERE="$(dirname $0)"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

main_folder()
{
   PAPER="$1"
   FOLDER_IN="$2"
   FOLDER_OUT="$3"
   if [ ! -d "${OUT}" ]; then
      echo "Output file or directory ${OUT} is not found."
      exit 1
   fi
   for path_in in "${FOLDER_IN}"/*; do
      if [ ! -f "${path_in}" ]; then
         continue
      fi
      name="${path_in##*/}"
      bare="${name%.*}"
      extension="${name##*.}"
      path_out="${FOLDER_OUT}/${bare}.pdf"
      if [ "${extension}" != pdf ]; then
         continue
      fi

      date +%H:%M
      echo "= = = pruning document ${path_in} with Ghostscript..."
      main_file "${PAPER}" "${path_in}" "${path_out}"
   done
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

main_file()
{
   PAPER="$1"
   PATH_IN="$2"
   PATH_OUT="$3"
   ghostscript="gs -dQUIET"
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   set -x
   ${ghostscript} \
      -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -dFIXEDMEDIA \
      -dPDFFitPage \
      -sPAPERSIZE="${PAPER}" \
      -sOutputFile="${PATH_OUT}" \
      "${PATH_IN}"
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   PAPER="$1"
   IN="$2"
   OUT="$3"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
      exit 1
   fi
   if [ -z "${PAPER}" ]; then
      echo "Please provide the paper size."
      exit 1
   fi
   if [ -z "${IN}" ]; then
      echo "Please provide the input file or directory."
      exit 1
   fi
   if [ -z "${OUT}" ]; then
      echo "Please provide the output file or directory."
      exit 1
   fi
   if [ ! -d "${IN}" ] && [ ! -f "${IN}" ]; then
      echo "Input file or directory ${IN} is not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

PAPER="$1"
IN="$2"
OUT="$3"
check "$@"
if [ -f "${IN}" ]; then
   main_file "$@"
   exit 0
fi
if [ -d "${IN}" ]; then
   main_folder "$@"
   exit 0
fi