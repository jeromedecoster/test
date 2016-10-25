#
# Install or update softwares with apt
#

install_with_apt() {
  func 'install_with_apt'
  sudo apt-get update
  sudo apt-get upgrade -y
  local names=(
    atom
    cdcat
    chromium-browser
    curl
    docker.io
    exfat-fuse
    exfat-utils
    gedit
    git
    synapse
    unetbootin
    unetbootin-translations
    unrar
    virtualbox
    vlc
  )
  for name in ${names[@]}; do
    info "apt-get install \e[97;1m$name\e[0m"
    sudo apt-get install -y "$name"
  done
  sudo apt-get autoclean -y
  unset -f install_with_apt
}

#
# Run this script
#

install_with_apt
