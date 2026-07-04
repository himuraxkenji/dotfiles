{ pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    # The nixpkgs ghostty package only builds on Linux — on macOS the app
    # is installed separately (e.g. Homebrew cask); this module only
    # manages its config/theme/shader files.
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

    settings = {
      font-family = "IosevkaTerm NF";
      font-size = 18;

      background-opacity = 0.95;
      background-blur-radius = 20;

      window-decoration = true;
      window-padding-color = "extend";
      window-step-resize = false;
      window-padding-balance = true;
      window-height = 100;
      window-width = 100;

      gtk-tabs-location = "hidden";

      custom-shader = "shaders/cursor_smear_gentleman.glsl";

      theme = "Catppuccin Mocha";

      # macOS Alt key fix
      macos-option-as-alt = true;

      keybind = [
        "alt+left=unbind"
        "alt+right=unbind"

        # Split management
        "alt+v=new_split:right"
        "alt+d=new_split:down"

        # Split navigation — unbound so Alt+hjkl reach Zellij
        "alt+k=unbind"
        "alt+j=unbind"
        "alt+h=unbind"
        "alt+l=unbind"

        # Split resize
        "ctrl+shift+j=resize_split:up,10"
        "ctrl+shift+k=resize_split:down,10"
        "ctrl+shift+h=resize_split:left,10"
        "ctrl+shift+l=resize_split:right,10"

        # Miscellaneous
        "cmd+k=clear_screen"
        "shift+enter=text:\\x1b\\r"

        # Open file with nvim (write 'nvim' first, then use this keybinding)
        "alt+s=write_screen_file:paste"
      ];
    };
  };

  xdg.configFile."ghostty/shaders/cursor_smear_gentleman.glsl".source =
    ./ghostty/shaders/cursor_smear_gentleman.glsl;
}
