
#
# Prompt
#

# exit code of previous command
prompt_exitcode() {
  if [[ $1 != 0 ]]; then
    local RED='\033[0;31m'
    local RES='\033[0m'
    echo " ${RED}($1)\[${RES}\]"
  fi
}

prompt() {
  local exit_code=$?
  PS1=""
  PS1="$PS1`prompt_exitcode "$exit_code"`"
  PS1="$PS1\n$ "
}

PROMPT_COMMAND=prompt

#
# Aliases
#

alias ..='cd ..'
alias ...='cd ../..'
# apt
alias agu='sudo apt-get update && sudo apt-get upgrade -y --allow-unauthenticated && sudo apt-get autoclean -y'
alias agi='sudo apt-get install -y'
# git
alias ga='git add'
alias gs='git status'
alias gc='git commit -m'
alias gl="git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
alias gpom='git push origin master'
alias gb='git b'
alias gbd='git b -d'
alias gco='git co'
# npm
alias ni='npm install'
alias nid='npm install --save'
alias nidd='npm install --save-dev'
alias nr='npm run-script'
alias ns='npm start'
alias nt='npm test'
