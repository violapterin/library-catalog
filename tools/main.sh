#! /usr/bin/env bash

HERE="$(dirname $0)"
OPTION="$1"
if [ "${OPTION:0:2}" != "--" ]; then
   echo "Script ${OPTION} is not found."
   exit 1
fi

action="${OPTION:2:${#OPTION}-1}"
many_argument="${@:2}"
script="${HERE}/${action}.sh"
if [ ! -f "${script}" ]; then
   echo "Script ${GOAL} is not found."
   exit 1
fi

set -x
"${script}" ${many_argument}
{ set +x; } 2>/dev/null
