export EDITOR=vim

setopt SHARE_HISTORY HIST_IGNORE_DUPS
SAVEHIST=50000
HISTFILE=~/.zsh_history

fpath+=($HOME/.zsh/pure)
autoload -U promptinit
promptinit
prompt pure

alias cat="bat -p"
alias find="fd"
alias ls="eza"

autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(~/.cargo/bin/zsh-patina activate)"
