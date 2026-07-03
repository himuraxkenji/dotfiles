{ lib, pkgs, ... }:

let
  # brew is not guaranteed to be on PATH during home-manager activation;
  # probe the standard locations (Apple Silicon first, Intel fallback).
  locateBrew = ''
    BREW=""
    if [ -x /opt/homebrew/bin/brew ]; then
      BREW="/opt/homebrew/bin/brew"
    elif [ -x /usr/local/bin/brew ]; then
      BREW="/usr/local/bin/brew"
    fi
  '';
in
lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile = {
    "yabai/yabairc" = {
      source = ./yabai/yabairc;
      executable = true;
    };
    "yabai/focus-current-space-window.sh" = {
      source = ./yabai/focus-current-space-window.sh;
      executable = true;
    };
    "yabai/move-window-to-space.sh" = {
      source = ./yabai/move-window-to-space.sh;
      executable = true;
    };
  };

  # yabai has no nixpkgs package (its scripting addition needs SIP partially
  # disabled and specific codesigning, incompatible with how Nix builds
  # binaries) — install/manage it via Homebrew instead. Split into named
  # steps instead of one big block, and made idempotent where the original
  # wasn't (Mission Control settings only get touched, and the Dock only
  # restarted, when the value actually needs to change).

  home.activation.yabaiInstall = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${locateBrew}
    if [ -z "$BREW" ]; then
      echo "⚠️  Homebrew not found — install yabai manually: brew install asmvik/formulae/yabai"
    else
      "$BREW" tap asmvik/formulae >/dev/null 2>&1 || true
      if "$BREW" list yabai >/dev/null 2>&1 || command -v yabai >/dev/null 2>&1; then
        echo "✅ yabai already installed"
      else
        echo "🚀 Installing yabai via Homebrew..."
        "$BREW" install asmvik/formulae/yabai || echo "⚠️  yabai install failed, run: brew install asmvik/formulae/yabai"
      fi
    fi
  '';

  home.activation.yabaiMissionControl = lib.hm.dag.entryAfter [ "yabaiInstall" ] ''
    # mru-spaces must be off for yabai/sketchybar to work correctly with
    # numbered spaces. Only write + restart the Dock if it isn't already set,
    # instead of doing it unconditionally on every switch.
    CURRENT_MRU="$(/usr/bin/defaults read com.apple.dock mru-spaces 2>/dev/null || echo 1)"
    if [ "$CURRENT_MRU" != "0" ]; then
      echo "Disabling Mission Control automatic space reordering..."
      /usr/bin/defaults write com.apple.dock mru-spaces -bool false
      killall Dock 2>/dev/null || true
    fi
  '';

  home.activation.yabaiService = lib.hm.dag.entryAfter [ "yabaiMissionControl" ] ''
    # activation scripts don't inherit the interactive shell's PATH (no
    # Homebrew on it), so locate the binary explicitly instead of relying
    # on bare `yabai` being found.
    YABAI_BIN=""
    if [ -x /opt/homebrew/bin/yabai ]; then
      YABAI_BIN="/opt/homebrew/bin/yabai"
    elif [ -x /usr/local/bin/yabai ]; then
      YABAI_BIN="/usr/local/bin/yabai"
    fi

    if [ -n "$YABAI_BIN" ]; then
      echo "🔧 Starting yabai service..."
      # brew services is unsupported by this formula (no #service); use the
      # binary's native service manager, idempotently.
      if pgrep -x yabai >/dev/null 2>&1; then
        "$YABAI_BIN" --restart-service || true
      else
        "$YABAI_BIN" --start-service || true
      fi
    else
      echo "⚠️  yabai binary not found — skipping service start."
    fi
  '';

  home.activation.yabaiSudoers = lib.hm.dag.entryAfter [ "yabaiService" ] ''
    # Required for space switching (yabai --load-sa needs passwordless sudo).
    # `brew upgrade yabai` changes the binary, invalidating the sha256 in the
    # sudoers entry — recompute it on every activation and print the command
    # to fix it if it drifted. Never sudo automatically here.
    YABAI_PATH="$(command -v yabai 2>/dev/null || true)"
    if [ -z "$YABAI_PATH" ] && [ -x /opt/homebrew/bin/yabai ]; then
      YABAI_PATH="/opt/homebrew/bin/yabai"
    elif [ -z "$YABAI_PATH" ] && [ -x /usr/local/bin/yabai ]; then
      YABAI_PATH="/usr/local/bin/yabai"
    fi

    if [ -n "$YABAI_PATH" ] && [ -x "$YABAI_PATH" ]; then
      YABAI_HASH=$(/usr/bin/shasum -a 256 "$YABAI_PATH" | /usr/bin/awk '{print $1}')
      EXPECTED_ENTRY="$USER ALL=(root) NOPASSWD: sha256:$YABAI_HASH $YABAI_PATH --load-sa"

      NEEDS_UPDATE=false
      if [ ! -f /private/etc/sudoers.d/yabai ]; then
        NEEDS_UPDATE=true
      elif ! /usr/bin/grep -q "$YABAI_HASH" /private/etc/sudoers.d/yabai 2>/dev/null; then
        NEEDS_UPDATE=true
      fi

      if [ "$NEEDS_UPDATE" = true ]; then
        echo ""
        echo "══════════════════════════════════════════════════════════════"
        echo "  ⚠️  Yabai scripting addition needs sudoers update!"
        echo "  Run this command to enable space switching:"
        echo ""
        echo "  echo \"$EXPECTED_ENTRY\" | sudo tee /private/etc/sudoers.d/yabai"
        echo "  sudo $YABAI_PATH --load-sa"
        echo "══════════════════════════════════════════════════════════════"
        echo ""
      else
        echo "✅ Yabai sudoers entry is up to date."
      fi
    else
      echo "⚠️  yabai binary not found — skipping sudoers setup."
    fi
  '';
}
