# h-nakashima's dotfiles

*Read this in other languages: [English](README.md), [日本語](README-ja.md).*

## Overview

A modern, fast development environment managed with [chezmoi](https://chezmoi.io/), powered by **Fish Shell** and **Starship** prompt.

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don't want or need. Don't blindly use my settings unless you know what that entails. Use at your own risk!

## Installation

### Quick Install (New machine)

Run a single command to install `chezmoi`, clone this repo, and apply everything automatically:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply h-nakashima
```

This will automatically:
- Install Homebrew packages (from `Brewfile`)
- Install **Fish** and **Starship**
- Set Fish as the default shell (`chsh`)
- Migrate your Zsh history to Fish history
- Apply macOS settings (runs once)
- Configure Git hooks (via git-secrets)

To pull and apply the latest changes later:

```bash
chezmoi update
```

### Local Development Setup

If you clone this repository to a specific location (e.g. with `ghq`), tell `chezmoi` to use that as its source directory.

1. Clone the repository:
   ```bash
   ghq get h-nakashima/dotfiles
   ```
2. Create `~/.config/chezmoi/chezmoi.toml`:
   ```toml
   sourceDir = "~/git/github.com/h-nakashima/dotfiles"

   [sourceVCS]
       autoCommit = false
       autoPush = false
   ```
3. Apply the dotfiles:
   ```bash
   chezmoi apply
   ```

## Shell Environment

This setup uses **Fish Shell** + **Starship** instead of Zsh.

| Feature | How it works |
|---|---|
| Prompt | Starship (shows git branch, language versions, etc.) |
| History search | `Ctrl+R` via peco |
| File search | `Ctrl+F` via peco |
| Git shortcuts | `Ctrl+G, L` (ghq), `Ctrl+G, B` (branch), `Ctrl+G, A` (git add) |
| Directory history | `Alt+←` / `Alt+→` (`prevd` / `nextd`) |
| Aliases | `~/.config/fish/conf.d/aliases.fish` |
| Environment variables | `~/.config/fish/conf.d/exports.fish` |

## Daily Workflow

### Editing a dotfile
```bash
chezmoi edit ~/.config/fish/conf.d/aliases.fish
```

### Absorbing accidental local edits back into the repo
```bash
chezmoi add ~/.config/fish/conf.d/aliases.fish
```

### Pushing changes
```bash
cd ~/git/github.com/h-nakashima/dotfiles
git add -A && git commit -m "your message" && git push
```

## Customization

### Adding custom commands without forking

If `~/.extra` exists, place personal or sensitive configuration here (it is never committed to the repo):

```fish
# ~/.extra (Fish syntax — never commit this file)

# API Keys
set -gx OPENAI_API_KEY "sk-..."
set -gx ANTHROPIC_API_KEY "..."

# Machine-specific settings
set -gx WORK_PROXY "http://proxy.example.com:8080"
```

### Personal vs Work configuration

At `chezmoi init` time, you will be asked:
- Is this a personal machine? (`isPersonal`)
- Your Git user name and email

This controls which sections of the `Brewfile` and `.gitconfig` are applied.
You can review or edit these settings at any time:

```bash
cat ~/.config/chezmoi/chezmoi.toml
```

## Security

### Never put secrets in tracked files

This repository is **public**. Never commit API keys, passwords, or tokens.

Place sensitive data in:
- **`~/.extra`** — Sourced automatically, ignored by chezmoi.
- **`~/.netrc`** — Excluded via `~/.gitignore`.
- **`~/.env`** — Excluded via `~/.gitignore`.

### Automatic safeguards with git-secrets

A pre-commit hook using [git-secrets](https://github.com/awslabs/git-secrets) is automatically installed via `chezmoi apply`. It blocks commits containing:

- AWS Access Keys / Secret Keys
- SSH identity files
- Personal Access Tokens (GitHub, etc.)
- AI Provider Tokens (OpenAI, etc.)
- Chat platform tokens (Slack, etc.)

## Feedback

Suggestions/improvements [welcome](https://github.com/h-nakashima/dotfiles/issues)!