# Editors
set -gx EDITOR nano
set -gx SVN_EDITOR nano

# Python
set -gx PYTHONIOENCODING UTF-8

# Locale and Pager
set -gx LANG ja_JP.UTF-8
set -gx LC_ALL ja_JP.UTF-8
set -gx MANPAGER "less -X"
set -gx GPG_TTY (tty)

# Tool paths
set -gx GOPATH $HOME/go
set -gx PYENV_ROOT $HOME/.pyenv

# Setup PATH (fish_add_path ensures no duplicates and correct prepending)
fish_add_path ~/bin
fish_add_path /opt/homebrew/bin
fish_add_path $GOPATH/bin
fish_add_path $PYENV_ROOT/bin

if test -d $HOME/node_modules/.bin
    fish_add_path $HOME/node_modules/.bin
end

fish_add_path $HOME/.antigravity/antigravity/bin

# SDKMAN (Java, Kotlin, Gradle etc.)
# Note: `sdk` command requires bash. Use `bash -c "source ~/.sdkman/bin/sdkman-init.sh && sdk ..."` if needed.
set -gx SDKMAN_DIR "$HOME/.sdkman"
if test -d "$SDKMAN_DIR/candidates"
    for candidate_bin in $SDKMAN_DIR/candidates/*/current/bin
        fish_add_path $candidate_bin
    end
end

# Environment initializers
if status is-interactive
    if command -sq anyenv
        anyenv init - fish | source
    end
    if command -sq rbenv
        rbenv init - fish | source
    end
    if command -sq pyenv
        pyenv init - fish | source
    end
    if command -sq nodenv
        nodenv init - fish | source
    end
end
