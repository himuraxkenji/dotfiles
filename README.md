# himura's dotfiles

Declarative, reproducible dev environment for macOS and Linux, managed with
[Nix Flakes](https://nixos.wiki/wiki/Flakes) + standalone
[Home Manager](https://github.com/nix-community/home-manager) (no `nix-darwin`,
no NixOS required).

Managed tools: git/gh/lazygit, starship, fish, tmux, zellij, ghostty, neovim
(LazyVim), television, opencode, sdkman, and — on macOS — yabai/skhd/sketchybar.

## 1. Install Nix

```sh
sh <(curl -L https://nixos.org/nix/install)
```

This is the official multi-user installer (works on macOS and Linux). Follow
the prompts, then **open a new terminal** so the installer's shell hooks are
picked up.

## 2. Enable flakes

Flakes are still an experimental feature. Create/edit `/etc/nix/nix.conf`:

```sh
sudo mkdir -p /etc/nix
echo "extra-experimental-features = flakes nix-command" | sudo tee -a /etc/nix/nix.conf
```

Restart the Nix daemon (macOS) or just open a new terminal (Linux):

```sh
sudo launchctl kickstart -k system/org.nixos.nix-daemon   # macOS only
```

## 3. Clone and apply

```sh
git clone <this-repo-url> ~/code/dotfiles
cd ~/code/dotfiles
make switch
```

`make switch` runs `home-manager switch --flake .#<target> -b backup`, where
`<target>` is auto-detected from `uname`:

- macOS (aarch64) → `himura-darwin`
- Linux (x86_64) → `himura-linux`

The `-b backup` flag makes home-manager rename any pre-existing file it would
otherwise overwrite to `<file>.backup`, instead of failing or silently
clobbering it.

First run installs `home-manager` itself as part of activation — no separate
bootstrap step needed.

### Other Makefile targets

| Target        | What it does                                              |
| -------------- | ---------------------------------------------------------- |
| `make build`   | Builds the activation package without applying it           |
| `make check`   | `nix flake check` — evaluates the flake, no build           |
| `make lint`    | `statix check .` + `deadnix .` — anti-patterns & dead code |

## 4. Set fish as your default shell

Home Manager installs fish into the Nix profile, not into `/etc/shells` — you
need one extra step so macOS/Linux will let you `chsh` into it:

```sh
SHELL_PATH="$HOME/.local/state/nix/profiles/home-manager/home-path/bin/fish"
grep -qxF "$SHELL_PATH" /etc/shells || echo "$SHELL_PATH" | sudo tee -a /etc/shells
chsh -s "$SHELL_PATH"
```

Log out and back in (or open a new terminal) for the change to take effect.

To switch back to zsh later (also installed via this flake):

```sh
chsh -s "$HOME/.local/state/nix/profiles/home-manager/home-path/bin/zsh"
```

## Repo layout

```
.
├── flake.nix           # inputs + homeConfigurations.himura-darwin/himura-linux
├── home.nix             # base packages, username/homeDirectory
├── modules/
│   ├── <tool>.nix        # one module per tool, wired into flake.nix's modules list
│   └── <tool>/            # static config files that module deploys (configs,
│                           # scripts, themes) — not every module needs one
└── Makefile
```

Each module follows the same shape: prefer the tool's native `programs.<tool>`
home-manager options where one exists, fall back to `xdg.configFile`/
`home.file` for static config otherwise, and avoid impure `home.activation`
side effects unless the tool genuinely has no other way to be installed
(e.g. yabai/skhd/sketchybar on macOS, which have no nixpkgs package and stay
on Homebrew).
