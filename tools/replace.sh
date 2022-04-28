#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   LEFT="$1"
   RIGHT="$2"
   PATCH="$3"
   IN="$4"
   OUT="$5"
   bare="${OUT%.*}"

   echo "= = = replacing page ${LEFT} to ${RIGHT} of document ${IN} ..."
   total="$(${HERE}/count.sh ${IN})"
   if [ "${LEFT}" -eq 1 ]; then
      set -x
      "${HERE}/combine.sh" "${PATCH}" "${IN}" "${OUT}"
      { set +x; } 2>/dev/null
      exit 0
   elif [ "${RIGHT}" -eq "${total}" ]; then
      set -x
      "${HERE}/combine.sh" "${IN}" "${PATCH}" "${OUT}"
      { set +x; } 2>/dev/null
      exit 0
   fi
   set -x
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dLastPage="$(($LEFT-1))" \
      -sOutputFile="${bare}-x.pdf" \
      "${IN}"
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dFirstPage="$(($RIGHT+1))" \
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
   LEFT="$1"
   RIGHT="$2"
   PATCH="$3"
   IN="$4"
   OUT="$5"
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
   if [ -z "${LEFT}" ]; then
      echo "Please provide the starting page to be replaced."
      exit 1
   fi
   if [ -z "${RIGHT}" ]; then
      echo "Please provide the stopping page to be replaced."
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