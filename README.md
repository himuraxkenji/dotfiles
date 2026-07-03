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
| `make shell`   | Set the Nix-managed fish as your default login shell (see below) |

## 4. Set fish as your default shell

Home Manager installs fish into the Nix profile, not into `/etc/shells` — you
need one extra step so macOS/Linux will let you `chsh` into it:

```sh
make shell
```

That's `make shell` doing this, if you'd rather run it by hand:

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

## 5. Secrets (API keys, tokens)

Nothing secret goes in this repo or in the Nix store — both end up
world-readable (the Nix store is readable by every user on the machine, and
this repo is public on GitHub). Instead, `modules/fish/conf.d/70-local.fish`
sources `~/.secrets.fish` if it exists, and that file lives outside the repo
entirely, untouched by `home-manager switch`.

On each machine, create it by hand once:

```sh
cat > ~/.secrets.fish <<'EOF'
set -gx OPENAI_API_KEY "sk-..."
set -gx GH_TOKEN "ghp_..."
EOF
```

Same pattern is used for the conditional git identity in `modules/git.nix`
(`programs.git.includes[].path` points at a file outside the repo too) — the
rule of thumb: anything Nix would otherwise bake into the store or this repo
stays as an external file that Nix only references by path, never reads.

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
