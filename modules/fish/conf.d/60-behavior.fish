set -g fish_greeting ""

# Enable vi mode
fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    if not set -q TMUX; and not set -q ZELLIJ; and test "$HERDR_ENV" != 1; and not set -q ZED_TERMINAL
        # $DOTFILES_MULTIPLEXER comes from modules/multiplexer.nix's generated
        # fish/conf.d/05-multiplexer.fish (sourced before this file). If it's
        # unset (e.g. snippet missing), fall back to the old zellij->tmux chain
        # so the shell never fails to attach.
        switch "$DOTFILES_MULTIPLEXER"
            case herdr
                if type -q herdr
                    herdr --session main
                else if type -q tmux
                    tmux new-session -A -s main
                end
            case '*'
                if type -q zellij
                    zellij attach -c main
                else if type -q tmux
                    tmux new-session -A -s main
                end
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
