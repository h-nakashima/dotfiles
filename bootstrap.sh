#!/usr/bin/env zsh

cd "$(dirname "${(%):-%N}")";

git pull origin main;

function doIt() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
    rsync --exclude ".git/" \
          --exclude ".DS_Store" \
          --exclude ".macos" \
          --exclude ".macos_settings" \
          --exclude "bootstrap.sh" \
          --exclude "README.md" \
          --exclude "LICENSE-MIT.txt" \
          -avh --no-perms . ~;
    source ~/.zsh_profile;
}

if [[ "$1" == "--force" || "$1" == "-f" ]]; then
    doIt;
else
    read "reply?This may overwrite existing files in your home directory. Are you sure? (y/n) "
    echo "";
    if [[ "$reply" =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;
