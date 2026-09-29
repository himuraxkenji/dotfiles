{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles;
in
lib.mkIf (cfg.multiplexer == "herdr") {
  home.packages = [ pkgs.herdr ];

  xdg.configFile."herdr/config.toml".source = ./herdr/config.toml;

  # config.toml binds ctrl+h/j/k/l to smart-splits.nvim's official herdr
  # plugin_action commands (smart-splits.nvim.left/down/up/right), which
  # only resolve once the plugin is linked into herdr's plugin registry.
  # Reproduce that link on every activation so a fresh machine doesn't need
  # a manual step, mirroring the skhd/sketchybar activation pattern
  # (modules/skhd.nix, modules/sketchybar.nix).
  home.activation.herdrPluginLink = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    HERDR_BIN=""
    if command -v herdr >/dev/null 2>&1; then
      HERDR_BIN="herdr"
    fi

    SMART_SPLITS_DIR="$HOME/.local/share/nvim/lazy/smart-splits.nvim"

    if [ -z "$HERDR_BIN" ]; then
      echo "⚠️  herdr not found — skipping plugin link. Run manually: herdr plugin link $SMART_SPLITS_DIR && herdr server reload-config"
    elif [ ! -d "$SMART_SPLITS_DIR" ]; then
      echo "⚠️  $SMART_SPLITS_DIR not found (lazy.nvim hasn't installed smart-splits.nvim yet) — skipping plugin link. Once nvim has bootstrapped plugins, run: herdr plugin link $SMART_SPLITS_DIR && herdr server reload-config"
    else
      "$HERDR_BIN" plugin link "$SMART_SPLITS_DIR" || echo "⚠️  herdr plugin link failed — run manually: herdr plugin link $SMART_SPLITS_DIR"
      "$HERDR_BIN" server reload-config || true
    fi
  '';
}
