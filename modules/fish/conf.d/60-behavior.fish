set -g fish_greeting ""

# Enable vi mode
fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    if not set -q TMUX; and not set -q ZELLIJ; and not set -q ZED_TERMINAL
        if type -q zellij
            zellij attach -c main
        else if type -q tmux
            tmux new-session -A -s main
        end
    end

    # Guard against "TERM environment variable not set." — clear (ncurses)
    # prints that warning to stderr instead of silently no-op'ing when $TERM
    # is unset at this point in shell startup (e.g. before a terminal's PTY
    # has fully attached).
    if test -n "$TERM"
        clear
    end
end
