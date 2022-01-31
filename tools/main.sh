#! /usr/bin/env bash

HERE="$(dirname $0)"
GOAL="$1"
many_argument="${@:2}"
declare -a many_action=( \
   optimize-all.sh \
   optimize-all-silently.sh \
   optimize-all-loudly.sh \
   prune.sh \
   prune-silently.sh \
   prune-loudly.sh \
   combine.sh \
   delete.sh \
   extract.sh \
)

for action in "${many_action[@]}"; do
   if [ "${action}" != "${GOAL}" ]; then
      continue
   fi
   script="${HERE}/${action}"
   if [ -f "${script}" ]; then
      "${script}" "${many_argument}"
   fi
done

