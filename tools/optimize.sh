#! /usr/bin/env bash

HERE="$(dirname $0)"

main_folder()
{
   PARALLEL=3
   FOLDER_IN="$1"
   FOLDER_OUT="$2"
   SOUND="$3"
   index=1

   for path_in in "${FOLDER_IN}"/*; do
      if [ ! -f "${path_in}" ]; then
         continue
      fi
      name="${path_in##*/}"
      bare="${name%.*}"
      extension="${name##*.}"
      path_out="${FOLDER_OUT}/${bare}.pdf"
      if [ "${extension}" != "pdf" ]; then
         continue
      fi

      date +%H:%M
      echo "= = = optimizing document" "${path_in}" "with Pdfsizeopt..."
      set -x
      main_file "${path_in}" "${path_out}" "${SOUND}"
      { set +x; } 2>/dev/null
      sleep 5s # # Pause for echo.
      if [ $((index%PARALLEL)) -eq 0 ]; then
         echo wait!
         wait $(jobs -p) # # Wait until every thread is done.
      fi
      index=$((index+1))
   done
   wait $(jobs -p)
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

main_file()
{
   PATH_IN="$1"
   PATH_OUT="$2"
   SOUND="$3"
   pdfsizeopt="pdfsizeopt"
   if [ "${SOUND}" -eq 0 ]; then
      pdfsizeopt="${pdfsizeopt} --quiet"
   fi
   if [ -f "${PATH_OUT}" ]; then
      echo "File ${PATH_OUT} already exists."
      exit 1
   fi

   set -x
   ${pdfsizeopt} "${PATH_IN}" "${PATH_OUT}" &
   { set +x; } 2>/dev/null
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   IN="$1"
   OUT="$2"
   if [ ! command -v pdfsizeopt &> /dev/null ]; then
      echo "Please install Pdfsizeopt."
      exit 1
   fi
   if [ -z "${IN}" ]; then
      echo "Please provide the input file or directory."
      exit 1
   fi
   if [ -z "${OUT}" ]; then
      echo "Please provide the output file or directory."
      exit 1
   fi
   if [ ! -d "${IN}" ] && [ ! -f "${IN}" ]; then
      echo "Input file or directory ${IN} is not found."
      exit 1
   fi
   if [ ! -d "${OUT}" ] && [ ! -f "${OUT}" ]; then
      echo "Output file or directory ${OUT} is not found."
      exit 1
   fi
   if [ -d "${IN}" ] && [ -f "${OUT}" ]; then
      echo "Directory ${IN} and file ${OUT} does not match."
      exit 1
   fi
   if [ -f "${IN}" ] && [ -d "${OUT}" ]; then
      echo "File ${IN} and directory ${OUT} does not match."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

IN="$1"
OUT="$2"
check "$@"
if [ -f "$IN" ]; then
   main_file "$@"
   exit 0
fi
if [ -d "$IN" ]; then
   main_directory "$@"
   exit 0
fi