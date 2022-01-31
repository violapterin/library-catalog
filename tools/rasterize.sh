#! /usr/bin/env bash

main()
{
   RESOLUTION=300
   PAPER="$1"
   IN="$2" # image or PDF
   OUT="$3"
   name="${IN##*/}"
   bare="${name%.*}"
   extension="${name##*.}"
   mid="${bare}-mid.pdf"
   convert_option="convert"
   if [ "$4" = "0" ]; then
      convert_option="convert -monochrome"
   fi

   if [ "${extension}" != "pdf" ]; then
      if [ "${extension}" != "jpg" ] && [ "${extension}" != "png" ]; then
         continue
      fi
      echo "converting image ${IN} as ${mid} ..."
      set -x
      ${convert_option} \
         -density "${RESOLUTION}" \
         -page "${PAPER}" \
         "${IN}" \
         "${mid}"
      { set +x; } 2>/dev/null
      IN="${mid}"
   fi

   echo "resizing document ${IN} as ${OUT} ..."
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
      -sOutputFile="${OUT}" \
      "${IN}"
   { set +x; } 2>/dev/null
   rm -f "${mid}"
}

check()
{
   cd "$(dirname $0)"
   if [ ! command -v convert &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ -z "$1" ]; then
      echo "Please provide the paper size."
      exit 1
   fi
   if [ -z "$2" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "$3" ]; then
      echo "Please provide the output filename."
      exit 1
   fi
   if [ ! -f "$2" ]; then
      echo "First input file $2 is not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
