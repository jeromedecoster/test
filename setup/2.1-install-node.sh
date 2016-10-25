#
# Install node with n
#

install_node() {
  func 'install_node'
  # n is already installed
  if [[ -n `which n` ]]; then
    # install the latest node version available
    n latest
  else
    # install n and the latest version of node
    /usr/bin/curl -L http://git.io/n-install | bash -s -- -y latest
  fi
  unset -f install_node
}

#
# Run this script
#

install_node
