# Ensure Nix binary is in PATH for home-manager
if not contains /nix/var/nix/profiles/default/bin $PATH
    set -gx PATH /nix/var/nix/profiles/default/bin $PATH
end

if test (uname) = Darwin
    set BREW_BIN /opt/homebrew/bin/brew
else
    set BREW_BIN /home/linuxbrew/.linuxbrew/bin/brew
end

# Only run brew shellenv if brew is actually installed
if test -x $BREW_BIN
    eval ($BREW_BIN shellenv)
else
    echo "⚠️  Homebrew not found. Install it with:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
end

# pnpm global executables (installed via Homebrew)
set -gx PNPM_HOME $HOME/Library/pnpm

# Priority: opencode > pnpm globals > local bins > nix > homebrew > system
set -gx PATH $HOME/.opencode/bin $PNPM_HOME/bin $HOME/.local/bin $HOME/.local/state/nix/profiles/home-manager/home-path/bin $HOME/.nix-profile/bin /nix/var/nix/profiles/default/bin $PATH

set -gx GPG_TTY (tty)
