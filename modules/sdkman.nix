{ lib, pkgs, ... }:

{
  # SDKMAN manages its own multi-version JVM ecosystem (java/kotlin/gradle/
  # maven/scala/sbt) under ~/.sdkman — like fisher/lazy.nvim, it's a
  # self-bootstrapping tool that isn't meaningfully "pinnable" via Nix.
  home = {
    sessionVariables = {
      SDKMAN_DIR = "$HOME/.sdkman";
    };

    sessionPath = [
      "$HOME/.sdkman/candidates/java/current/bin"
      "$HOME/.sdkman/candidates/kotlin/current/bin"
      "$HOME/.sdkman/candidates/gradle/current/bin"
      "$HOME/.sdkman/candidates/maven/current/bin"
      "$HOME/.sdkman/candidates/scala/current/bin"
      "$HOME/.sdkman/candidates/sbt/current/bin"
    ];

    # Idempotent: only fetches/installs if ~/.sdkman doesn't exist yet, so
    # this is a one-time bootstrap, not a repeated impure fetch on every
    # switch.
    activation.installSDKMAN = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -d "$HOME/.sdkman" ]; then
        echo "Installing SDKMAN..."
        ${pkgs.curl}/bin/curl -s "https://get.sdkman.io" | ${pkgs.bash}/bin/bash
        echo "SDKMAN installed successfully!"
      else
        echo "SDKMAN is already installed at $HOME/.sdkman"
      fi
    '';

    file.".local/bin/install-sdkman" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        # Manual fallback for the activation step above.
        if [ ! -d "$HOME/.sdkman" ]; then
          echo "Installing SDKMAN..."
          curl -s "https://get.sdkman.io" | bash
          echo "SDKMAN installed successfully!"
          echo "Please restart your shell or run: source ~/.sdkman/bin/sdkman-init.sh"
        else
          echo "SDKMAN is already installed at $HOME/.sdkman"
        fi
      '';
    };
  };
}
