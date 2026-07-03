if test (uname) = Darwin
    alias hms='home-manager switch --flake .#himura-darwin -b backup'
else
    alias hms='home-manager switch --flake .#himura-linux -b backup'
end

alias fzfbat='fzf --preview="bat --theme=gruvbox-dark --color=always {}"'
alias fzfnvim='nvim (fzf --preview="bat --theme=gruvbox-dark --color=always {}")'
alias opencode-config='nvim ~/.config/opencode/opencode.json'
