#
# Write colored output
#

ok() {
  echo -e "\e[30;48;5;40m\e[38;5;15m  ok  \e[0m $1"
}
info() {
  echo -e "\e[30;48;5;32m\e[38;5;15m info \e[0m $1"
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
  if [[ -z `has_sudo` ]]; then
    info 'ask sudo...'
    sudo echo >/dev/null
    # one more check if the user abort or fail the password question
    if [[ -z `has_sudo` ]]; then
      fail 'sudo access required'
      exit 1
    fi
  else
    ok 'sudo access granted'
  fi
}

# without sudo access return nothing
has_sudo() {
  sudo -n uptime 2>/dev/null
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
  if [[ -d $lib/setup ]]; then
    ok 'download and extract done'
  else
    fail 'download and extract error'
    exit 1
  fi
}

#
# Execute all the files in the /usr/local/lib/dots/setup directory
# Note: the files are executed in the alphanumeric order
#

setup() {
  for file in /usr/local/lib/dots/setup/*; do
    . "$file"
  done
}

#
# Run this script
#

check_sudo
#download_extract
setup
exit 0
