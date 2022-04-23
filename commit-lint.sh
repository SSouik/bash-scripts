#!/bin/env bash

REGEX="^(added|changed|fix|ci|docs|break): [A-za-z0-9]"
COMMIT=""

USAGE="
Commit Lint CLI

    --commit | -c     Commit message that should be linted
    --regex  | -r     Custom regex to use to lint the commit message
"

VERSION="Commit Lint CLI - v1.0.0"
if [[ $# -eq 0 ]]; then
    echo "$USAGE"
    exit
fi

while [[ $# -gt 0 ]]
do
  case "$1" in
    --help|-h)
      echo "$USAGE";
      exit
      ;;
    --version|-v)
      echo "$VERSION"
      exit
      ;;
    --commit|-c)
      COMMIT=$2; shift 2
      ;;
    --regex|-r)
      REGEX=$2; shift 2
      ;;
    *)
      echo "Unsupported key $1"
      echo "$USAGE"
      exit 1
  esac

  [[ $# > 0 ]] && shift;

done


if [[ $COMMIT =~ $REGEX ]]; then
    echo "Your commit message checks out!"
    exit
else
    echo "Your commit message doesn't meet the requirements."
    exit 1
fi
