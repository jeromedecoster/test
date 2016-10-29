. ../common.sh

#
# Symlink user files
#

symlink_user() {
  func 'symlink_user'
  local src=/usr/local/lib/dots/user
  local cnt=0
  while read file; do
    if [[ -L ~/$file || ! -f ~/$file ]]; then
      rm -f ~/$file
      ln -s $src/$file ~/$file
      cnt=$((cnt + 1))
      ok "symlink `path ~/$file` ➜ `path $src/$file`"
    else
      warn "symlink `path ~/$file` skipped, file already exists"
    fi
  done < <(ls -A1 $src)
  if [[ $cnt -eq 0 ]]; then
    warn 'no user files symlinked'
  fi
  # chmod user files as -rw-r-----
  chmod 640 $src/.{bash,git,input}* 2>/dev/null
  unset -f symlink_user
}

#
# Run this script
#

symlink_user
