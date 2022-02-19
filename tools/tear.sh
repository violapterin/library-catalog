#! /usr/bin/env bash

RESOLUTION=150

main()
{
   FOLDER_IN="$1"
   FOLDER_OUT="$2"
   ghostscript="gs -dQUIET"

   for path_in in "${FOLDER_IN}"/*; do
      if [ ! -f "${path_in}" ]; then
         continue
      fi
      name="${path_in##*/}"
      bare="${name%.*}"
      extension="${name##*.}"
      if [ "${extension}" != pdf ]; then
         continue
      fi
      path_out="${FOLDER_OUT}/${bare}"
      if [ -d "${path_out}" ]; then
         echo "Directory ${path_out} already exists."
         exit 1
      fi
      mkdir "${path_out}"

      echo "= = = tearing document ${path_in} ..."
      set -x
      ${ghostscript} \
         -sDEVICE=jpeggray \
         -dCompatibilityLevel=1.7 \
         -dSAFER \
         -dBATCH \
         -dNOPAUSE \
         -r"${RESOLUTION}" \
         -sOutputFile="${path_out}/page-%03d.jpg" \
         "${path_in}"
      { set +x; } 2>/dev/null
   done
}

check()
{
   FOLDER_IN="$1"
   FOLDER_OUT="$2"
   if [ ! command -v gs &> /dev/null ]; then
      echo "Please install Ghostscript."
      exit 1
   fi
   if [ -z "${FOLDER_IN}" ]; then
      echo "Please provide the input directory."
      exit 1
   fi
   if [ -z "${FOLDER_OUT}" ]; then
      echo "Please provide the output directory."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
