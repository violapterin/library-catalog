#! /usr/bin/env bash

HERE="$(dirname $0)"
if [ ! -f "${HERE}/rasterize.sh" ]; then
   echo "Script rasterize.sh is not found."
   exit 1
fi

COLOR=0

"${HERE}/rasterize.sh" "$@" "${COLOR}"