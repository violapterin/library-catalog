#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   RESOLUTION=300
   PAPER="$1"
   FOLDER_IN="$2"
   FOLDER_OUT="$3"
   PARALLEL=3
   index=1
   pdfsizeopt_option="pdfsizeopt"
   if [ "$4" -eq 0 ]; then
      pdfsizeopt_option="pdfsizeopt --quiet"
   fi

   for path_in in "${FOLDER_IN}"/*; do
      if [ ! -f "${path_in}" ]; then
         continue
      fi
      name="${path_in##*/}"
      bare="${name%.*}"
      extension="${name##*.}"
      path_out="${FOLDER_OUT}/${bare}.pdf"
      if [ "${extension}" != "pdf" ]; then
         continue
      fi

      date +%H:%M
      echo "= = = optimizing document" "${path_in}" "with Pdfsizeopt..."
      rm -f "${path_out}"
      set -x
      ${pdfsizeopt_option} "${path_in}" "${path_out}" &
      { set +x; } 2>/dev/null
      sleep 3s # # for echo
      #sleep $((20-index*3))s &
      #((index==0)) && wait -n
      if [ $((index%PARALLEL)) -eq 0 ]; then
         echo wait!
         #wait -n
         wait $(jobs -p)
      fi
      index=$((index+1))
      #sleep 65s
   done
   wait $(jobs -p) # # wait until every thread is done
}

check()
{
   cd "$(dirname $0)"
   if [ ! command -v pdfsizeopt &> /dev/null ]; then
      echo "Please install pdfsizeopt."
      exit 1
   fi
   if [ -z "$1" ]; then
      echo "Please provide the paper size."
      exit 1
   fi
   if [ -z "$2" ]; then
      echo "Please provide the input directory."
      exit 1
   fi
   if [ -z "$3" ]; then
      echo "Please provide the output directory."
      exit 1
   fi
   if [ ! -d "$2" ]; then
      echo "Input directory $2 is not found."
      exit 1
   fi
   if [ ! -d "$3" ]; then
      echo "Output directory $3 is not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
