#! /usr/bin/env bash

main()
{
   PATH_IN="$1"
   PATH_OUT="$2"
   ghostscript="gs -dQUIET"
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   echo "= = = extract odd pages of ${PATH_IN} ..."
   set -x
   ${ghostscript} \
      -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -sPageList=odd \
      -sOutputFile="${PATH_OUT}" \
      "${PATH_IN}"
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   PATH_IN="$1"
   PATH_OUT="$2"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
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
