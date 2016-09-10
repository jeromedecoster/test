#
# Write colored output
#

ok() {
  echo -e "\e[30;48;5;82m\e[38;5;16m  ok  \e[0m $1"
}
info() {
  echo -e "\e[30;48;5;39m\e[38;5;16m info \e[0m $1"
}
warn() {
  echo -e "\e[30;48;5;202m\e[38;5;15m warn \e[0m $1"
}
fail() {
  echo -e "\e[30;48;5;196m\e[38;5;15m fail \e[0m $1"
}

#
# Ask for sudo access if not already available
# Note: use `sudo -k` to loose sudo access
#

check_sudo() {
  # without sudo access return nothing
  check() {
    sudo -n uptime 2>/dev/null
  }
  # sudo prompt if needed
  if [[ -z `check` ]]; then
    info 'check sudo...'
    sudo echo >/dev/null
    # one more check if the user abort or fail the password question
    [[ -z `check` ]] && fail 'sudo access required' && exit 1
  else
    ok 'sudo access granted'
  fi
  unset -f check
}

#
# Download, untar, copy the files
#

download_extract() {
  local tmp=/tmp/dots
  local lib=/usr/local/lib/dots
  rm -fr $tmp
  mkdir -p $tmp
  cd $tmp
  wget -qO- https://github.com/jeromedecoster/test/archive/master.tar.gz | tar xz --strip 1
  sudo rm -fr $lib
  sudo cp -R $tmp $lib
  sudo chown -R `whoami` $lib
  rm -fr $tmp
  if [[ -d $lib/bin ]]; then
    ok 'download and extract done'
  else
    fail 'download and extract error'
  fi
}

#
# Symlinks executables
#

link_bin() {
  local src=/usr/local/lib/dots/bin
  local dst=/usr/local/bin
  local cnt=0
  while read file; do
    sudo rm -f $dst/$file
    sudo ln -s $src/$file $dst/$file
    cnt=$((cnt + 1))
  done < <(ls -1 $src)
  if test $cnt != 0; then
    ok "$cnt executable files linked"
  else
    warn "no executables files linked"
  fi
}

#
# Symlinks user files
#

link_user() {
  local src=/usr/local/lib/dots/user
  local cnt=0
  while read file; do
    if [[ -L ~/$file || ! -f ~/$file ]]; then
      rm -f ~/$file
      ln -s $src/$file ~/$file
      cnt=$((cnt + 1))
    else
      info "$file already exists, linking skipped"
    fi
  done < <(ls -A1 $src)
  if test $cnt != 0; then
    ok "$cnt user files linked"
  else
    warn "no user files linked"
  fi
  # if the source line is commented, the following tests unfortunately failed
  local dot=`cat ~/.bashrc | grep -c ". ~/.bash_profile"`
  local src=`cat ~/.bashrc | grep -c "source ~/.bash_profile"`
  if test $dot == 0 && test $src == 0; then
    echo "source ~/.bash_profile" >> ~/.bashrc
    ok "source ~/.bash_profile added"
  fi
}

#
# Run this script
#

check_sudo
download_extract
link_bin
link_user
exit 0