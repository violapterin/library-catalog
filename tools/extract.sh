#! /usr/bin/env bash

main()
{
   START="$1"
   END="$2"
   PATH_IN="$3"
   PATH_OUT="$4"
   ghostscript="gs -dQUIET"
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   echo "= = = extracting ${PATH_IN} from page ${START} to page ${END} ..."
   set -x
   ${ghostscript} \
      -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -dFirstPage="${START}" \
      -dLastPage="${END}" \
      -sOutputFile="${PATH_OUT}" \
      "${PATH_IN}"
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   START="$1"
   END="$2"
   PATH_IN="$3"
   PATH_OUT="$4"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
      exit 1
   fi
   if [ -z "${START}" ]; then
      echo "Please provide the starting page (included)."
      exit 1
   fi
   if [ -z "${END}" ]; then
      echo "Please provide the ending page (included)."
      exit 1
   fi
   if [ "${START}" -gt "${END}" ]; then
      echo "The start is greater than the end."
      exit 1
   fi
   if [ -z "${PATH_IN}" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "${PATH_OUT}" ]; then
      echo "Please provide the output filename."
      exit 1
   fi
   if [ ! -f "${PATH_IN}" ]; then
      echo "Input file ${PATH_IN} not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
