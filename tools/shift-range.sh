#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   if [ ! -f "${HERE}/shift.sh" ]; then
      echo "Script shift.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/extract.sh" ]; then
      echo "Script combine.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/combine.sh" ]; then
      echo "Script combine.sh is not found."
      exit 1
   fi

   LEFT="$1"
   BOTTOM="$2"
   PAGE="$3"
   PATH_IN="$4"
   PATH_OUT="$5"
   ghostscript="gs -dQUIET"
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   "${HERE}/extract.sh" 1 "$((PAGE-1))" "${PATH_IN}" "${PATH_IN}-a"
   "${HERE}/extract.sh" "${PAGE}" "${PATH_IN}" "${PATH_IN}-b"
   "${HERE}/extract.sh" "$((PAGE-1))" "$((PAGE-1))" "${PATH_IN}" "${PATH_IN}-a"

   echo "= = = shifting page ${PAGE} of ${PATH_IN}, ${START} from left and ${END} from bottom ..."
   set -x
   ${ghostscript} \
      -sDEVICE=pdfwrite \
      -dCompatibilityLevel=1.7 \
      -dSAFER \
      -dBATCH \
      -dNOPAUSE \
      -sOutputFile="${PATH_OUT}" \
      -c "<</PageOffset [${LEFT} ${BOTTOM}]>> setpagedevice" -f \
      "${PATH_IN}"
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   LEFT="$1"
   BOTTOM="$2"
   PAGE="$3"
   PATH_IN="$4"
   PATH_OUT="$5"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
      exit 1
   fi
   if [ -z "${LEFT}" ]; then
      echo "Please provide the left offset."
      exit 1
   fi
   if [ -z "${BOTTOM}" ]; then
      echo "Please provide the bottom offset."
      exit 1
   fi
   if [ -z "${PATH_IN}" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "${PATH_OUT}" ]; then
      echo "Please provide the output filename."
      exit 1
   fi
   if [ ! -f "${PATH_IN}" ]; then
      echo "Input file ${PATH_IN} not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
