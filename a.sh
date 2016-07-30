#
# Write colored output
#

red() {
  echo -e "\033[0;31m$1\033[0m"
}
cyan() {
  echo -e "\033[0;36m$1\033[0m"
}

#
# Abort with an exit message
#

abort() {
  echo "`red abort:` $1"
  # ring
  echo -en "\007"
  exit 1
}

#
# Ask for sudo access if not already available
# Note: use `sudo -k` to loose sudo access
#

check_sudo() {
  echo "check `cyan sudo`..."
  # without sudo access return nothing
  if [[ -z `sudo -n uptime 2>/dev/null` ]]; then
    # sudo prompt
    sudo echo >/dev/null
  fi
  # one more check if the user abort the password question
  [[ -z `sudo -n uptime 2>/dev/null` ]] && abort 'sudo required'
}

install() {
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get install curl unrar git ffmpeg -y
}

#
# Run this script
#

check_sudo
install
