# source the script utils one directory above
. `dirname "${BASH_SOURCE[0]}"`/../common.sh

#
# Setup some files and directories
#

documents() {
  func 'documents'
  local desk=`xdg-user-dir DESKTOP`
  local docs=`xdg-user-dir DOCUMENTS`
  # WORK
  mkdir -p "$docs/WORK"
  rm -f "$desk/WORK"
  ln -s "$docs/WORK" "$desk/WORK"
  ok "symlink `path $docs/WORK` ➜ `path $desk/WORK`"
  # down.urls
  touch "$docs/down.urls"
  rm -f "$desk/down.urls"
  ln -s "$docs/down.urls" "$desk/down.urls"
  ok "symlink `path $docs/down.urls` ➜ `path $desk/down.urls`"
  unset -f documents
}

#
# Run this script
#

documents
