#!/usr/bin/env sh
set -eu

workspace_dir=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
status=0

for command in node npm python3.12 docker; do
  if command -v "$command" >/dev/null 2>&1; then
    echo "ok: $command"
  else
    echo "missing: $command" >&2
    status=1
  fi
done

for repository in \
  multition-mobile \
  multition-web \
  multition-api \
  multition-ai \
  multition-infra \
  multition-docs
do
  if [ -d "$workspace_dir/$repository" ]; then
    echo "ok: $repository"
  else
    echo "missing: $repository" >&2
    status=1
  fi
done

exit "$status"
