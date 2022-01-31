#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! -f ./prune.sh ]; then
   echo "Script prune.sh is not found."
   exit
fi

LOUD=1

./prune.sh "$@" "${LOUD}"