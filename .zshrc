# zsh configuration
DEFAULT_USER="joey"
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="agnoster"
plugins=(git archlinux npm bundler rbates adb bower docker)

source $ZSH/oh-my-zsh.sh
source $ZSH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSH/zsh-syntax-highlighting-filetypes/zsh-syntax-highlighting-filetypes.zsh

setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

# terminal configuration
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

export TERM=xterm-256color
eval $(dircolors -b $HOME/.dircolors)

## keychain is great! (ssh key agent)
# eval $(keychain --eval --agents ssh -Q --quiet $(cat ~/.keylist))

# variables

source /usr/share/nvm/init-nvm.sh

## programming
export EDITOR="vim"

## virtualenvs
export WORKON_HOME=~/.venv

## misc
export GOPATH=~/.go
export PATH=~/.go/bin:$PATH
export PATH=~/.bin:$PATH
export PATH=~/.cabal/bin:$PATH
export PATH=/usr/lib/ccache/bin:$PATH

### java application window fix (xmonad)
export _JAVA_AWT_WM_NONREPARENTING=1 

### steam window backgrounding fix (xmonad)
export STEAM_FRAME_FORCE_CLOSE=1

### private variables mostly for unique PATH and such
if [ -f ~/.variables ]; then
  source ~/.variables
fi

# aliases

## gulp es6 for testing fix
alias gulp='node --harmony `which gulp`'

## arch things
if [ -f /etc/arch-release ]; then
  alias python=python2
  alias pip=pip2
fi

## private aliases mostly for workdir shortcuts
if [ -f ~/.aliases ]; then
  source ~/.aliases
fi

## raspberry pi ttl alias
alias rpi='sudo screen /dev/ttyUSB0 115200'

## woops typed vi! alias
alias vi='vim'

## always fill in all mkdir's
alias mkdir='mkdir -p'

## et lul
alias damn-wifi='sudo ip link set dev wlp2s0 down && sudo wifi-menu'
alias dog='cat'
alias please='sudo'
alias such='git'
alias very='git'
alias wow='git status --ignore-submodules=dirty' #-> actually really useful!
alias gg='sudo shutdown now'

# functions
## compress a file or folder
ac() {
  case "$1" in
    tar.bz2|.tar.bz2) tar cvjf "${2%%/}.tar.bz2" "${2%%/}/" ;;
    tbz2|.tbz2) tar cvjf "${2%%/}.tbz2" "${2%%/}/" ;;
    tbz|.tbz) tar cvjf "${2%%/}.tbz" "${2%%/}/" ;;
    tar.xz) tar cvJf "${2%%/}.tar.gz" "${2%%/}/" ;;
    tar.gz|.tar.gz) tar cvzf "${2%%/}.tar.gz" "${2%%/}/" ;;
    tgz|.tgz) tar cvjf "${2%%/}.tgz" "${2%%/}/" ;;
    tar|.tar) tar cvf "${2%%/}.tar" "${2%%/}/" ;;
    rar|.rar) rar a "${2}.rar" "$2" ;;
    zip|.zip) zip -9 "${2}.zip" "$2" ;;
    7z|.7z) 7z a "${2}.7z" "$2" ;;
    lzo|.lzo) lzop -v "$2" ;;
    gz|.gz) gzip -v "$2" ;;
    bz2|.bz2) bzip2 -v "$2" ;;
    xz|.xz) xz -v "$2" ;;
    lzma|.lzma) lzma -v "$2" ;;
    *)  echo "ac(): compress a file or directory."
        echo "Usage: ac <archive type> <filename>"
        echo "Example: ac tar.bz2 PKGBUILD"
        echo "Please specify archive type and source."
        echo "Valid archive types are:"
        echo "tar.bz2, tar.gz, tar.gz, tar, bz2, gz, tbz2, tbz,"
        echo "tgz, lzo, rar, zip, 7z, xz and lzma." ;;
    esac
}
## decompress archive (to directory $2 if wished for and possible)
ad() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2|*.tgz|*.tbz2|*.tbz) mkdir -v "$2" 2>/dev/null ; tar xvjf "$1" -C "$2" ;;
      *.tar.gz) mkdir -v "$2" 2>/dev/null ; tar xvzf "$1" -C "$2" ;;
      *.tar.xz) mkdir -v "$2" 2>/dev/null ; tar xvJf "$1" ;;
      *.tar) mkdir -v "$2" 2>/dev/null ; tar xvf "$1" -C "$2" ;;
      *.rar) mkdir -v "$2" 2>/dev/null ; 7z x "$1" "$2" ;;
      *.zip) mkdir -v "$2" 2>/dev/null ; unzip "$1" -d "$2" ;;
      *.7z) mkdir -v "$2" 2>/dev/null ; 7z x "$1" -o"$2" ;;
      *.lzo) mkdir -v "$2" 2>/dev/null ; lzop -d "$1" -p"$2" ;;
      *.gz) gunzip "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.Z) uncompress "$1" ;;
      *.xz|*.txz|*.lzma|*.tlz) xz -d "$1" ;;
      *)
      esac
    else
      echo "Sorry, '$2' could not be decompressed."
      echo "Usage: ad <archive> <destination>"
      echo "Example: ad PKGBUILD.tar.bz2 ."
      echo "Valid archive types are:"
      echo "tar.bz2, tar.gz, tar.xz, tar, bz2,"
      echo "gz, tbz2, tbz, tgz, lzo,"
      echo "rar, zip, 7z, xz and lzma"
  fi
}

## list content of archive but don't unpack
al() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2|*.tbz2|*.tbz) tar -jtf "$1" ;;
      *.tar.gz) tar -ztf "$1" ;;
      *.tar|*.tgz|*.tar.xz) tar -tf "$1" ;;
      *.gz) gzip -l "$1" ;;
      *.rar) rar vb "$1" ;;
      *.zip) unzip -l "$1" ;;
      *.7z) 7z l "$1" ;;
      *.lzo) lzop -l "$1" ;;
      *.xz|*.txz|*.lzma|*.tlz) xz -l "$1" ;;
      esac
    else
        echo "Sorry, '$1' is not a valid archive."
        echo "Valid archive types are:"
        echo "tar.bz2, tar.gz, tar.xz, tar, gz,"
        echo "tbz2, tbz, tgz, lzo, rar"
        echo "zip, 7z, xz and lzma"
  fi
}
