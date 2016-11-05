#
# Write colored output
# Note: colors from http://misc.flogisoft.com/bash/tip_colors_and_formatting
#

func() {
  echo -e "\e[30;48;5;241m\e[38;5;15m func \e[0m execute \e[97;1m$1\e[0m"
}
ok() {
  echo -e "\e[30;48;5;40m\e[38;5;15m  ok  \e[0m $1"
}
info() {
  echo -e "\e[30;48;5;32m\e[38;5;15m info \e[0m $1"
}
fail() {
  echo -e "\e[30;48;5;196m\e[38;5;15m fail \e[0m $1"
}

#
# Ask for sudo access if not already available
# Note: use `sudo -k` to loose sudo access
#

check_sudo() {
  func 'check_sudo'
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
# Local install
#

local_install() {
  func 'local_install'
  local lib=/usr/local/lib/dots
  local dir=`realpath $(dirname "${BASH_SOURCE[0]}")`/
  local cwd=`pwd`
  sudo rm -fr $lib
  sudo mkdir -p $lib
  cd "$dir"
  while read file; do
    sudo cp -R $file $lib
  done < <( find * -maxdepth 0 -type d && ls -1 "$dir" | grep '\.sh$')
  sudo chown -R `whoami` $lib
  cd "$cwd"
}

#
# Download, untar, copy the files
#

download_extract() {
  func 'download_extract'
  local tmp=/tmp/dots
  local lib=/usr/local/lib/dots
  local cwd=`pwd`
  rm -fr $tmp
  mkdir -p $tmp
  cd $tmp
  wget -qO- https://github.com/jeromedecoster/test/archive/master.tar.gz | tar xz --strip 1
  sudo rm -fr $lib
  sudo cp -R $tmp $lib
  sudo chown -R `whoami` $lib
  rm -fr $tmp
  # return to the previous directory to avoid the following error
  # sh: 0: getcwd() failed: No such file or directory
  cd "$cwd"
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
  local dir=/usr/local/lib/dots/setup/
  while read file; do
    bash "$dir/$file"
  # only catch the files who starts with a number (for easy deactivation) and finish with .sh
  done < <(ls -1 "$dir" | grep ^[0-9] | grep '\.sh$')
}

#
# Run this script
#

check_sudo
#local_install
download_extract
setup
# secret
exit 0
