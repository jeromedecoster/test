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
