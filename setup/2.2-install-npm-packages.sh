# source the script utils one directory above
. `dirname "${BASH_SOURCE[0]}"`/../common.sh

#
# Install some global npm packages
#

install_npm_packages() {
  func 'install_npm_packages'
  PATH+=":$HOME/n/bin"
  local names=(
    http-server
    jeromedecoster/down
    opn-cli
  )
  for name in ${names[@]}; do
    info "npm install -g \e[97;1m$name\e[0m"
    npm i -g "$name"
  done
  unset -f install_npm_packages
}

#
# Run this script
#

install_npm_packages
