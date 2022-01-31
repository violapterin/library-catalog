#! /usr/bin/env bash

check()
{
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ -z "$1" ]; then
      echo "Please provide the starting page (included)."
      exit 1
   fi
   if [ -z "$2" ]; then
      echo "Please provide the starting page (included)."
      exit 1
   fi
   if [ -z "$3" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "$4" ]; then
      echo "Please provide the output filename."
      exit 1
   fi
   if [ ! -f "$3" ]; then
      echo "Input file $3 not found."
      exit 1
   fi
}

main()
{
   HERE="$(dirname $0)"
   RESOLUTION=300
   START="$1"
   STOP="$2"
   IN="$3"
   OUT="$4"

   echo "= = = extracting page ${START} from page ${STOP} of document ${IN} ..."
   set -x
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dFirstPage="${START}" \
      -dLastPage="${STOP}" \
      -sOutputFile="${OUT}.pdf" \
      "${IN}"
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
