# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi



export PYTHONSTARTUP=~/.pythonrc



PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\]\[\033[01;31m\]$(git branch 2>/dev/null|grep -e ^* | tr "*" ":" | tr -d " ")\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]> ' 
alias prod="mysql prod -ulc -plc"
if [ $(hostname) != eyal-ubuntu ]; then
  source /opt/intel/composer_xe_2011_sp1.9.293/bin/compilervars.sh intel64
  source /opt/intel/composer_xe_2011_sp1.9.293/mkl/bin/mklvars.sh intel64
fi
go() {
  rootdir=$(git rev-parse --show-toplevel)
  if [[ ! -z $rootdir ]]; then
    f=$(cd $rootdir && git ls-files | grep $1 | head -1)
    if [[ -z $f ]] ; then
      echo "No such file or directory: $1"
    else
      echo "Going to $f"
      cd $rootdir/$(dirname $f)
    fi
  fi
}

PATH=$PATH:/home/eyal/bin
alias hailfire="ssh hailfire -L *:9090:localhost:8888 -t 'screen -x vim'"
alias staging="ssh staging -t 'screen -x vim'"
alias fibi="ssh fibi -t 'screen -x vim'"
alias cellcom="ssh cellcom -L *:9090:localhost:8888 -t 'screen -x vim'"
alias MOH="ssh MOH -L *:9090:localhost:8888 -t 'screen -x vim'"
alias iego="ssh_to iego -L 9090:localhost:18888 -L *:8000:localhost:80 -L *:4433:localhost:443 'screen -x vim || screen -S vim'"

# michael's scripts - ssh like a king
alias ssh_to='ssh -t -X -o ProxyCommand="ssh -q kamino /home/michaelm/bin/nc_to %h"'
alias tunnel_to='ssh -X -o ProxyCommand="ssh -q kamino /home/michaelm/bin/nc_to %h" -L443:localhost:443 -L80:localhost:80'
copy_id_to() { cat ~/.ssh/id_dsa.pub | ssh_to $@ "cat >> .ssh/authorized_keys"; }
alias scp_to='scp -o ProxyCommand="ssh -q kamino /home/michaelm/bin/nc_to %h"'
alias scp_from=scp_to

if [ $(hostname) = eyal-ubuntu ]; then
  complete -W "$(ssh kamino 'cat /public/production/installations.csv' | cut -d , -f 1 | tail -n +2)" ssh_to nc_to
  complete -W "$(ssh kamino 'cat /public/production/installations.csv' | cut -d , -f 1 | tail -n +2)" tunnel_to nc_to
fi

alias install_janus="curl -Lo- https://bit.ly/janus-bootstrap | bash"
