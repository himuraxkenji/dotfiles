SYSTEM := $(shell uname -s)
ifeq ($(SYSTEM),Darwin)
	FLAKE_TARGET := himura-darwin
else
	FLAKE_TARGET := himura-linux
endif

FISH_PATH := $(HOME)/.local/state/nix/profiles/home-manager/home-path/bin/fish

.PHONY: switch build check lint shell

## Apply the config to the current machine.
switch:
	home-manager switch --flake .#$(FLAKE_TARGET) -b backup

## Build the activation package without applying it.
build:
	nix build .#homeConfigurations.$(FLAKE_TARGET).activationPackage

## Evaluate the flake (syntax/type errors, no build).
check:
	nix flake check

## Lint for anti-patterns (statix) and dead code (deadnix). Runs both even
## if the first one finds issues, and fails if either did.
lint:
	@nix run nixpkgs#statix -- check .; s=$$?; \
	nix run nixpkgs#deadnix -- .; d=$$?; \
	exit $$(( s > d ? s : d ))

## Set the Nix-managed fish as your default login shell (asks for your
## password: needs sudo to register it in /etc/shells, and chsh itself
## prompts separately). Log out and back in for it to take effect.
shell:
	@grep -qxF "$(FISH_PATH)" /etc/shells || echo "$(FISH_PATH)" | sudo tee -a /etc/shells
	chsh -s "$(FISH_PATH)"
