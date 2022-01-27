#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! -f ./optimiza-all.sh ]; then
   echo "Script optimiza-all.sh is not found."
   exit 1
fi

LOUD=0

./optimize-all.sh "$@" "${LOUD}"