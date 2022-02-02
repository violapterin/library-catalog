#! /usr/bin/env bash

HERE="$(dirname $0)"
if [ ! -f "${HERE}/optimize.sh" ]; then
   echo "Script optimize.sh is not found."
   exit 1
fi

SOUND=0

"${HERE}/optimize.sh" "$@" "${SOUND}"