if status is-interactive
    # Initialize starship prompt
    if command -sq starship
        starship init fish | source
    end
end

# Load machine-specific private settings (not committed to repository)
if test -f ~/.extra
    source ~/.extra
end
