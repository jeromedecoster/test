#
# Env vars
#

export DESKTOP=`xdg-user-dir DESKTOP`
export DOCUMENTS=`xdg-user-dir DOCUMENTS`
export DOWNLOADS=`xdg-user-dir DOWNLOAD`
export MUSIC=`xdg-user-dir MUSIC`
export PICTURES=`xdg-user-dir PICTURES`
export VIDEOS=`xdg-user-dir VIDEOS`

#
# Prompt
#

prompt_git() {
  # abort if not inside a git repo
  [[ `git rev-parse --is-inside-work-tree 2>/dev/null` != 'true' ]] && return

  local GRE='\e[38;5;82m'
  local MAG='\e[38;5;201m'
  local RED='\e[38;5;196m'
  local YEL='\e[38;5;226m'
  local RES='\e[0m'

  local branch="${MAG}`git symbolic-ref HEAD 2> /dev/null | sed -e 's/refs\/heads\///'`\[${RES}\]"

  # check for staged, modified or untracked files
  local sta mod unt
  [[ -n `git diff --cached --name-only` ]] && sta=1
  [[ -n `git ls-files --modified --exclude-standard` ]] && mod=1
  [[ -n `git ls-files --others --directory --exclude-standard` ]] && unt=1

  # if no staged, modified or untracked files
  if [[ -z $sta && -z $mod && -z $unt ]]; then
    echo -n " [$branch]"
  # otherwise, more complex prompt with warn
  else
    local warn
    [[ -n $sta ]] && warn="${GRE}sta\[${RES}\]"
    [[ -n $mod ]] && warn="${warn}-${RED}mod\[${RES}\]"
    [[ -n $unt ]] && warn="${warn}-${YEL}unt\[${RES}\]"
    # if warn starts with a dash, remove it
    [[ ${warn:0:1} == "-" ]] && warn=${warn:1}
    echo -n " [$branch:$warn]"
  fi
}

# the current directory path displayed in the advanced prompt
prompt_path() {
  local tmp inside
  local CYA='\e[38;5;87m'
  local RES='\e[0m'

  # pwd is ~
  if [[ $PWD == $HOME ]]; then
    echo "[${CYA}~\[${RES}\]]" && return
  elif [[ $PWD == '/' ]]; then
    echo "[${CYA}/\[${RES}\]]" && return
  # pwd is inside ~
  elif [[ $HOME == ${PWD:0:${#HOME}} ]]; then
    inside=1
    tmp="~${PWD:${#HOME}}"
  else
    # remove first /
    tmp=${PWD:1}
  fi

  # '$' must be escaped
  tmp=$(echo "$tmp" | sed -e 's/\$/\\\\$/g')

  local ti=$IFS
  IFS='/'
  local arr=($tmp)
  IFS=$ti

  local lng=${#arr[@]}
  local path
  if [[ -n $inside ]]; then
    [[ $lng -le 3 ]] && path=$tmp || path="~/../${arr[$lng - 2]}/${arr[$lng - 1]}"
  else
    [[ $lng -le 3 ]] && path=/$tmp || path="/${arr[0]}/../${arr[$lng - 2]}/${arr[$lng - 1]}"
  fi

  echo "[${CYA}$path\[${RES}\]]"
}

# exit code of previous command
prompt_exitcode() {
  if [[ $1 != 0 ]]; then
    local RED='\e[38;5;196m'
    local RES='\e[0m'
    echo " ${RED}($1)\[${RES}\]"
  fi
}

prompt() {
  local exit_code=$?
  PS1=""
  PS1="$PS1`prompt_path`"
  PS1="$PS1`prompt_git`"
  PS1="$PS1`prompt_exitcode "$exit_code"`"
  PS1="$PS1\n$ "
}

PROMPT_COMMAND=prompt
