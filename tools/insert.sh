#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   CUT="$1"
   PATCH="$2"
   IN="$3"
   OUT="$4"
   bare="${OUT%.*}"

   echo "= = = inserting page ${CUT} into document ${IN} ..."
   if [ "${CUT}" -eq 1 ]; then
      set -x
      "${HERE}/combine.sh" "${PATCH}" "${IN}" "${OUT}"
      { set +x; } 2>/dev/null
      exit 0
   fi
   set -x
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dLastPage="$(($CUT-1))" \
      -sOutputFile="${bare}-x.pdf" \
      "${IN}"
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dFirstPage="${CUT}" \
      -sOutputFile="${bare}-y.pdf" \
      "${IN}"
   "${HERE}/combine.sh" "${bare}-x.pdf" "${PATCH}" "${bare}-y.pdf" "${OUT}"
   { set +x; } 2>/dev/null
   rm -f "${bare}-x.pdf"
   rm -f "${bare}-y.pdf"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   HERE="$(dirname $0)"
   CUT="$1"
   PATCH="$2"
   IN="$3"
   OUT="$4"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ ! -f "${HERE}/combine.sh" ]; then
      echo "Script combine.sh is not found."
      exit 1
   fi
   if [ -z "${CUT}" ]; then
      echo "Please provide the page to be cut."
      exit 1
   fi
   if [ -z "${PATCH}" ]; then
      echo "Please provide the patch to be inserted."
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