#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   RESOLUTION=300
   DELETED="$1"
   IN="$2"
   OUT="$3"
   bare="${OUT%.*}"

   echo "= = = deleting page ${DELETED} of document ${IN} ..."
   if [ "${DELETED}" -eq 1 ]; then
      set -x
      gs \
         -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
         -dSAFER -dBATCH -dNOPAUSE -dQUIET \
         -sOutputFile="${bare}.pdf" \
         "${IN}"
      { set +x; } 2>/dev/null
      exit 0
   fi
   set -x
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dLastPage="$(($1-1))" \
      -sOutputFile="${bare}-x.pdf" \
      "${IN}"
   gs \
      -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 \
      -dSAFER -dBATCH -dNOPAUSE -dQUIET \
      -dFirstPage="$(($1+1))" \
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
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install ghostscript."
      exit 1
   fi
   if [ -z "$1" ]; then
      echo "Please provide the page to be deleted."
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
      echo "Input file $2 not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"