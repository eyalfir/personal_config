export LC_ALL=en_US.UTF-8
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug "plugins/git",   from:oh-my-zsh
zplug "plugins/pip",   from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-history-substring-search"
#zplug "avivl/gcloud-project", use:init.sh
zplug load

PATH=/usr/local/bin:$PATH:~/bin:~/personal_config/bin
source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
if which nvim > /dev/null 2>&1; then export EDITOR=nvim; else export EDITOR=vim; fi

# some more ls aliases
alias ls='ls -G'
alias ll='ls -alF'
alias vim='nvim'
alias dc='docker-compose'
alias proj='source ~/bin/project_switch'

export PYTHONSTARTUP=~/.pythonrc

bindkey -e
# meta-arrows to navigate inline
bindkey "\el" forward-word
bindkey "\eh" backward-word
bindkey "\ek" forward-char
bindkey "\ej" backward-char
bindkey "^[[1;3C" forward-word       
bindkey "^[[1;3D" backward-word      
bindkey "^[[3~" delete-char          

# C-X C-E to edit in vim
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line
bindkey '^xe' edit-command-line

# alt - # to jump to argument
bindkey '^[1' beginning-of-line
bindkey -s '^[2' '^A^[f'
bindkey -s '^[3' '^A^[f^[f'
bindkey -s '^[4' '^A^[f^[f^[f'
bindkey -s '^[5' '^A^[f^[f^[f^[f'
bindkey -s '^[6' '^A^[f^[f^[f^[f^[f'
bindkey -s '^[7' '^A^[f^[f^[f^[f^[f^[f'
bindkey -s '^[8' '^A^[f^[f^[f^[f^[f^[f^[f'
bindkey -s '^[9' '^A^[f^[f^[f^[f^[f^[f^[f^[f'

source /usr/local/Cellar/fzf/0.17.5/shell/completion.zsh
source /usr/local/Cellar/fzf/0.17.5/shell/key-bindings.zsh

function internal_ip() {
	ifconfig | grep 'inet 10' | sed 's/^.*\(10\.[^ ]*\).*$/\1/' | head -1
}
function cd() {
	entry_key=$(tmux list-panes -F '#{pid};#{pane_pid};#{pane_active}' | grep '1$' | sed 's/;1$//')
	[[ -f /tmp/panes_directories ]] && sed -i.bak "/$entry_key/d" /tmp/panes_directories
	builtin cd "$@"
	echo $entry_key:$(pwd) >> /tmp/panes_directories
}
cd .


# zsh history
HISTSIZE=50000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=5000000               #Number of history entries to save to disk
#HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS

# Home and End to go to start-end of line
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
bindkey "\e[1;5H" beginning-of-line
bindkey "\e[1;5F" end-of-line
bindkey "\eu" beginning-of-line
bindkey "\eo" end-of-line
bindkey "\ex" delete-char

bindkey -s "^[^E" '^A#^M'

function go_to_personal() {
	window=$(tmux list-windows -F '#{window_index} #{window_name}' | grep 'personal.yml$' | head -1 | cut -d' ' -f 1)
	if [[ -n "$window" ]]; then
	  tmux select-window -t $window
	else
	  tmux new-window -n personal.yml nvim ~/work/personal.yml
	fi
}
bindkey '^P' history-substring-search-up   
bindkey '^N' history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_FUZZY=1

if [[ $(hostname) == "TLVMACQ2DNHV2Q" ]]; then
  source ~/bin/.bashrc_mac
fi

setopt INTERACTIVE_COMMENTS
set -o allexport

#WORDCHARS='*?_-=&!#$%^(){}<>'
WORDCHARS='_'
alias internet='curl --connect-timeout 5 www.google.com > /dev/null 2>&1 && echo "Intenet is up" || echo "Internet is down"'

alias tunnel_to='ssh -X -L 0.0.0.0:3333:localhost:443 -L 0.0.0.0:2222:localhost:80 -o ExitOnForwardFailure=yes $1'
alias master_tunnel='sudo ncat -k -l 0.0.0.0 443 -c "ncat 127.0.0.1 3333"'
alias fb='firebase'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/efirstenberg/work/gcloud/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/efirstenberg/work/gcloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/efirstenberg/work/gcloud/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/efirstenberg/work/gcloud/google-cloud-sdk/completion.zsh.inc'; fi

function notify() {
  osascript -e 'tell Application "Finder" to display dialog "Job finished" '
}
export PATH="/usr/local/opt/python36/bin:$PATH"
alias gcp='gcp_switch'
alias pkc='proxychains4 kubectl'
