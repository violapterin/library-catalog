#! /usr/bin/env bash

cd "$(dirname $0)"
FOLDER_IN=.
FOLDER_OUT=~/github-1/library-catalogs

for path_in in "${FOLDER_IN}"/*; do
   if [ ! -f "${path_in}" ]
   then
      continue
   fi
   name="${path_in##*/}"
   bare="${name%.*}"
   extension="${name##*.}"
   path_out="${FOLDER_OUT}/${bare}.sh"

   if [ "${extension}" = sh ]; then
      echo "copying document" "${path_in}" "to" "${path_out}" "..."
      rm -f "${path_out}"
      set -x
      cp "${path_in}" "${path_out}"
      { set +x; } 2>/dev/null
   fi
done

for path_in in "${FOLDER_IN}"/catalogs/*; do
   if [ ! -f "${path_in}" ]; then
      continue
   fi
   name="${path_in##*/}"
   path_out="${FOLDER_OUT}/catalogs/${name}"

   echo "copying document" "${path_in}" "to" "${path_out}" "..."
   rm -f "${path_out}"
   set -x
   cp "${path_in}" "${path_out}"
   { set +x; } 2>/dev/null
done