#
# Symlink executables
#

symlink_bin() {
  local src=/usr/local/lib/dots/bin
  local dest=/usr/local/bin
  local cnt=0
  while read file; do
    # must be an executable
    if [[ -x "$src/$file" ]]; then
      # the filename without the extension .sh
      local noext=${file%.sh}
      sudo rm -f $dest/$noext
      sudo ln -s $src/$file $dest/$noext
      cnt=$((cnt + 1))
      ok "symlink $src/$file to $dest/$noext"
    fi
  # only catch the .sh files
  done < <(ls -1 $src | grep '\.sh$')
  if [[ $cnt -eq 0 ]]; then
    warn "no executables files symlinked"
  fi
  unset -f link_bin
}

#
# Run this script
#

symlink_bin
