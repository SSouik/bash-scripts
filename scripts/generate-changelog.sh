#!/bin/bash

USAGE="
Changelog CLI

    --help         | -h     Show this help message
    --version      | -v     Display the version of the CLI
    --config       | -c     Path to the config file to use. (Default .chglog/config.yml)
    --template     | -t     Path to the template file to use. (Default .chglog/CHANGELOG.tpl.md)
    --amend-commit | -a     Amend the updated CHANGELOG changes to the previous commit
"

VERSION="Changelog CLI - v1.0.0"

# Variables
CONFIG=".chglog/config.yml"
TEMPLATE=".chglog/CHANGELOG.tpl.md"
IS_AMEND=0


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
    --config|-c)
      CONFIG=$2; shift
      ;;
    --template|-t)
      TEMPLATE=$2; shift
      ;;
    --amend-commit|-a)
      IS_AMEND=1;
      ;;
    *)
      echo "Unsupported key $1"
      echo "$USAGE"
      exit 1
  esac

  [[ $# > 0 ]] && shift;

done

echo "Fetching git tags"
git fetch

git-chglog \
  --config "$CONFIG" \
  --template "$TEMPLATE" \
  --output "CHANGELOG.md"

if [[ $IS_AMEND -eq 1 ]]; then
    echo "Amending the CHANGELOG updates to the previous commit"
    echo

    git config --global user.name "$(git log -n 1 --pretty=format:%an)"
    git config --global user.email "$(git log -n 1 --pretty=format:%ae)"
    git add .
    git commit --amend --no-edit
    git push origin main
fi
