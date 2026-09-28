{ config, lib, pkgs, ... }:

let
  cfg = config.dotfiles;
in
lib.mkIf (cfg.multiplexer == "herdr") {
  home.packages = [ pkgs.herdr ];

  xdg.configFile."herdr/config.toml".source = ./herdr/config.toml;
  xdg.configFile."herdr/smart-nav.sh" = {
    source = ./herdr/smart-nav.sh;
    executable = true;
  };
}
