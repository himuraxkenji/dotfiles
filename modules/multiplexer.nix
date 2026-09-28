{ config, lib, ... }:

let
  cfg = config.dotfiles;
in
{
  options.dotfiles.multiplexer = lib.mkOption {
    type = lib.types.enum [ "herdr" "zellij" ];
    default = "herdr";
    description = ''
      Terminal multiplexer auto-attached by interactive fish
      (`modules/fish/conf.d/60-behavior.fish`). tmux remains the fallback
      when the selected tool isn't available.
    '';
  };

  config = {
    # fish sources conf.d/*.fish before programs.fish's config.fish
    # (see modules/fish/conf.d/10-path.fish for the same PATH-ordering
    # workaround), so home.sessionVariables would be set too late for
    # 60-behavior.fish to read it. Emit a small generated conf.d snippet
    # instead — it sorts before 10-path/60-behavior and is re-evaluated on
    # every shell start, so it's never stale.
    xdg.configFile."fish/conf.d/05-multiplexer.fish".text = ''
      set -g DOTFILES_MULTIPLEXER "${cfg.multiplexer}"
    '';
  };
}
