{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    mouse = true;
    baseIndex = 1;
    escapeTime = 10;
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      resurrect
      tmux-which-key
      {
        plugin = ukiyo;
        extraConfig = ''
          set -g @ukiyo-theme 'kanagawa/wave'
          set -g @ukiyo-plugins "git cpu-usage ram-usage"
          set -g @ukiyo-ignore-window-colors true
        '';
      }
    ];

    extraConfig = ''
      setw -g pane-base-index 1

      # Floating scratch session
      bind-key -n M-g if-shell -F '#{==:#{session_name},scratch}' {
        detach-client
      } {
        display-popup -d "#{pane_current_path}" -E -k "tmux new-session -A -s scratch"
      }

      # --- terminal & key handling ---
      set -as terminal-features ",*:RGB"
      set -as terminal-features ",*:usstyle"
      set -as terminal-features ",*:hyperlinks"
      # Synchronized output (DECSET 2026) passthrough — fixes TUI flicker/redraw
      # duplication for high-frequency apps (pi, claude-code) running inside tmux.
      set -as terminal-features ",*:sync"

      set -s extended-keys on
      set -s extended-keys-format csi-u
      set -as terminal-features 'xterm*:extkeys'

      set -g set-clipboard on
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel

      unbind %
      unbind '"'
      bind v split-window -h -c "#{pane_current_path}"
      bind d split-window -v -c "#{pane_current_path}"

      set -g status-position top

      bind K confirm-before -p "Kill all other sessions? (y/n)" "kill-session -a"
    '';
  };
}
