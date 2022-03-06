#! /usr/bin/env bash

main()
{
   HERE="$(dirname $0)"
   LEFT="$1"
   BOTTOM="$2"
   PAGE="$3"
   IN="$4"
   OUT="$5"
   if [ -f "${OUT}" ]; then
      echo "File ${OUT} already exists."
      exit 1
   fi

   echo "= = = shifting page ${PAGE} of ${IN}, ${LEFT} from left and ${BOTTOM} from bottom ..."
   total="$(${HERE}/count.sh ${IN})"
   flag=1
   if [ "$PAGE" -gt 1 ]; then
      "${HERE}/extract.sh" 1 "$(($PAGE-1))" "${IN}" "a-${IN}"
   else
      flag=0
   fi
   if [ "$PAGE" -lt "$total" ]; then
      "${HERE}/extract.sh" "$(($PAGE+1))" "${total}" "${IN}" "c-${IN}"
   else
      flag=2
   fi
   "${HERE}/extract.sh" "${PAGE}" "${PAGE}" "${IN}" "b-${IN}"

   "${HERE}/shift.sh" "${LEFT}" "${BOTTOM}" "b-${IN}" "bg-${IN}"

   if [ "$flag" -eq 0 ]; then
      echo 0: $flag
      "${HERE}/combine.sh" "bg-${IN}" "c-${IN}" "${OUT}"
      rm "c-${IN}"
   elif [ "$flag" -eq 1 ]; then
      set -x
      "${HERE}/combine.sh" "a-${IN}" "bg-${IN}" "c-${IN}" "${OUT}"
      set +x
      rm "a-${IN}" "c-${IN}"
   elif [ "$flag" -eq 2 ]; then
      echo 2: $flag
      "${HERE}/combine.sh" "a-${IN}" "bg-${IN}" "${OUT}"
      rm "a-${IN}"
   fi
   rm "b-${IN}" "bg-${IN}"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   HERE="$(dirname $0)"
   LEFT="$1"
   BOTTOM="$2"
   PAGE="$3"
   IN="$4"
   OUT="$5"
   if [ ! -f "${HERE}/shift.sh" ]; then
      echo "Script shift.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/extract.sh" ]; then
      echo "Script combine.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/combine.sh" ]; then
      echo "Script combine.sh is not found."
      exit 1
   fi
   if [ ! -f "${HERE}/count.sh" ]; then
      echo "Script count.sh is not found."
      exit 1
   fi
   if [ -z "${LEFT}" ]; then
      echo "Please provide the left offset."
      exit 1
   fi
   if [ -z "${BOTTOM}" ]; then
      echo "Please provide the bottom offset."
      exit 1
   fi
   if [ -z "${PAGE}" ]; then
      echo "Please provide the number of the page to be shifted."
      exit 1
   fi
   if [ -z "${IN}" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ -z "${OUT}" ]; then
      echo "Please provide the output filename."
      exit 1
   fi
   if [ ! -f "${IN}" ]; then
      echo "Input file ${IN} not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
