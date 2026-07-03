set -g fish_greeting ""

# Enable vi mode
fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

if not set -q TMUX; and not set -q ZELLIJ; and not set -q ZED_TERMINAL
    if type -q zellij
        zellij attach -c main
    else if type -q tmux
        tmux new-session -A -s main
    end
end

clear
