HISTFILE=$HOME/.config/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob nomatch notify hist_ignore_all_dups
unsetopt beep

# Completion
zstyle :compinstall filename '~/.zshrc'
bindkey '^R' history-incremental-search-backward
autoload -Uz compinit
compinit

# vim mode
bindkey -v

zmodload zsh/complist
zstyle ':completion:*' menu yes select
bindkey -M menuselect '?' history-incremental-search-forward

# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

KEYTIMEOUT=1

# Vim mode
bindkey "^e" history-beginning-search-backward
bindkey "^y" history-beginning-search-forward

## Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

autoload -z edit-command-line
zle -N edit-command-line
bindkey '^k' edit-command-line

# prompt
fpath+=$HOME/.config/zsh/pure
autoload -U promptinit; promptinit
prompt pure
PURE_PROMPT_SYMBOL=→
PURE_PROMPT_VICMD_SYMBOL=←
zstyle ':prompt:pure:prompt:success' color white

# rsync copy
function cpr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$@"
}
function mvr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}

# z cd
source $HOME/.config/zsh/zsh-z/zsh-z.plugin.zsh
# autosuggestion
source $HOME/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^f' autosuggest-accept

if [ "$HOST" = "INF-FVFGN0ULQ05P" ]; then
  alias l='ls -lahG'
else
  alias l='ls -lahG --color'
fi

alias atexmk="ls *.tex *.bib | entr -s 'latexmk --pdf -gg -f && latexmk -c'"
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias push='git push'
alias pull='git pull'
alias adda='git add -A -p'
alias comm='git commit -v'
alias j='nvim'
alias vimdiff='nvim $(git diff --name-only origin/main)'
