#!/usr/bin/env sh
set -eu

organization=${MULTITION_GITHUB_ORG:-Multition}

workspace_dir=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)

for repository in \
  multition-mobile \
  multition-web \
  multition-api \
  multition-ai \
  multition-docs
do
  destination="$workspace_dir/$repository"
  if [ -e "$destination" ]; then
    echo "skip $repository: $destination already exists"
  else
    git clone "https://github.com/${organization}/${repository}.git" "$destination"
  fi
done
