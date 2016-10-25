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
warn() {
  echo -e "\e[30;48;5;202m\e[38;5;15m warn \e[0m $1"
}
fail() {
  echo -e "\e[30;48;5;196m\e[38;5;15m fail \e[0m $1"
}
path() {
  if [[ "$1" = '/' ]]; then
    echo -ne "\e[34;1m/\e[0m"
  else 
    local name=`basename "$1"`
    local dirs=${1%$name}
    if [[ "$dirs" = ~/ ]]; then
      echo -n "~/"
    else
      echo -n "$dirs"
    fi
    # write directory name in bold blue
    if [[ -d "$1" ]]; then
      echo -ne "\e[34;1m$name\e[0m/"
    # write symlink name in bold cyan
    elif [[ -L "$1" ]]; then
      echo -ne "\e[36;1m$name\e[0m"
    # write executable name in bold green
    elif [[ -x "$1" ]]; then
      echo -ne "\e[32;1m$name\e[0m"
    # write other name in bold white
    else
      echo -ne "\e[97;1m$name\e[0m"
    fi
  fi
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
# Download, untar, copy the files
#

download_extract() {
  func 'download_extract'
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
  local dir=/usr/local/lib/dots/setup/
  while read file; do
    # execute the file via source `. $file` instead of `bash $file`
    # so the variables and functions declared in this main file are available in the sourced files
    # also, it is important to unset variables and functions declared in the sourced files to not
    # have global pollution
    . "$dir/$file"
  # only catch the files who starts with a number (for easy deactivation) and finish with .sh
  done < <(ls -1 "$dir" | grep ^[0-9] | grep '\.sh$')
}

#
# Run this script
#

check_sudo
download_extract
setup
exit 0
