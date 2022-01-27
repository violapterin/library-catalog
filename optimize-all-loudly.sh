#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! -f ./optimize-all.sh ]; then
   echo "Script optimize-all.sh is not found."
   exit 1
fi

LOUD=1

./optimize-all.sh "$@" "${LOUD}"