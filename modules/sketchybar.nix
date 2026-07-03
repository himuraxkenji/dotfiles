{ lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile = {
    "sketchybar/sketchybarrc" = {
      source = ./sketchybar/sketchybarrc;
      executable = true;
    };
  } // lib.mapAttrs'
    (name: _: lib.nameValuePair "sketchybar/plugins/${name}" {
      source = ./sketchybar/plugins + "/${name}";
      executable = true;
    })
    (builtins.readDir ./sketchybar/plugins);

  # Same reasoning as yabai/skhd (modules/yabai.nix, modules/skhd.nix): stay
  # on Homebrew instead of pkgs.sketchybar, consistent install pattern.
  # Unlike yabai/skhd, sketchybar has no native --start-service /
  # --restart-service flags — it's managed through `brew services`.

  home.activation.sketchybarInstall = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    BREW=""
    if [ -x /opt/homebrew/bin/brew ]; then
      BREW="/opt/homebrew/bin/brew"
    elif [ -x /usr/local/bin/brew ]; then
      BREW="/usr/local/bin/brew"
    fi

    if [ -z "$BREW" ]; then
      echo "⚠️  Homebrew not found — install SketchyBar manually: brew install FelixKratz/formulae/sketchybar"
    else
      "$BREW" tap FelixKratz/formulae >/dev/null 2>&1 || true
      if "$BREW" list --formula sketchybar >/dev/null 2>&1; then
        echo "✅ SketchyBar already installed"
      else
        echo "🚀 Installing SketchyBar via Homebrew..."
        "$BREW" install FelixKratz/formulae/sketchybar || echo "⚠️  SketchyBar install failed, run: brew install FelixKratz/formulae/sketchybar"
      fi
    fi
  '';

  home.activation.sketchybarService = lib.hm.dag.entryAfter [ "sketchybarInstall" ] ''
    BREW=""
    if [ -x /opt/homebrew/bin/brew ]; then
      BREW="/opt/homebrew/bin/brew"
    elif [ -x /usr/local/bin/brew ]; then
      BREW="/usr/local/bin/brew"
    fi

    if [ -n "$BREW" ]; then
      echo "🔧 Starting SketchyBar service..."
      if pgrep -x sketchybar >/dev/null 2>&1; then
        "$BREW" services restart sketchybar >/dev/null 2>&1 || {
          echo "⚠️  Failed to restart SketchyBar service. If Homebrew reports an untrusted tap, run:"
          echo "   $BREW trust --formula FelixKratz/formulae/sketchybar"
        }
      else
        "$BREW" services start sketchybar >/dev/null 2>&1 || {
          echo "⚠️  Failed to start SketchyBar service. If Homebrew reports an untrusted tap, run:"
          echo "   $BREW trust --formula FelixKratz/formulae/sketchybar"
        }
      fi
    fi
  '';
}
