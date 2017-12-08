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

if which nvim > /dev/null 2>&1; then export EDITOR=nvim; else export EDITOR=vim; fi

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

unset color_prompt force_color_prompt

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
alias ls='ls -G'
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


if [ $HOSTNAME == REMMAC72X7FVH6 ]; then
  DISPLAY_HOSTNAME=''
else
  DISPLAY_HOSTNAME='\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\]'
fi



PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u'$DISPLAY_HOSTNAME'\[\033[01;31m\]$(git branch 2>/dev/null|grep -e ^* | tr "*" ":" | tr -d " ")\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]> '
alias prod="mysql prod -ulc -plc"
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


# make ctrl-s not go into a freeze
stty ixany
stty ixoff -ixon

# meta-arrows to navigate inline
bind '"\el": forward-word'
bind '"\eh": backward-word'
bind '"\ek": forward-char'
bind '"\ej": backward-char'


export PYTHONPATH=$PYTHONPATH:~/personal_config/pythonlib
alias vim="vim -X"
if [ $(hostname) == REMMAC72X7FVH6 ]; then
  source ~/bin/.bashrc_mac
fi
