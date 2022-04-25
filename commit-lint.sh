#!/bin/env bash

USAGE="
Commit Lint CLI

    --commit | -c     Commit message that should be linted
    --regex  | -r     Custom regex to use to lint the commit message
"

VERSION="Commit Lint CLI - v1.1.0"

# Variables
REGEX="^(added|changed|fix|ci|docs|break): [A-za-z0-9]"
COMMIT=""
IS_PULL_REQUEST=0

function commit_lint () {
    commit=$1

    if [[ $COMMIT =~ $REGEX ]]; then
        echo "Commit message: '${commit}' checks out!"
    else
        echo "Commit message: '${commit}' doesn't meet the requirements."
        exit 1
    fi
}

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
      COMMIT=$2; shift
      ;;
    --pull-request|-p)
        IS_PULL_REQUEST=1;
        ;;
    --regex|-r)
      REGEX=$2; shift
      ;;
    *)
      echo "Unsupported key $1"
      echo "$USAGE"
      exit 1
  esac

  [[ $# > 0 ]] && shift;

done


if [[ $IS_PULL_REQUEST -eq 1 ]]; then
    echo "Linting pull request commits"

    # Get count of commits in PR
    count=$(git rev-list --count HEAD ^main)

    echo "$count"
    # Get list of commits
    commits=$(git log -${count} --pretty=%B)

    echo "$commits"
    exit
fi
