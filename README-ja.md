# h-nakashima's dotfiles

*他の言語で読む: [English](README.md), [日本語](README-ja.md).*

## 概要

[chezmoi](https://chezmoi.io/) で管理する、**Fish Shell** + **Starship** を使った爆速でモダンな開発環境です。

**注意:** これらのドットファイルを試したい場合は、まずこのリポジトリをフォークし、コードをレビューして、不要な設定を削除してください。自己責任でご使用ください！

## インストール

### クイックインストール（新しいマシンへのセットアップ）

以下の1行のコマンドで `chezmoi` のインストール・リポジトリのクローン・全設定の適用まで自動で行われます：

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply h-nakashima
```

このコマンドにより以下が自動的に実行されます：
- Homebrew パッケージのインストール（`Brewfile` に基づく）
- **Fish** と **Starship** のインストール
- Fish をデフォルトシェルに設定（`chsh`）
- Zsh の履歴を Fish の履歴形式に移行
- macOS 設定の適用（初回のみ）
- Git フックの設定（git-secrets によるセキュリティ保護）

以降、最新の変更を取り込む場合：

```bash
chezmoi update
```

### ローカル開発環境のセットアップ

リポジトリを特定の場所にクローンして管理する場合（例：`ghq` を使う場合）：

1. リポジトリをクローンします：
   ```bash
   ghq get h-nakashima/dotfiles
   ```
2. `~/.config/chezmoi/chezmoi.toml` を作成します：
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

## シェル環境

Zsh の代わりに **Fish Shell** + **Starship** を使用しています。

| 機能 | 操作方法 |
|---|---|
| プロンプト | Starship（gitブランチ・言語バージョン等をリアルタイム表示） |
| 履歴検索 | `Ctrl+R`（peco連携） |
| ファイル検索 | `Ctrl+F`（peco連携） |
| Git ショートカット | `Ctrl+G, L`（ghqリポジトリ移動）、`Ctrl+G, B`（ブランチ切替）、`Ctrl+G, A`（git add） |
| ディレクトリ履歴 | `Alt+←` / `Alt+→`（`prevd` / `nextd`） |
| エイリアス | `~/.config/fish/conf.d/aliases.fish` |
| 環境変数 | `~/.config/fish/conf.d/exports.fish` |

## 日頃のワークフロー

### ドットファイルを編集する
```bash
chezmoi edit ~/.config/fish/conf.d/aliases.fish
```

### ローカルで直接編集してしまった変更をリポジトリに吸収する
```bash
chezmoi add ~/.config/fish/conf.d/aliases.fish
```

### 変更をプッシュする
```bash
cd ~/git/github.com/h-nakashima/dotfiles
git add -A && git commit -m "変更内容" && git push
```

## カスタマイズ

### フォークせずに独自設定を追加する

`~/.extra` が存在する場合は個人的な設定や機密情報を記述できます（このファイルはリポジトリにコミットされません）：

```fish
# ~/.extra (Fish 構文 — このファイルは絶対にコミットしないでください)

# API キー
set -gx OPENAI_API_KEY "sk-..."
set -gx ANTHROPIC_API_KEY "..."

# マシン固有の設定
set -gx WORK_PROXY "http://proxy.example.com:8080"
```

### 個人用 / 仕事用の環境分離

`chezmoi init` 時に以下を質問されます：
- このマシンは個人用ですか？（`isPersonal`）
- Git のユーザー名とメールアドレス

これにより `Brewfile` と `.gitconfig` の適用内容が切り替わります。
設定内容はいつでも確認・編集できます：

```bash
cat ~/.config/chezmoi/chezmoi.toml
```

## セキュリティ

### 追跡対象のファイルに機密情報を絶対に置かない

このリポジトリは**公開されています**。APIキー・パスワード・トークン等は絶対にコミットしないでください。

機密情報は以下のいずれかの場所に配置してください：
- **`~/.extra`** — 自動で読み込まれ、chezmoi から除外されます。
- **`~/.netrc`** — `~/.gitignore` によってグローバルに除外されます。
- **`~/.env`** — `~/.gitignore` によってグローバルに除外されます。

### git-secrets による自動的な安全対策

`chezmoi apply` 実行時に [git-secrets](https://github.com/awslabs/git-secrets) を使った pre-commit フックが自動でインストールされます。以下のパターンが検出されるとコミットが自動的にブロックされます：

- AWS Access Keys / Secret Keys
- SSH アクセス用の identity files
- Personal Access Tokens（GitHub 等）
- AI Provider Tokens（OpenAI 等）
- Chat プラットフォームのトークン（Slack 等）

## フィードバック

提案や改善点は [Issue へどうぞ](https://github.com/h-nakashima/dotfiles/issues)！
