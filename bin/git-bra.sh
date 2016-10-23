#!/usr/bin/env bash

#
# Simple branch operations:
#   * List branches
#   * Switch to branch
#   * Remove branch
#
# usage: git bra [option] [name]
#
# examples: git bra                    List all branch
#           git bra <name>             Switch to branch <name>, creates it if necessary
#           git bra -r <name>          Remove branch <name>
#
# recommended aliases:
#   * gb='git bra'
#   * gbd='git bra dev'
#   * gbm='git bra master'
#   * gbrd='git bra -r dev'
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

# if no branch name, list branches
if [[ $# -eq 0 ]]; then
  git branch
  exit 0
fi

# remove branch
if [[ "$1" == '-r' ]]; then
  # if no branch name
  if [[ $# -lt 2 ]]; then
    abort 'fatal: branch name required'
  fi
  # want remove the master branch
  if [[ "$2" == 'master' ]]; then
    abort "forbidden: remove the branch 'master' is not allowed"
  fi
  # there is only 1 branch
  if [[ `git branch | wc -l` -eq 1 ]]; then
    abort 'error: you need at least 2 branches'
  fi
  # want remove the active branch
  if [[ `git rev-parse --abbrev-ref HEAD` == "$2" ]]; then
    git checkout master
  fi
  git branch -D "$2"
  exit 0
fi

# create the branch
if [[ -z `git branch --no-color | grep "$1$"` ]]; then
  git checkout -b "$1"
  exit 0
fi

# switch to the branch
git checkout "$1"
