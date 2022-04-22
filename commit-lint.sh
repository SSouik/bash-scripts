#!/bin/env bash

REGEX="^(added|changed|fix|ci|docs|break): [A-za-z0-9]"
COMMIT=""

while [[ $# -gt 0 ]]
do
  case "$1" in
    --commit|-c)
      COMMIT=$2; shift 2
      ;;
    --regex|-r)
      REGEX=$2; shift 2
      ;;
    *)
      echo "Unsupported flag"
      exit 1
  esac
done


if [[ $COMMIT =~ $REGEX ]]; then
    echo "Your commit message checks out!"
    exit
else
    echo "Your commit message doesn't meet the requirements."
    exit 1
fi
