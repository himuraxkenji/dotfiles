{ config, pkgs, ... }:

{
  home = {
    username = "himuraxkenji";
    homeDirectory =
      if pkgs.stdenv.isDarwin
      then "/Users/${config.home.username}"
      else "/home/${config.home.username}";

    # This value determines the Home Manager release that your configuration
    # is compatible with. This helps avoid breakage when a new Home Manager
    # release introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If
    # you do want to update the value, then make sure to first check the
    # Home Manager release notes.
    stateVersion = "25.11";

    packages = with pkgs; [
      # shells
      zsh

      # editor / terminal tooling
      zellij
      zoxide
      atuin
      fzf
      ripgrep
      bat
      fd
      direnv
      carapace
      nushell
      yazi
      tree-sitter
      unzip

      # language toolchains
      nodejs
      bun
      pnpm
      volta
      go
      cargo
      uv

      # nix tooling
      nil
      nixd

      # nerd fonts
      nerd-fonts.iosevka-term
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
