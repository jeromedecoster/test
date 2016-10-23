#!/usr/bin/env bash

#
# Merge a branch without autocommit and by flattening the commits (--no-commit and --squash)
#
# usage: git mer <name>
#
# recommended aliases:
#   * gm='git mer'
#   * gmd='git mer dev'
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

# if no branch name
if [[ $# -eq 0 ]]; then
  abort 'fatal: branch name required'
fi

# if the branch does not exists
if [[ -z `git branch --no-color | grep "$1$"` ]]; then
  abort "fatal: no branch '$1'"
fi

# if modified files
if [[ -n `git ls-files --modified --exclude-standard` ]]; then
  abort 'abort: there are modified files'
fi

# if staged files
if [[ -n `git diff --cached --name-only` ]]; then
  abort 'abort: there are staged files'
fi

# test if the merge generates an error
git merge --no-commit --no-ff "$1" >/dev/null 2>&1
code=$?
# revert
git merge --abort 2>/dev/null
# if no merge error
if [[ $code -eq 0 ]]; then
  # if up-to-date
  if [[ `git merge --no-commit --no-ff "$1" 2>/dev/null | grep -ci '^already up-to-date'` -ne 0 ]]; then
    abort "abort: nothing to merge from branch '$1'"
  fi
  # revert the up-to-date test
  git merge --abort 2>/dev/null
  # merge
  git merge --squash --no-commit "$1"
  exit 0
fi

# merge error detected, overwrite files one by one to bypass the conflict

# the last sha on the branch $1
sha=`git log -n 1 --pretty=format:"%h" "$1" --`
# the current branch name
cur=`git rev-parse --abbrev-ref HEAD`
# move to the git root
cwd=`pwd`
cd "`git rev-parse --show-toplevel`"
# list modified files from the current branch and $1
while read path; do
  # merge each modified file
  git checkout "$sha" "$path"
done < <(git diff --name-only "$cur".."$1")
# back to the previous `pwd`
cd "$cwd"
