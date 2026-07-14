export EDITOR=nvim
export PATH=$HOME/.local/bin:$PATH

setopt SHARE_HISTORY HIST_IGNORE_DUPS
SAVEHIST=50000
HISTFILE=~/.zsh_history

fpath+=($HOME/.zsh/pure)
autoload -U promptinit
promptinit
prompt pure

alias find="fd"
alias ls="eza"

autoload -Uz compinit 
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

eval "$(direnv hook zsh)"
source ~/.zsh/fzf-tab/fzf-tab.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(~/.cargo/bin/zsh-patina activate)"
source <(fzf --zsh)

bindkey -e
