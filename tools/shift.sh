#! /usr/bin/env bash

main()
{
   LEFT="$1"
   BOTTOM="$2"
   PATH_IN="$3"
   PATH_OUT="$4"
   ghostscript="gs -dQUIET"
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   echo "= = = shifting ${PATH_IN}, ${LEFT} from left and ${BOTTOM} from bottom ..."
   set -x
   ${ghostscript} \
      -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -sOutputFile="${PATH_OUT}" \
      -c "<</PageOffset [${LEFT} ${BOTTOM}]>> setpagedevice" -f \
      "${PATH_IN}"
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   LEFT="$1"
   BOTTOM="$2"
   PATH_IN="$3"
   PATH_OUT="$4"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
      exit 1
   fi
   if [ -z "${LEFT}" ]; then
      echo "Please provide the left offset."
      exit 1
   fi
   if [ -z "${BOTTOM}" ]; then
      echo "Please provide the bottom offset."
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
