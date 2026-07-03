{ lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."skhd/skhdrc" = {
    source = ./skhd/skhdrc;
    executable = true;
  };

  # Same reasoning as yabai (modules/yabai.nix): stay on Homebrew instead of
  # pkgs.skhd, since macOS ties the Accessibility permission grant to the
  # binary's path — switching would mean re-granting it by hand in System
  # Settings. Split into named steps instead of one big activation block.

  home.activation.skhdInstall = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    BREW=""
    if [ -x /opt/homebrew/bin/brew ]; then
      BREW="/opt/homebrew/bin/brew"
    elif [ -x /usr/local/bin/brew ]; then
      BREW="/usr/local/bin/brew"
    fi

    if [ -z "$BREW" ]; then
      echo "⚠️  Homebrew not found — install skhd manually: brew install koekeishiya/formulae/skhd"
    else
      "$BREW" tap koekeishiya/formulae >/dev/null 2>&1 || true
      if "$BREW" list skhd >/dev/null 2>&1 || command -v skhd >/dev/null 2>&1; then
        echo "✅ skhd already installed"
      else
        echo "🚀 Installing skhd via Homebrew..."
        "$BREW" install koekeishiya/formulae/skhd || echo "⚠️  skhd install failed, run: brew install koekeishiya/formulae/skhd"
      fi
    fi
  '';

  home.activation.skhdService = lib.hm.dag.entryAfter [ "skhdInstall" ] ''
    # activation scripts don't inherit the interactive shell's PATH (no
    # Homebrew on it), so locate the binary explicitly.
    SKHD_BIN=""
    if [ -x /opt/homebrew/bin/skhd ]; then
      SKHD_BIN="/opt/homebrew/bin/skhd"
    elif [ -x /usr/local/bin/skhd ]; then
      SKHD_BIN="/usr/local/bin/skhd"
    fi

    if [ -n "$SKHD_BIN" ]; then
      echo "🔧 Starting skhd service..."
      # brew services is unsupported by this formula (no #service); use the
      # binary's native service manager, idempotently.
      if pgrep -x skhd >/dev/null 2>&1; then
        "$SKHD_BIN" --restart-service || true
      else
        "$SKHD_BIN" --start-service || true
      fi
      echo "⚠️  If windows don't respond to hotkeys, grant Accessibility permission to skhd in System Settings."
    else
      echo "⚠️  skhd binary not found — skipping service start."
    fi
  '';
}
