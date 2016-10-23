
abort() {
  echo "$1" >&2
  exit 1
}

usage() {
  echo 'usage: secret enc <file|directory> [directory]' >&2
  echo '       secret dec <file> [directory]' >&2
  exit 1
}

check() {
  if [[ -z `file -b "$1" | grep -i "^gpg.*encrypted data"` ]]; then
    abort "fail: not a gpg encrypted file"
  fi
}

pass() {
  echo -n 'passphrase: '
  read phrase
  if [[ -z $phrase ]]; then
    pass
  fi
}

ask() {
  while true; do
    echo -n -e 'overwrite? [Yn]: '
    read reply
    reply=`echo "$reply" | tr '[A-Z]' '[a-z]'`
    case "$reply" in
      y|n) break ;;
       '') reply='y' && break ;;
    esac
  done
}

compress() {
  tmp=`mktemp -d /tmp/secret.XXXXX`
  tar cf $tmp/secret.tar "$@"
  cd $tmp
  gzip -c -9 secret.tar > secret.tar.gz
  echo "$phrase" | gpg --cipher-algo AES256 --batch --no-tty --passphrase-fd 0 --yes --symmetric secret.tar.gz
  reply='y'
  if [[ -f "$dest/$name" ]]; then
    ask
  fi
  if [[ $reply == 'y' ]]; then
    cp --force secret.tar.gz.gpg "$dest/$name"
  fi
  cd "$cwd"
  rm -fr $tmp
}

decompress() {
  tmp=`mktemp -d /tmp/secret.XXXXX`
  local base=`basename "$1"`
  cp "$1" "$tmp/$base"
  cd $tmp
  local name=${base%.*}
  echo "$phrase" | gpg --quiet --batch --no-tty --passphrase-fd 0 --yes --decrypt "$base" 2>/dev/null >"$name"
  local code=$?
  if [[ $code -ne 0 ]]; then
    abort "fail: gpg decrypt error"
  fi
  mkdir untar
  tar xfz "$name" -C untar
  local found=0
  while read f; do
    if [[ -f "$dest/$f" ]]; then
      found=1
    fi
  done < <(ls -1 untar/)
  reply='y'
  if [[ $found -eq 1 ]]; then
    ask
  fi
  if [[ $reply == 'y' ]]; then
    cp --force -r untar/* "$dest"
  fi
  cd "$cwd"
  rm -fr $tmp
}

cwd=`pwd`
dest=`pwd`

if [[ $# -lt 2 ]]; then
  usage
fi

if [[ $# -gt 2 ]]; then
   if [[ -d "$3" ]]; then
     dest=`realpath "$3"`
   else
     usage 
   fi
fi

if [[ "$1" == 'enc' ]]; then
    if [[ -f "$2" ]]; then
        name="$2.tar.gz.gpg"
        pass
        compress "$2"
        exit 0
    fi

    if [[ -d "$2" ]]; then
        cd "$2"
        name=${PWD##*/}.tar.gz.gpg
        pass
        compress *
        exit 0
    fi
fi

if [[ "$1" == 'dec' && -f "$2" ]]; then
    check "$2"
    pass
    decompress "$2"
    exit 0
fi

usage
