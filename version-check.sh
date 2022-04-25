#!/bin/env bash

USAGE="
Version Check CLI

    --help    | -h     Show this help message
    --version | -v     Display the version of the CLI
    --file    | -f     Path to the version file (i.e package.json)
    --key     | -k     Name of the key in the JSON file which holds the version number (i.e version)
    --org     | -o     Name of the GitHub org to get upstream version from
    --repo    | -r     Name of the GitHub repo to get upstream version from
    --branch  | -b     Branch name to get upstream version from
"

VERSION="Version Check CLI - v1.0.0"

# Variables
RAW_GITHUB_HOST="https://raw.githubusercontent.com"
GITHUB_ORG=""
GITHUB_REPO=""
GITHUB_BRANCH=""
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
    --org|-o)
      GITHUB_ORG="$2"; shift
      ;;
    --repo|-r)
      GITHUB_REPO="$2"; shift
      ;;
    --branch|-b)
      GITHUB_BRANCH="$2"; shift
      ;;
    *)
      echo "Unsupported key $1"
      echo "$USAGE"
      exit 1
  esac

  [[ $# > 0 ]] && shift;

done

UPSTREAM_VERSION_FILE="$RAW_GITHUB_HOST/$GITHUB_ORG/$GITHUB_REPO/$GITHUB_BRANCH/$PATH_TO_VERSION_FILE"

# Get upstream version
UPSTREAM_VERSION=$(curl -s ${UPSTREAM_VERSION_FILE} | grep "\"${KEY_NAME}\"": | cut -d\" -f4)

# Get current version
CURRENT_VERSION=$(grep "\"${KEY_NAME}\"": ${PATH_TO_VERSION_FILE} | cut -d\" -f4)

echo "$UPSTREAM_VERSION"
echo "$CURRENT_VERSION"
