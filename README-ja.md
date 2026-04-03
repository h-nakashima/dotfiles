# h-nakashima’s dotfiles

*他の言語で読む: [English](README.md), [日本語](README-ja.md).*

## インストール方法

このリポジトリは [chezmoi](https://chezmoi.io/) を使用して管理されています。

**注意:** これらのドットファイルを試したい場合は、まずこのリポジトリをフォークし、コードをレビューして、不要な設定を削除してください。それが何を意味するのかを理解せずに私の設定を盲目的に使用しないでください。自己責任でご使用ください！

### クイックインストール (chezmoiを使用)

新しいマシンに初期の手っ取り早いセットアップを行いたい場合は、`chezmoi` を使えば1行のコマンドで初期化とすべての適用（Oh My Zsh のインストールを含む）が行われます：

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply h-nakashima
```

今後、このリポジトリの最新の変更を適用してアップデートしたい場合は、以下のコマンドを実行します：

```bash
chezmoi update
```

### ローカル開発の設定 (ghq や任意のパスを使用する場合)

このリポジトリを特定の場所（例: `~/git/github.com/h-nakashima/dotfiles`）にクローンしている場合、`chezmoi` にそのフォルダをソースディレクトリとして認識させることができます。

1. リポジトリをクローンします。
2. `~/.config/chezmoi/chezmoi.toml` を作成し、以下の内容を設定します：
   ```toml
   sourceDir = "~/git/github.com/h-nakashima/dotfiles"
   
   [sourceVCS]
       autoCommit = false
       autoPush = false
   ```
3. 設定をホームディレクトリに適用します：
   ```bash
   chezmoi apply
   ```

## 日頃のワークフローと同期

`chezmoi` を使うと、ホームディレクトリとこのリポジトリの間をきれいに分離して保つことができます。

### ファイルの編集
ドットファイルを直接編集し、かつ自動的にリポジトリ側に変更を反映させるには：
```bash
chezmoi edit ~/.zshrc
```

### ローカルで直接編集してしまった場合（取り込み）
もし `~/.zshrc` などをホームディレクトリで直接編集してしまい、その変更をリポジトリ（chezmoi側）に吸収させたい場合は：
```bash
chezmoi add ~/.zshrc
```

## カスタマイズ

### `$PATH` の指定

`~/.path` ファイルが存在する場合、各種判定が行われる前に他のファイルと一緒に読み込まれます。
`/usr/local/bin` を `$PATH` に追加する `~/.path` ファイルの例：

```bash
export PATH="/usr/local/bin:$PATH"
```

### フォークせずに独自のコマンドを追加する

`~/.extra` ファイルが存在する場合、他のファイルと一緒に読み込まれます。このリポジトリ全体をフォークせずに独自のコマンドをいくつか追加したり、公開リポジトリにはコミットしたくない設定を追加するのに便利です。

`~/.extra` の例は以下の通りです：

```bash
# Git credentials
# 誤って自分の名前でコミットするのを防ぐため、リポジトリには含めません
GIT_AUTHOR_NAME="h-nakashima"
GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"
git config --global user.name "$GIT_AUTHOR_NAME"
GIT_AUTHOR_EMAIL="h-nakashima@users.noreply.github.com"
GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL"
git config --global user.email "$GIT_AUTHOR_EMAIL"
```

### macOS のデフォルト設定スクリプト

新しいMacをセットアップする際に、いくつかの合理的なmacOSのデフォルト設定を適用したい場合があります。これらのスクリプトは意図的に `chezmoi` の同期から除外されており、リポジトリディレクトリから直接 **手動で** 実行する必要があります：

```bash
./.macos
```

## セキュリティ: クレデンシャル（機密情報）の管理

### ルール: 追跡対象のファイルに機密情報を絶対に入れない

このdotfilesリポジトリは公開されています。**APIキー、パスワード、トークンなどの機密情報は絶対にコミットしないでください。**

機密情報は以下のいずれかの場所に配置する必要があります：

- **`~/.extra`** — chezmoi によって無視される機密データ用のファイル。
- **`~/.netrc`** — `~/.gitignore` (`dot_gitignore`) によってグローバルに除外されます。
- **`~/.env`** — `~/.gitignore` (`dot_gitignore`) によってグローバルに除外されます。

### `~/.extra` によるシークレット管理

`~/.extra` が存在する場合、`~/.zsh_profile` によって自動的に読み込まれます。
APIキーや個人的な設定はここに配置してください：

```bash
# ~/.extra の例 (このファイルは絶対にリポジトリにコミットしないでください)

# API Keys
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="..."

# Personal Git configuration
export GIT_AUTHOR_NAME="h-nakashima"
export GIT_AUTHOR_EMAIL="h-nakashima@users.noreply.github.com"

# Machine-specific settings
export WORK_PROXY="http://proxy.example.com:8080"
```

### git-secrets による自動保護機能

このリポジトリは、[git-secrets](https://github.com/awslabs/git-secrets) を使用した pre-commit フックで構成されています。
以下のパターンのいずれかが検出された場合、コミットは自動的にブロックされます：

- AWS Access Keys と Secret Keys
- SSH アクセス用の Identity files
- Personal Access Tokens (例: GitHub)
- AI Provider Tokens (例: OpenAI)
- Chat Platform Tokens (例: Slack)

偶発的な漏洩を防ぐため、ローカルで作業する際はこのフックをインストールしたままにしてください。

## フィードバック

提案や改善点は [Issueへどうぞ](https://github.com/h-nakashima/dotfiles/issues)！
