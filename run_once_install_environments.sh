#!/usr/bin/env bash

# Install xcode.
xcode-select --install || true

# Install Rosetta2
sudo softwareupdate --install-rosetta || true

# Setting anyenv.
# brew bundle によって anyenv 自体は入っている前提になります
if command -v anyenv 1>/dev/null 2>&1; then
    anyenv install --init || true
    anyenv install rbenv || true
    anyenv install pyenv || true
    anyenv install nodenv || true
else
    echo "anyenv is not installed. Please check brew bundle."
fi
