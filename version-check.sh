#!/bin/env bash

USAGE="
Version Check CLI

Validate local version number against the upstream version.
Only supports version numbers store in MAJOR.MINOR.PATCH
and stored within a JSON file.

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
GITHUB_BRANCH="main"
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

echo
echo
echo "Upstream version: $UPSTREAM_VERSION"
echo "Local version: $CURRENT_VERSION"
echo

upstream_versions=(${UPSTREAM_VERSION//./ })
local_versions=(${CURRENT_VERSION//./ })

# Upstream versions
upstream_major=${upstream_versions[0]}
upstream_minor=${upstream_versions[1]}
upstream_patch=${upstream_versions[2]}

# Local versions
local_major=${local_versions[0]}
local_minor=${local_versions[1]}
local_patch=${local_versions[2]}

# Major version is less than upstream
if [[ $local_major -lt $upstream_major ]]; then
  echo "Major version in local version is invalid."
  exit 1
fi

# Major version was incremented too much i.e 1 -> 3
if (( local_major > upstream_major + 1 )); then
  update_to_version=$((upstream_major + 1))
  echo "Major version must increment by 1: Update your local major version to ${update_to_version}"
  exit 1
fi

# Major version is bumped, so minor and patch version should be 0
if (( local_major == upstream_major + 1)); then
  if (( local_minor != 0 )); then
    echo "Minor version must be 0 when incrementing the major version."
    exit 1
  fi

  if (( local_patch != 0 )); then
    echo "Patch version must be 0 when incrementing the major version."
    exit 1
  fi

  echo "Local version number is valid"
  exit 0
fi

# Major version is not bumped
# Minor version is less than upstream
if [[ $local_minor -lt $upstream_minor ]]; then
  echo "Minor version in local version is invalid."
  exit 1
fi

# Minor version was incremented too much i.e 1 -> 3
if (( local_minor > upstream_minor + 1 )); then
  update_to_version=$((upstream_minor + 1))
  echo "Minor version must increment by 1: Update your local minor version to ${update_to_version}"
  exit 1
fi

# Minor version is bumped, so patch version must be 0
if (( local_minor == upstream_minor + 1)); then
  if (( local_patch != 0 )); then
    echo "Patch version must be 0 when incrementing the minor version."
    exit 1
  fi

  echo "Local version number is valid"
  exit 0
fi

# Major and Minor versions are not bumped
# Patch version is less than upstream
if [[ $local_patch -lt $upstream_patch ]]; then
  echo "Patch version in local version is invalid."
  exit 1
fi

# Patch version is bumped by 1 and is valid
if (( local_patch == upstream_patch + 1 )); then
  echo "Local version number is valid"
  exit 0
fi

update_to_version=$((upstream_patch + 1))
echo "Patch version must increment by 1: Update your local patch version to ${update_to_version}"
exit 1 

