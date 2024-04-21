autoload -U compinit && compinit
plugins=(git aliases zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-direnv)

# Load configurations
source $ZSH/oh-my-zsh.sh
[[ -f ~/.zsh/plugins.zsh ]] && source ~/.zsh/plugins.zsh
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/history.zsh ]] && source ~/.zsh/history.zsh
[[ -f ~/.zsh/nvm.zsh ]] && source ~/.zsh/nvm.zsh

# Load starship
eval "$(starship init zsh)"

# Load direnv
eval "$(direnv hook zsh)"
