# h-nakashima’s dotfiles

*Read this in other languages: [English](README.md), [日本語](README-ja.md).*

## Installation

This repository is managed using [chezmoi](https://chezmoi.io/). 

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Quick Install (Using chezmoi)

If you just want to install these dotfiles on a new machine, `chezmoi` provides a one-liner to initialize and apply everything (including Oh My Zsh installation):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply h-nakashima
```

To update your environment with the latest changes from this repository later on:

```bash
chezmoi update
```

### Local Development Setup (Using ghq or custom path)

If you clone this repository to a specific location (e.g., `~/git/github.com/h-nakashima/dotfiles`), you can tell `chezmoi` to use that as its source directory.

1. Clone the repository.
2. Create `~/.config/chezmoi/chezmoi.toml` with the following content:
   ```toml
   sourceDir = "~/git/github.com/h-nakashima/dotfiles"
   
   [sourceVCS]
       autoCommit = false
       autoPush = false
   ```
3. Apply the dotfiles to your home directory:
   ```bash
   chezmoi apply
   ```

## Daily Workflow & Syncing

With `chezmoi`, you can maintain a clean separation between your home directory and this repository.

### Editing files
To edit a dotfile (and automatically staging the change in the repo):
```bash
chezmoi edit ~/.zshrc
```

### Accidental local edits
If you accidentally edited `~/.zshrc` directly and want to absorb those local changes back into this repository:
```bash
chezmoi add ~/.zshrc
```

## Customization

### Specify the `$PATH`

If `~/.path` exists, it will be sourced along with the other files, before any feature testing (such as detecting which version of `ls` is being used) takes place.

Here’s an example `~/.path` file that adds `/usr/local/bin` to the `$PATH`:

```bash
export PATH="/usr/local/bin:$PATH"
```

### Add custom commands without creating a new fork

If `~/.extra` exists, it will be sourced along with the other files. You can use this to add a few custom commands without the need to fork this entire repository, or to add commands you don’t want to commit to a public repository.

My `~/.extra` looks something like this:

```bash
# Git credentials
# Not in the repository, to prevent people from accidentally committing under my name
GIT_AUTHOR_NAME="h-nakashima"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="h-nakashima@users.noreply.github.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### Sensible macOS defaults

When setting up a new Mac, you may want to set some sensible macOS defaults. These scripts are intentionally excluded from `chezmoi` sync and should be run manually from the repository directory:

```bash
./.macos
```

## Security: Keeping credentials out of the repository

### Rule: Never put secrets in tracked files

This dotfiles repository is public. **NEVER commit any sensitive information such as API keys, passwords, or tokens.**

Sensitive information should be placed in one of the following locations:

- **`~/.extra`** — A file for sensitive data that is ignored by chezmoi.
- **`~/.netrc`** — Globably excluded via `~/.gitignore` (`dot_gitignore`).
- **`~/.env`** — Globably excluded via `~/.gitignore` (`dot_gitignore`).

### Managing Secrets with `~/.extra`

If `~/.extra` exists, it will be automatically sourced by `~/.zsh_profile`.
Place your API keys and personal settings here:

```bash
# Example ~/.extra (Do NOT commit this file to the repository)

# API Keys
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="..."

# Personal Git configuration
export GIT_AUTHOR_NAME="h-nakashima"
export GIT_AUTHOR_EMAIL="h-nakashima@users.noreply.github.com"

# Machine-specific settings
export WORK_PROXY="http://proxy.example.com:8080"
```

### Automatic Safeguards with git-secrets

This repository is configured with a pre-commit hook using [git-secrets](https://github.com/awslabs/git-secrets).
Commits will be automatically blocked if any of the following patterns are detected:

- AWS Access Keys and Secret Keys
- Identity files used for Secure Shell access
- Personal Access Tokens (e.g. GitHub)
- AI Provider Tokens (e.g. OpenAI)
- Chat Platform Tokens (e.g. Slack)

When working locally, please keep these hooks installed to prevent accidental leaks.

## Feedback

Suggestions/improvements
[welcome](https://github.com/h-nakashima/dotfiles/issues)!