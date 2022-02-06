#! /usr/bin/env bash

HERE="$(dirname $0)"
if [ ! -f "${HERE}/prune.sh" ]; then
   echo "Script prune.sh is not found."
   exit 1
fi

SOUND=0

"${HERE}/prune.sh" "$@" "${SOUND}"