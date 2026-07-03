{ pkgs, ... }:

let
  catppuccinSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "fish";
    rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
    sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
  };
in
{
  programs.fish = {
    enable = true;

    shellInit = ''
      # Ensure Home Manager binaries are in PATH
      set -gx PATH "$HOME/.local/state/nix/profiles/home-manager/home-path/bin" $PATH
    '';

    loginShellInit = ''
      # Ensure Nix binary is in PATH for home-manager (login shell)
      if not contains /nix/var/nix/profiles/default/bin $PATH
          set -gx PATH /nix/var/nix/profiles/default/bin $PATH
      end
    '';

    plugins = [
      {
        name = "fisher";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "fisher";
          rev = "4.4.4";
          sha256 = "sha256-e8gIaVbuUzTwKtuMPNXBT5STeddYqQegduWBtURLT3M=";
        };
      }
      {
        name = "catppuccin";
        src = catppuccinSrc;
      }
    ];
  };

  xdg.configFile = {
    # programs.fish.plugins only wires up functions/completions/conf.d from
    # a plugin, not its themes/ directory — copy it manually so
    # `fish_config theme choose "Catppuccin Mocha"` can find it.
    "fish/themes".source = "${catppuccinSrc}/themes";
  }
  # Interactive-shell config lives in modules/fish/conf.d/*.fish — fish
  # sources conf.d/*.fish automatically, no need to concatenate Nix strings.
  # Declared per-file (not as a whole directory) so it coexists with the
  # conf.d/plugin-*.fish files that programs.fish.plugins generates.
  // (builtins.listToAttrs (map
    (name: {
      name = "fish/conf.d/${name}";
      value.source = ./fish/conf.d + "/${name}";
    })
    (builtins.attrNames (builtins.readDir ./fish/conf.d))));
}
