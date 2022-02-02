#! /usr/bin/env bash

RESOLUTION=300

main()
{
   PAPER="$1"
   PATH_IN="$2" # image or PDF
   PATH_OUT="$3"
   COLOR="$4"
   name="${PATH_IN##*/}"
   bare="${name%.*}"
   extension="${name##*.}"
   mid="${bare}-mid.pdf"
   convert_option="convert"
   if [ "${COLOR}" -eq 0 ]; then
      convert_option="convert -monochrome"
   fi
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   if [ "${extension}" != "pdf" ]; then
      if [ "${extension}" != "jpg" ] && [ "${extension}" != "png" ]; then
         continue
      fi
      echo "converting image ${PATH_IN} as ${mid} ..."
      set -x
      ${convert_option} \
         -density "${RESOLUTION}" \
         -page "${PAPER}" \
         "${PATH_IN}" \
         "${mid}"
      { set +x; } 2>/dev/null
      IN="${mid}"
   fi

   echo "resizing document ${PATH_IN} as ${PATH_OUT} ..."
   set -x
   gs \
      -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -dQUIET \
      -dFIXEDMEDIA \
      -dPDFFitPage \
      -sPAPERSIZE=${PAPER} \
      -sOutputFile="${PATH_OUT}" \
      "${PATH_IN}"
   { set +x; } 2>/dev/null
   rm -f "${mid}"
}

check()
{
   PAPER="$1"
   PATH_IN="$2"
   PATH_OUT="$3"
   if [ ! command -v convert &> /dev/null ]; then
      echo "Please install Imagemagick."
      exit 1
   fi
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
      exit 1
   fi
   if [ -z "${PAPER}" ]; then
      echo "Please provide the paper size."
      exit 1
   fi
   if [ -z "${PATH_IN}" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "${PATH_OUT}" ]; then
      echo "Please provide the output file."
      exit 1
   fi
   if [ ! -f "${PATH_IN}" ]; then
      echo "First input file ${PATH_IN} is not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
