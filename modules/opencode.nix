{ pkgs, ... }:

{
  # Reference config installed opencode by piping install.sh into bash on
  # every activation (impure, arbitrary remote code execution). nixpkgs
  # already packages it, pinned like everything else.
  home.packages = [ pkgs.opencode ];

  # gh-copilot extension install was dropped: it's deprecated/archived
  # upstream (GitHub folded it into `github-copilot-cli`), nixpkgs itself
  # throws trying to evaluate it now.
}
