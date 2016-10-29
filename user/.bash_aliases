# shell
alias ..='cd ..'
alias ...='cd ../..'

# apt
alias agu='sudo apt-get update && sudo apt-get upgrade -y --allow-unauthenticated && sudo apt-get autoclean -y'
alias agi='sudo apt-get install -y'
alias agl='apt list --installed'

# git
alias gs='git status'
alias gl="git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
alias gpom='git push origin master'

# git extras
alias ga='git all'
alias gb='git bra'
alias gbd='git bra dev'
alias gbm='git bra master'
alias gbrd='git bra -r dev'
alias gc='git com'
alias gcm='git com -m'
alias gcp='git com -p'

# npm
alias ni='npm install'
alias nid='npm install --save'
alias nidd='npm install --save-dev'
alias nr='npm run-script'
alias ns='npm start'
alias nt='npm test'

# npm packages
alias srv='http-server -p 3000 -o'