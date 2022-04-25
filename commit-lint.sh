#!/bin/env bash

USAGE="
Commit Lint CLI

    --help         | -h     Show this help message
    --version      | -v     Display the version of the CLI
    --commit       | -c     Commit message that should be linted (Use if only linting a single commit)
    --regex        | -r     Custom regex to use to lint the commit message (Overrides the default)
    --pull-request | -p     Lint all commits in a pull request (Lints commits that are between the new/current branch and main)
"

VERSION="Commit Lint CLI - v1.1.0"

# Variables
REGEX="^(added|changed|fix|ci|docs|break): [A-za-z0-9]"
COMMIT=""
IS_PULL_REQUEST=0

function commit_lint () {
  commit=$1

  if [[ $commit =~ $REGEX ]]; then
      echo "Commit message: '${commit}' checks out!"
      echo
  else
      echo "Commit message: '${commit}' doesn't meet the requirements."
      echo
      exit 1
  fi
}

# If no arguments are given, then print usage
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

# If the pull request flag is set, then lint all commits in the pull request
if [[ $IS_PULL_REQUEST -eq 1 ]]; then
  echo "Linting pull request commits"
  echo

  # Get count of commits in PR
  count=$(git rev-list --count HEAD ^main)

  # Get list of commits
  commit_logs=$(git log -${count} --pretty=%B)

  # Split into an array of commits
  IFS=$'\n' read -rd '' -a commits <<< "$commit_logs"

  for commit in "${commits[@]}";
  do
      commit_lint "$commit"
  done

  exit
fi

commit_lint "$COMMIT"
