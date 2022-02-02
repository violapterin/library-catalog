#! /usr/bin/env bash

main()
{
   PAPER="$1"
   size_in="$(($#-2))" # # length minus one
   MANY_IN="${@:2:$size_in}"
   OUT="${@: -1}" # # keep the space
   ghostscript="gs -dQUIET"

   echo "combining document ${MANY_IN} and ${OUT} ..."
   rm -f "${OUT}"
   set -x
   ${ghostscript} \
      -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -dFIXEDMEDIA \
      -dPDFFitPage \
      -dQUIET \
      -sPAPERSIZE=${PAPER} \
      -sOutputFile="${OUT}" \
      ${MANY_IN}
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   SIZE_IN="$(($#-2))" # # length minus one
   PAPER="$1"
   MANY_IN="${@:2:${SIZE_IN}}"
   OUT="${@: -1}" # # keep the space
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ -z "$1" ]; then
      echo "Please provide the paper size."
      exit 1
   fi
   for in in ${MANY_IN}; do
      if [ ! -f "${in}" ]; then
         echo "Input file ${in} is not found."
         exit 1
      fi
   done
   if [ -f "${OUT}" ]; then
      echo "File ${OUT} already exists."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"