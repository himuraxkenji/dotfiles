SYSTEM := $(shell uname -s)
ifeq ($(SYSTEM),Darwin)
	FLAKE_TARGET := himura-darwin
else
	FLAKE_TARGET := himura-linux
endif

FISH_PATH := $(HOME)/.local/state/nix/profiles/home-manager/home-path/bin/fish

.PHONY: switch build check lint shell
.PHONY: update update-nix update-brew

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

## Update managed tool versions (Nix inputs + Homebrew tools) with review output.
update: update-nix update-brew
	@echo ""
	@echo "✅ Update flow completed."
	@echo "🔎 Review changes with: git --no-pager diff -- flake.lock"
	@echo "📦 Check Homebrew state with: brew outdated"
	@echo "➡️  After review, apply with: make switch"

## Update flake inputs and show the lockfile diff summary.
update-nix:
	@echo "🔄 Updating flake inputs (nixpkgs/home-manager)..."
	nix flake update
	@echo ""
	@echo "📝 flake.lock changes:"
	@git --no-pager diff --stat -- flake.lock || true

## Update Homebrew formulas used by macOS modules; no-op outside macOS.
update-brew:
	@if [ "$(SYSTEM)" != "Darwin" ]; then \
		echo "ℹ️  Skipping Homebrew updates on non-macOS host."; \
		exit 0; \
	fi
	@BREW=""; \
	if [ -x /opt/homebrew/bin/brew ]; then \
		BREW="/opt/homebrew/bin/brew"; \
	elif [ -x /usr/local/bin/brew ]; then \
		BREW="/usr/local/bin/brew"; \
	fi; \
	if [ -z "$$BREW" ]; then \
		echo "⚠️  Homebrew not found; skipping Homebrew update step."; \
		exit 0; \
	fi; \
	echo "🔄 Updating Homebrew metadata..."; \
	"$$BREW" update; \
	echo "🔄 Ensuring required taps are present..."; \
	"$$BREW" tap asmvik/formulae >/dev/null 2>&1 || true; \
	"$$BREW" tap koekeishiya/formulae >/dev/null 2>&1 || true; \
	"$$BREW" tap FelixKratz/formulae >/dev/null 2>&1 || true; \
	echo "📋 Outdated formulas before upgrade:"; \
	"$$BREW" outdated || true; \
	echo "⬆️  Upgrading managed formulas (if installed)..."; \
	for formula in yabai skhd sketchybar; do \
		if "$$BREW" list --formula "$$formula" >/dev/null 2>&1; then \
			"$$BREW" upgrade "$$formula" || true; \
		else \
			echo "ℹ️  $$formula is not installed; skipping."; \
		fi; \
	done; \
	echo "📋 Outdated formulas after upgrade:"; \
	"$$BREW" outdated || true

## Set the Nix-managed fish as your default login shell (asks for your
## password: needs sudo to register it in /etc/shells, and chsh itself
## prompts separately). Log out and back in for it to take effect.
shell:
	@grep -qxF "$(FISH_PATH)" /etc/shells || echo "$(FISH_PATH)" | sudo tee -a /etc/shells
	chsh -s "$(FISH_PATH)"
