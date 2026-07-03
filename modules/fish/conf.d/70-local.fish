# Machine-local secrets (API keys, tokens, etc.) — never committed to this
# repo, and outside any Nix-managed path so it survives `home-manager switch`
# untouched. Create ~/.secrets.fish by hand on each machine; see README.md.
if test -f ~/.secrets.fish
    source ~/.secrets.fish
end
