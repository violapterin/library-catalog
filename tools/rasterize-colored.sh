#! /usr/bin/env bash

cd "$(dirname $0)"
if [ ! -f ./rasterize.sh ]; then
   echo "Script rasterize.sh is not found."
   exit
fi

COLOR=1

./rasterize.sh "$@" "${COLOR}"