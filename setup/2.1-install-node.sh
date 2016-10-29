# source the script utils one directory above
. `dirname "${BASH_SOURCE[0]}"`/../common.sh

#
# Install node with n
# Note: to uninstall n and node `n-uninstall -y`
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
