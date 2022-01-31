#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! -f ./prune-all.sh ]; then
   echo "Script prune-all.sh is not found."
   exit
fi

LOUD=1

./prune-all.sh "$@" "${LOUD}"