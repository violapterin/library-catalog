#! /usr/bin/env bash

HERE="$(dirname $0)"
if [ ! -f "${HERE}/optimize-all.sh" ]; then
   echo "Script optimize-all.sh is not found."
   exit 1
fi

LOUD=0

./optimize-all.sh "$@" "${LOUD}"