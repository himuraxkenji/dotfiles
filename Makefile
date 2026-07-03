SYSTEM := $(shell uname -s)
ifeq ($(SYSTEM),Darwin)
	FLAKE_TARGET := himura-darwin
else
	FLAKE_TARGET := himura-linux
endif

.PHONY: switch build check lint

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
