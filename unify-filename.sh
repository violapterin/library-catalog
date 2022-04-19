#! /usr/bin/env bash

HERE="$(dirname $0)"
THIS="unify-filename.sh"
PATH_THIS="${HERE}/${THIS}"

FOLDER="$1"

for path_in in "${FOLDER}"/*; do
   if [ -d "${path_in}" ]; then
      "${PATH_THIS}" "${path_in}"
      continue
   fi

   name="${path_in##*/}"
   if [ "${name##*.}" != pdf ]; then
      continue
   fi
   bare="${name%.*}"
   bare="${bare// /-}"
   bare="${bare//_/-}"
   path_out="${FOLDER}/${bare}.pdf"
   if [ "${path_in}" = "${path_out}" ]; then
      continue
   fi
   set -x
   mv "${path_in}" "${path_out}"
   { set +x; } 2>/dev/null
done

# rename "s/_/-/" *.pdf
# rename "s/ /-/" *.pdf