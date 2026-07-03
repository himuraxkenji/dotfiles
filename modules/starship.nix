_:

{
  programs.starship = {
    enable = true;
    settings = {
      format = ''
        ($directory)$os$git_branch$git_status$fill$nodejs$rust$golang$bun$java$c$python$cmd_duration$time
        $character'';

      add_newline = true;
      command_timeout = 500;
      scan_timeout = 500;
      palette = "catppuccin_mocha";

      fill.symbol = " ";

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };

      character = {
        success_symbol = "[󱄛 ](fg:green)";
        error_symbol = "[󱄛 ](fg:red)";
        vimcmd_symbol = "[N](bold red)";
        vimcmd_replace_one_symbol = "[R](bold peach)";
        vimcmd_visual_symbol = "[V](bold mauve)";
      };

      username = {
        style_user = "bold blue";
        style_root = "bold red";
        format = "[󱄛   $user](fg:$style) ";
        disabled = false;
        show_always = true;
      };

      directory = {
        format = "[$path](bold $style)[$read_only]($read_only_style) ";
        truncation_length = 2;
        style = "fg:blue";
        read_only_style = "fg:blue";
        before_repo_root_style = "fg:blue";
        truncation_symbol = "…/";
        truncate_to_repo = true;
        read_only = "  ";

        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      cmd_duration = {
        format = " took [ $duration]($style) ";
        style = "bold fg:yellow";
        min_time = 500;
      };

      git_branch = {
        format = "-> [$symbol$branch]($style) ";
        style = "bold fg:mauve";
        symbol = " ";
      };

      git_status = {
        format = "[$all_status$ahead_behind ]($style)";
        style = "fg:peach";
      };

      docker_context = {
        disabled = true;
        symbol = " ";
      };

      python = {
        disabled = false;
        format = "[[ $symbol ($version) ](fg:yellow)]($style)";
        symbol = "";
        version_format = "$raw";
      };

      java = {
        format = "[[ $symbol ($version) ](fg:red)]($style)";
        version_format = "$raw";
        symbol = " ";
        disabled = false;
      };

      c = {
        format = "[[ $symbol ($version) ](fg:blue)]($style)";
        symbol = " ";
        version_format = "$raw";
        disabled = false;
      };

      bun = {
        version_format = "$raw";
        format = "[[ $symbol ($version) ](fg:text)]($style)";
        disabled = false;
      };

      nodejs = {
        symbol = "";
        format = "[[ $symbol ($version) ](fg:green)]($style)";
      };

      rust = {
        symbol = "";
        format = "[[ $symbol ($version) ](fg:red)]($style)";
      };

      golang = {
        symbol = "";
        format = "[[ $symbol ($version) ](fg:teal)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        format = "[[   $time ](fg:subtext0)]($style)";
      };
    };
  };
}
