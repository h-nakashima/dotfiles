#!/usr/bin/env bash

# This script runs once to set Fish as the default shell.
# `brew bundle` will handle installing `fish` and `starship`.

FISH_PATH="/opt/homebrew/bin/fish"
if [ ! -f "$FISH_PATH" ]; then
    FISH_PATH="/usr/local/bin/fish"
fi

if [ -f "$FISH_PATH" ]; then
    if ! grep -q "$FISH_PATH" /etc/shells; then
        echo "Adding $FISH_PATH to /etc/shells (requires sudo)"
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi

    if [ "$SHELL" != "$FISH_PATH" ]; then
        echo "Changing default shell to Fish..."
        chsh -s "$FISH_PATH"
        echo "Successfully changed shell to Fish. Please restart the terminal once deployment is complete."
    fi
fi
