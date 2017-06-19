source /usr/local/lib/python2.7/site-packages/powerline/bindings/zsh/powerline.zsh
if which nvim > /dev/null 2>&1; then export EDITOR=nvim; else export EDITOR=vim; fi

# some more ls aliases
alias ls='ls -G'
alias ll='ls -alF'
alias vim='nvim'

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

source /usr/local/Cellar/fzf/0.16.7/shell/completion.zsh
source /usr/local/Cellar/fzf/0.16.7/shell/key-bindings.zsh
function cd() {
	entry_key=$(tmux list-panes -F '#{pid};#{pane_pid};#{pane_active}' | grep '1$' | sed 's/;1$//')
	[[ -f /tmp/panes_directories ]] && sed -i.bak "/$entry_key/d" /tmp/panes_directories
	builtin cd "$@"
	echo $entry_key:$(pwd) >> /tmp/panes_directories
}
cd .

PATH=/usr/local/bin:$PATH:~/bin:~/personal_config/bin

# zsh history
HISTSIZE=50000               #How many lines of history to keep in memory
HISTFILE=~/.zsh_history     #Where to save history to disk
SAVEHIST=50000               #Number of history entries to save to disk
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