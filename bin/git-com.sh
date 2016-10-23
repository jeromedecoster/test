#!/usr/bin/env bash

#
# Commit with message taken
#  * from arguments
#  * from the previous semver message updated to the next minor version
#  * from the previous semver message updated to the next patch version
#
# usage: git com [option] [message] [...]
#
# examples: git com                    If no commit history, commit with the log '0.0.0', otherwise abort
#           git com <the> <message>    Commit with <the message> log
#           git com -m                 Find the previous semver log message and commit with the next minor version
#           git com -p                 Find the previous semver log message and commit with the next patch version
#
# recommended aliases:
#   * gc='git com'
#   * gcm='git com -m'
#   * gcp='git com -p'
#

abort() {
  echo "$1" >&2
  exit 1
}

# abort if not inside a git repo
git rev-parse --git-dir >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
  abort 'fatal: not a git repository (or any of the parent directories): .git'
fi

# if no staged files
if [[ -z `git diff --cached --name-only` ]]; then
  # if modified/removed or untracked files
  if [[ -n `git ls-files --modified --exclude-standard` || \
        -n `git ls-files --others --directory --exclude-standard` ]]; then
    git status
    exit 1
  fi
  abort 'abort: nothing to commit, working tree clean'
fi

# if no params
if [[ $# -eq 0 ]]; then
  # if no previous commit
  if [[ -z `git log -n 1 --pretty="format:%h" 2>/dev/null` ]]; then
    git commit -m 0.0.0
    exit 0
  fi
  abort 'abort: log message or option required'
fi

# find the first previous log message which looks like a semver 'x.x.x'
# define $semver or abort
previous() {
  semver=`git --no-pager log -n 9999  --pretty="format:%s" --grep ^[0-9] \
            | grep -E "^[0-9]+\.[0-9]+\.[0-9]+$" \
            | head -n 1`
  if [[ -z $semver ]]; then
    abort 'abort: no previous semver log message found'
  fi
}

# if minor update option
if [[ $1 == '-m' ]]; then
  previous
  maj=`echo $semver | cut -d '.' -f 1`
  min=`echo $semver | cut -d '.' -f 2`
  git commit -m $maj.$(($min + 1)).0
  exit 0
fi

# if patch update option
if [[ $1 == '-p' ]]; then
  previous
  maj=`echo $semver | cut -d '.' -f 1`
  min=`echo $semver | cut -d '.' -f 2`
  pat=`echo $semver | cut -d '.' -f 3`
  git commit -m $maj.$min.$(($pat + 1))
  exit 0
fi

# commit the arguments as message
git commit -m "`echo -n $@`"
