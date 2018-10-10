# My .bashrc, collated and curated over many years
# Needs a tidy up!
 
#### Colours
COLOUR_RED="\033[0;31m"
COLOUR_YELLOW="\033[0;33m"
COLOUR_GREEN="\033[0;32m"
COLOUR_OCHRE="\033[38;5;95m"
COLOUR_BLUE="\033[0;34m"
COLOUR_WHITE="\033[0;37m"
COLOUR_RESET="\033[0m"

#### Eternal bash history
if [ ! -f ~/.bash_eternal_history ]; then
	mv ~/.bash_history ~/.bash_eternal_history
fi
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignoreboth
export HISTTIMEFORMAT="[%F %T] "
# Append to the history file, don't overwrite it
shopt -s histappend
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
export HISTFILE=~/.bash_eternal_history

#### Presenting mode - act a certain way if presenting/demoing
function pres(){
	case $1 in
		on)
			touch $HOME/.pres
			;;
		off)
			rm $HOME/.pres
			;;
		*)
			exit 1
			;;
	esac
	clear
	source $HOME/.bashrc
}
if [ -f $HOME/.pres ]; then
	PRESENTING_MODE=true
else
	PRESENTING_MODE=false
fi

#### Helpful git aliases and functions
function git_color {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOUR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOUR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOUR_GREEN
  else
    echo -e $COLOUR_OCHRE
  fi
}
function git_branch {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo -n "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo -n "($commit)"
	fi
	git status > /dev/null 2>&1 && echo -e " $COLOUR_WHITE$(git config user.email) ($(git config user.signingkey))"
}
if [ "$PRESENTING_MODE" = "true" ]; then
	PS1="\W ols $ "
	export PS1
else
	PS1="\[$COLOUR_WHITE\]\w "          # basename of pwd
	PS1+="\[\$(git_color)\]"        # colors git status
	PS1+="\$(git_branch) "           # prints current branch
	PS1+="\n\A \[$COLOUR_BLUE\]\$\[$COLOUR_RESET\] "   # '#' for root, else '$'
	export PS1
fi
alias gco="git checkout"
alias gcb="git checkout -b"
alias gpsup="git push --set-upstream origin $(git_branch | tr -d '()')"
alias gitper="echo -n 'Was ' && git config user.email && git config user.signingkey && git config --global user.email 'oliver@leaversmith.com' && git config --global user.signingkey 16503BFB && echo -n 'Now ' && git config user.email && git config user.signingkey"

#### Path things
export GOPATH=~/repos
export PATH=$PATH:$GOBIN

#### General aliases
alias ll="ls -l"
alias lg="ls -l | grep -i"
alias d="friendlycd"
alias tabred='echo -en "\033]6;1;bg;*;default\a\033]6;1;bg;red;brightness;255\a"'
alias tabgreen='echo -en "\033]6;1;bg;*;default\a\033]6;1;bg;green;brightness;255\a"'
alias tabreset='echo -en "\033]6;1;bg;*;default\a"'

#### General functions
function g(){
	grep -rin --color=auto --exclude-dir='.git' --exclude-dir='.kitchen' "$@"
}

function friendlycd(){
	# mkdir and cd in one fell swoop
	mkdir -p "$1"
	cd "$1"
}

function myip(){
	# Print private and public IP
	echo "$(ifconfig | sed -n '/.inet /{s///;s/ .*//;p;}' | grep -v ^127)/$(curl -s icanhazip.com)"
}

function ql () {
	(qlmanage -p "$@" > /dev/null 2>&1 &
	local ql_pid=$!
	read -sn 1
	kill ${ql_pid}) > /dev/null 2>&1
}

function qlt () {
	(qlmanage -p -c public.plain-text "$@" > /dev/null 2>&1 &
	local ql_pid=$!
	read -sn 1
	kill ${ql_pid}) > /dev/null 2>&1
}
function tabtitle {
	# Set tabtitle to $*
	echo -ne "\033]0;"$*"\007"
}
# Load additional bashisms for work-specific stuff that I can't show you here
if [[ "$USER" = "[redacted]" ]] ; then source $HOME/work.bash ; fi

# Load spotify bash functions
source $HOME/spotify.bash

#### Startup
# Reset tab colour for when you open a tab from a coloured tab
tabreset
# = to sort font size if needed
if [ "$PRESENTING_MODE" = "true" ]; then
	cat .pres_mode_ascii
	echo "Here is some text, look how texty it is"
	echo "Coming up is 80 characters!"
	echo "$(for i in {1..80} ; do echo -n o ; done)"
	echo "Increase font size until this looks good"
else
	# internetonfire check
	RESPONSE=$(dig +short txt istheinternetonfire.com | sed -e 's/\\; /\n/' -e 's/"//'g  -e 's/"//'g -e 's/  / /g' -e 's/\n/ /g')
	YELLOW='\033[1;33m'
	RED='\033[0;31m'
	NC='\033[0m'
	echo -e "${YELLOW}Is the Internet on fire?${RED} $RESPONSE${NC}\n"
fi
