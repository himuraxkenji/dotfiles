autoload -U compinit && compinit
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-direnv fzf)

# Load configurations
source $ZSH/oh-my-zsh.sh
[[ -f ~/.zsh/plugins.zsh ]] && source ~/.zsh/plugins.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/history.zsh ]] && source ~/.zsh/history.zsh
[[ -f ~/.zsh/nvm.zsh ]] && source ~/.zsh/nvm.zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.config/envman/PATH.env

# Load starship
eval "$(starship init zsh)"

# Load direnv
eval "$(direnv hook zsh)"

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# Load Angular CLI autocompletion.
source <(ng completion script)
