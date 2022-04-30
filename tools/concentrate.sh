#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   HORIZONTAL_ODD="$1"
   VERTICAL_ODD="$2"
   IN="$3"
   OUT="$4"
   bare="${OUT%.*}"

   HORIZONTAL_EVEN=
   if [ "${HORIZONTAL_ODD:0:1}" = - ]; then
      HORIZONTAL_EVEN="${HORIZONTAL_ODD:1:${#HORIZONTAL_ODD}}"
   else
      HORIZONTAL_EVEN="-${HORIZONTAL_ODD}"
   fi
   VERTICAL_EVEN=
   if [ "${VERTICAL_ODD:0:1}" = - ]; then
      VERTICAL_EVEN="${VERTICAL_ODD:1:${#VERTICAL_ODD}}"
   else
      VERTICAL_EVEN="-${VERTICAL_ODD}"
   fi

   echo "= = = concentrating even and odd pages of document ${IN} by ${HORIZONTAL_ODD} and ${HORIZONTAL_ODD} ..."
   rm -f "${bare}-o.pdf" "${bare}-e.pdf" "${bare}-og.pdf" "${bare}-eg.pdf"
   set -x
   "${HERE}/odd.sh" "${IN}" "${bare}-o.pdf"
   "${HERE}/even.sh" "${IN}" "${bare}-e.pdf"
   "${HERE}/shift.sh" "${HORIZONTAL_ODD}" "${VERTICAL_ODD}" "${bare}-o.pdf" "${bare}-og.pdf"
   "${HERE}/shift.sh" "${HORIZONTAL_EVEN}" "${VERTICAL_EVEN}" "${bare}-e.pdf" "${bare}-eg.pdf"
   pdftk A="${bare}-og.pdf" B="${bare}-eg.pdf" shuffle A B output "${OUT}"
   { set +x; } 2>/dev/null
   rm -f "${bare}-o.pdf" "${bare}-e.pdf" "${bare}-og.pdf" "${bare}-eg.pdf"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   HERE="$(dirname $0)"
   HORIZONTAL_ODD="$1"
   VERTICAL_ODD="$2"
   IN="$3"
   OUT="$4"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ ! -f "${HERE}/odd.sh" ]; then
      echo "Script odd.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/even.sh" ]; then
      echo "Script even.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/shift.sh" ]; then
      echo "Script odd.sh is not found."
      exit 1
   fi
   if [ ! command -v pdftk &> /dev/null ]; then
      echo "Please install pdftk."
      exit 1
   fi
   if [ -z "${HORIZONTAL_ODD}" ]; then
      echo "Please provide how much odd pages are to be shifted horizontally."
      exit 1
   fi
   if [ -z "${VERTICAL_ODD}" ]; then
      echo "Please provide how much odd pages are to be shifted vertically."
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