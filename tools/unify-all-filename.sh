#! /usr/bin/env bash

THIS="unify-all-filename"
PATH_THIS="${HERE}/${THIS}.sh"

for space in ' ' '_'; do
   for path_in in "${FOLDER_IN}"/*; do
      name="${path_in##*/}"
      bare="${name%.*}"
      extension="${name##*.}"
      path_out="${FOLDER_OUT}/${bare}.pdf"
      if [ -d "${path_in}" ]; then
         "${PATH_THIS}" "${path_in}"
      fi

      if [ ! -f "${path_in}" ]; then
         continue
      fi
      path_out="${path_in/${space}/-}"
      mv "${path_in}" "${path_out}"
   done
done

# rename "s/_/-/" *.pdf
# rename "s/ /-/" *.pdf