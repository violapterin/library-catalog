#! /usr/bin/env bash

main()
{
   DELETED_START="$1"
   DELETED_END="$2"
   IN="$3"
   OUT="$4"
   bare="${OUT%.*}"

   echo "= = = deleting from page ${DELETED_START} to page ${DELETED_END} of document ${IN} ..."
   if [ "${DELETED_END}" = "1" ]; then
      set -x
      gs \
         -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
         -dSAFER -dBATCH -dNOPAUSE -dQUIET \
         -dFirstPage=2 \
         -sOutputFile="${bare}.pdf" \
         "${IN}"
      { set +x; } 2>/dev/null
      exit 0
   fi
   set -x
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dLastPage="$(($DELETED_START-1))" \
      -sOutputFile="${bare}-x.pdf" \
      "${IN}"
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dFirstPage="$(($DELETED_END+1))" \
      -sOutputFile="${bare}-y.pdf" \
      "${IN}"
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -sOutputFile="${bare}.pdf" \
      "${bare}-x.pdf" "${bare}-y.pdf"
      rm -f "${bare}-x.pdf"
      rm -f "${bare}-y.pdf"
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   DELETED_START="$1"
   DELETED_END="$2"
   IN="$3"
   OUT="$4"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ -z "${DELETED_START}" ]; then
      echo "Please provide the page to be deleted."
      exit 1
   fi
   if [ -z "${DELETED_END}" ]; then
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