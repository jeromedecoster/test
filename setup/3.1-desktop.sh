# source the script utils one directory above
. `dirname "${BASH_SOURCE[0]}"`/../common.sh

#
# Setup the desktop
#

desktop() {
  func 'desktop'
  local src=/usr/local/lib/dots/desktop
  local desk=`xdg-user-dir DESKTOP`
  # launchers
  while read file; do
    cp $src/$file $desk/$file
    ok "copy `path $src/$file` ➜ `path $desk/$file`"
  done < <(ls -1 $src)
  # downloads
  local down=`xdg-user-dir DOWNLOAD`
  local name=`basename "$down"`
  rm -f "$desk/$name"
  ln -s "$down" "$desk/$name"
  ok "symlink `path $down` ➜ `path $desk/$name`"
  # single-click to launch
  xfconf-query -c xfce4-desktop -p /desktop-icons/single-click -s false
  unset -f desktop
}

#
# Run this script
#

desktop
