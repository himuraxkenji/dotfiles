if status is-interactive
    # Install Fisher if not installed
    if not functions -q fisher
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    end

    fish_config theme choose "Catppuccin Mocha"
end
