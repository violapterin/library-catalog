#! /usr/bin/env bash

main()
{
   # # stackoverflow.com/questions/14704274
   # #       /how-to-write-shell-script-for-finding-number-of-pages-in-pdf
   PATH_IN="$1"
   echo "$(pdftoppm ${PATH_IN} -f 1000000 2>&1 \
            | grep -o '([0-9]*)\.$' \
            | grep -o '[0-9]*')"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check()
{
   PATH_IN="$1"
   if [ ! command -v pdftoppm &> /dev/null ]; then
      echo "Please install Poppler."
      exit 1
   fi
   if [ -z "${PATH_IN}" ]; then
      echo "Please provide the input file."
      exit 1
   fi
   if [ ! -f "${PATH_IN}" ]; then
      echo "Input file ${PATH_IN} not found."
      exit 1
   fi
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

check "$@"
main "$@"
