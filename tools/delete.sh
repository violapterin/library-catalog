#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   START="$1"
   STOP="$2"
   IN="$3"
   OUT="$4"
   bare="${OUT%.*}"

   echo "= = = deleting from page ${START} to page ${STOP} of document ${IN} ..."
   total="$(${HERE}/count.sh ${IN})"
   if [ "${START}" -eq 1 ]; then
      set -x
      gs \
         -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
         -dSAFER -dBATCH -dNOPAUSE -dQUIET \
         -dFirstPage="$(($STOP+1))" \
         -sOutputFile="${bare}.pdf" \
         "${IN}"
      { set +x; } 2>/dev/null
      exit 0
   elif [ "${STOP}" -eq "${total}" ]; then
      set -x
      gs \
         -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
         -dSAFER -dBATCH -dNOPAUSE -dQUIET \
         -dLastPage="$(($START-1))" \
         -sOutputFile="${bare}.pdf" \
         "${IN}"
      { set +x; } 2>/dev/null
      exit 0
   fi
   set -x
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dLastPage="$(($START-1))" \
      -sOutputFile="${bare}-x.pdf" \
      "${IN}"
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dFirstPage="$(($STOP+1))" \
      -sOutputFile="${bare}-y.pdf" \
      "${IN}"
   "${HERE}/combine.sh" "${bare}-x.pdf" "${bare}-y.pdf" "${bare}.pdf"
   { set +x; } 2>/dev/null
   rm -f "${bare}-x.pdf"
   rm -f "${bare}-y.pdf"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   HERE="$(dirname $0)"
   START="$1"
   STOP="$2"
   IN="$3"
   OUT="$4"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ ! -f "${HERE}/count.sh" ]; then
      echo "Script count.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/combine.sh" ]; then
      echo "Script combine.sh is not found."
      exit 1
   fi
   if [ -z "${START}" ]; then
      echo "Please provide the page to be deleted."
      exit 1
   fi
   if [ -z "${STOP}" ]; then
      echo "Please provide the page to be deleted."
      exit 1
   fi
   if [ -z "${IN}" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "${OUT}" ]; then
      echo "Please provide the output filename."
      exit 1
   fi
   if [ -f "${OUT}" ]; then
      echo "File ${OUT} already exists."
      exit 1
   fi
   if [ ! -f "${IN}" ]; then
      echo "Input file "${IN}" not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"