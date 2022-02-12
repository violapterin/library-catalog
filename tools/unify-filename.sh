#! /usr/bin/env bash

HERE="$(dirname $0)"
THIS="unify-filename.sh"
PATH_THIS="${HERE}/${THIS}"

FOLDER_IN="$2"

for space in ' ' '_'; do
   for path_in in "${FOLDER_IN}"/*; do
      if [ -d "${path_in}" ]; then
         "${PATH_THIS}" "${path_in}"
         continue
      fi

      name="${path_in##*/}"
      bare="${name%.*}"
      extension="${name##*.}"
      path_out="${FOLDER_OUT}/${bare}.pdf"
      if [ "${extension}" != pdf ]; then
         continue
      fi
      path_out="${path_in/${space}/-}"
      echo mv "${path_in}" "${path_out}"
   done
done

# rename "s/_/-/" *.pdf
# rename "s/ /-/" *.pdf