# Editors
set -gx EDITOR nano
set -gx SVN_EDITOR nano

# Node REPL
set -gx NODE_REPL_HISTORY ~/.node_history
set -gx NODE_REPL_HISTORY_SIZE 32768
set -gx NODE_REPL_MODE sloppy

# Python
set -gx PYTHONIOENCODING UTF-8

# Zsh/Bash History (For compatibility if subshells are launched)
set -gx HISTFILE "$HOME/Library/Mobile Documents/com~apple~CloudDocs/.zsh_history"
set -gx HISTSIZE 1000000
set -gx HISTCONTROL ignoredups
set -gx HISTIGNORE pwd:ls:la:ll:lla:exit

# Locale and Pager
set -gx LANG ja_JP.UTF-8
set -gx LC_ALL ja_JP.UTF-8
set -gx MANPAGER "less -X"
set -gx GPG_TTY (tty)

# Tool paths
set -gx ANDROIDNDK_HOME /Developer/android-ndk-r8b
set -gx ANDROIDSDK_HOME /Developer/android-sdks
set -gx NODE_PATH $HOME/.npm/lib $NODE_PATH
set -gx MANPATH $HOME/.npm/man $MANPATH
set -gx GOPATH $HOME/go
set -gx PYENV_ROOT $HOME/.pyenv

# Setup PATH (fish_add_path ensures no duplicates and correct prepending)
fish_add_path ~/bin
fish_add_path /opt/homebrew/bin
fish_add_path $ANDROIDSDK_HOME/platform-tools
fish_add_path $ANDROIDNDK_HOME
fish_add_path $HOME/.npm/bin
fish_add_path $GOPATH/bin
fish_add_path $HOME/.nodebrew/current/bin
fish_add_path $HOME/.yarn/bin
fish_add_path /usr/local/opt/imagemagick@6/bin
fish_add_path $PYENV_ROOT/bin
fish_add_path $HOME/.anyenv/envs/nodenv/bin

if test -d $HOME/node_modules/.bin
    fish_add_path $HOME/node_modules/.bin
end

fish_add_path $HOME/.antigravity/antigravity/bin

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
