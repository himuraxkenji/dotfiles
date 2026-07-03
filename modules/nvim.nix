{ pkgs, ... }:

{
  # Plain package install, not programs.neovim: that module generates its
  # own init.lua when withPython3/withNodeJs are set (for provider paths),
  # which collides with the full LazyVim init.lua below. Neovim auto-detects
  # python3/node providers from $PATH fine without it.
  home.packages = [ pkgs.neovim ];

  xdg.configFile."nvim".source = ./nvim;
}
