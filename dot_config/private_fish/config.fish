if status is-interactive
    # Initialize starship prompt
    if command -sq starship
        starship init fish | source
    end
end
