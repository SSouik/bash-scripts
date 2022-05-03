#!/bin/bash

USAGE="
GitHub Release CLI

    --help    | -h     Show this help message
    --version | -v     Display the version of the CLI
    --file    | -f     Path to the version file (i.e package.json)
    --key     | -k     Name of the key in the JSON file which holds the version number (i.e version)
    --user    | -u     GitHub user/login to use when authenticating with the GitHub API
    --token   | -t     GitHub access token to use when interacting with the GitHub API
    --host    | -s     Custom regex to use to lint the commit message (Overrides the default)
    --org     | -o     Name of the GitHub org to get upstream version from
    --repo    | -r     Name of the GitHub repo to get upstream version from
"

VERSION="GitHub Release CLI - v1.0.0"

# Variables
PATH_TO_VERSION_FILE=""
KEY_NAME="version"
GITHUB_USER=""
GITHUB_TOKEN=""
GITHUB_API_HOST="api.github.com"
GITHUB_ORG=""
GITHUB_REPO=""

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
    --user|-u)
      GITHUB_USER="$2"; shift
      ;;
    --token|-t)
      GITHUB_TOKEN="$2"; shift
      ;;
    --host|-u)
      GITHUB_API_HOST="$2"; shift
      ;;
    --org|-o)
      GITHUB_ORG="$2"; shift
      ;;
    --repo|-r)
      GITHUB_REPO="$2"; shift
      ;;
    *)
      echo "Unsupported key $1"
      echo "$USAGE"
      exit 1
  esac

  [[ $# > 0 ]] && shift;

done

# Get the current version of the project
CURRENT_VERSION=$(grep "\"${KEY_NAME}\"": ${PATH_TO_VERSION_FILE} | cut -d\" -f4)


echo "Creating release for v${CURRENT_VERSION}"

# Create the release
curl \
    -X POST \
    -u "${USER}:${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github.v3+json" \
    "https://${GITHUB_API_HOST}/repos/${GITHUB_ORG}/${GITHUB_REPO}/releases" \
    -d "{\"tag_name\":\"v${CURRENT_VERSION}\",\"name\":\"v${CURRENT_VERSION}\",\"generate_release_notes\":true}\""
