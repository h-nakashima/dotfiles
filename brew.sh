#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install a modern version of zsh.
brew install zsh

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/zsh";
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install other useful binaries.
brew install git
brew install rename
brew install ssh-copy-id
brew install peco
brew install ghq
brew install gibo
brew install anyenv

# Install cask apps
brew install --cask google-file-stream
brew install --cask zoom
brew install --cask discord
brew install --cask google-chrome
brew install --cask visual-studio-code

# Remove outdated versions from the cellar.
brew cleanup
