#!/bin/env bash

USAGE="
Version Check CLI

    --commit | -c     Commit message that should be linted
    --regex  | -r     Custom regex to use to lint the commit message
"

VERSION="Version Check CLI - v1.0.0"

PATH_TO_VERSION_FILE=""
KEY_NAME="version"

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
    --file|-f)
      PATH_TO_VERSION_FILE=$2; shift
      ;;
    --key|-k)
      KEY_NAME=$2; shift
      ;;
    *)
      echo "Unsupported key $1"
      echo "$USAGE"
      exit 1
  esac

  [[ $# > 0 ]] && shift;

done

# Get current version
CURRENT_VERSION=$(grep "\"${KEY_NAME}\"": ${PATH_TO_VERSION_FILE} | cut -d\" -f4)

echo "$CURRENT_VERSION"
