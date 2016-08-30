#
# Write colored output
#

yellow() {
  echo -e "\e[38;5;226m$1\e[0m"
}
red() {
  echo -e "\e[38;5;196m$1\e[0m"
}
cyan() {
  echo -e "\e[38;5;87m$1\e[0m"
}
magenta() {
  echo -e "\e[38;5;201m$1\e[0m"
}
green() {
  echo -e "\e[38;5;82m$1\e[0m"
}
white() {
  echo -e "\e[38;5;15m$1\e[0m"
}
black() {
  echo -e "\e[38;5;16m$1\e[0m"
}
grey() {
  echo -e "\e[38;5;242m$1\e[0m"
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

install()
  # sudo is required for each line
  sudo apt-get update
  # sudo apt-get autoremove -y
  sudo apt-get upgrade -y
  sudo apt-get install -y curl unrar git ffmpeg vim
  sudo apt-get autoclean -y
}

# sudo rm /var/lib/dpkg/lock
# sudo rm /var/cache/apt/archives/lock

#
# Run this script
#

check_sudo
install
