{ pkgs, lib, ... }:

let
  # Curated subset of television's official "cable" channel catalog
  # (https://github.com/alexpasmantier/television/tree/main/cable/unix),
  # pinned to the installed version. Vendored via fetchurl instead of
  # hand-written: the schema changed since the reference config was
  # written (keybindings inverted key<->action, channels gained a
  # required [metadata] table), and the official catalog is
  # community-maintained with per-channel requirement/skip detection.
  version = "0.15.9";
  fetchChannel = name: sha256:
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/alexpasmantier/television/${version}/cable/unix/${name}.toml";
      inherit sha256;
    };

  channelHashes = {
    "files" = "0rfc90llzqcvy8487b1lg5j15yhpkd100rfq124ig5mz6zqhpkzx";
    "git-diff" = "0yrvrciaijsz1ljznyi4d3v8a7j93xrycswp3lfqrrgfifqws19g";
    "git-log" = "1i1nv7i6m3i3dasa1gqcn8w7z5j32hknal1p1iqpljfydvwgnaym";
    "git-branch" = "1k24b95sgyjj045s17kbap1i3ip4ndkiqkvr42q2y991yilbx898";
    "git-reflog" = "1bh05vm00gyl3bxg5q6kd8js8sl1h8vfv0sph794kwjjb6pjszbk";
    "docker-images" = "0ic00wscgdm8ym529ail4qplax93myrk8zksmpd8rh0750h6h8zx";
    "dotfiles" = "1gc1ibay5kfchppjnxqw1i9vazlnxpl3f0bghzmvl9ma2zh17z62";
    "fish-history" = "158ri75cjlwy08yj770cb6n7s4z39r0s1nldgdxkmsf509y78z6q";
  };
in
{
  # Fish shell integration (ctrl-t/ctrl-r auto-bindings) is intentionally
  # left off: its default ctrl-r would collide with atuin's history search,
  # already bound in modules/fish/conf.d/30-integrations.fish. `tv` is used
  # manually instead.
  programs.television = {
    enable = true;

    settings = {
      frame_rate = 60;
      tick_rate = 50;

      ui = {
        use_nerd_font_icons = false;
        ui_scale = 100;
        show_help_bar = false;
        show_preview_panel = true;
        input_bar_position = "top";
        theme = "television";
      };

      previewers.file.theme = "OneHalfDark";

      # Schema is key -> action (television >= 0.15 inverted this from the
      # older action -> [keys] format the reference config used).
      keybindings = {
        esc = "quit";
        ctrl-c = "quit";
        down = "select_next_entry";
        ctrl-n = "select_next_entry";
        ctrl-j = "select_next_entry";
        up = "select_prev_entry";
        ctrl-p = "select_prev_entry";
        ctrl-k = "select_prev_entry";
        pagedown = "select_next_page";
        pageup = "select_prev_page";
        ctrl-d = "scroll_preview_half_page_down";
        ctrl-u = "scroll_preview_half_page_up";
        tab = "toggle_selection_down";
        backtab = "toggle_selection_up";
        enter = "confirm_selection";
        ctrl-y = "copy_entry_to_clipboard";
        ctrl-r = "toggle_remote_control";
        ctrl-s = "toggle_send_to_channel";
        ctrl-g = "toggle_help";
        ctrl-o = "toggle_preview";
      };
    };
  };

  xdg.configFile = lib.mapAttrs'
    (name: sha256: lib.nameValuePair "television/cable/${name}.toml" {
      source = fetchChannel name sha256;
    })
    channelHashes;
}
