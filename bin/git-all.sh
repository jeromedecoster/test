#!/usr/bin/env bash

#
# Add all files from the git root
#
# usage: git all
#
# recommended alias:
#   * ga='git all'
#

abort() {
  echo "$1" >&2
  exit 128
}

# abort if not inside a git repo
git rev-parse --git-dir >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
  abort 'fatal: not a git repository (or any of the parent directories): .git'
fi

# add all files from the git root
git add "`git rev-parse --show-toplevel`"
