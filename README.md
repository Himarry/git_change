# Git設定管理ツール

このスクリプトは、Gitのユーザー名とメールアドレスを簡単に変更・管理するためのツールです。複数のプロファイルを保存し、必要に応じて切り替えることができます。

## 機能

- 現在のGit設定（ユーザー名とメールアドレス）の表示（グローバル・ローカル両対応、一括表示可能）
- Git設定の変更（グローバル・ローカル両対応、一括変更可能）
- 設定プロファイルの保存
- 保存されたプロファイル一覧の表示
- プロファイルの読み込みと適用（グローバル・ローカル両対応、一括適用可能）
- プロファイルの削除

## インストール

特別なインストールは必要ありません。Pythonがインストールされていれば実行できます。

## 使い方

### 現在の設定を表示

```
# グローバル設定を表示
python git_config_changer.py current

# ローカル設定を表示
python git_config_changer.py current --local
```

### Git設定を変更

```
# グローバル設定を変更
python git_config_changer.py set --name "新しい名前" --email "新しいメール@example.com"

# ローカル設定を変更
python git_config_changer.py set --name "新しい名前" --email "新しいメール@example.com" --local
```

### 現在の設定をプロファイルとして保存

```
python git_config_changer.py save プロファイル名
```

### 特定の設定をプロファイルとして保存

```
python git_config_changer.py save プロファイル名 --name "名前" --email "メール@example.com"
```

### 保存されたプロファイル一覧を表示

```
python git_config_changer.py list
```

### プロファイルを読み込んで適用

```
# グローバル設定に適用
python git_config_changer.py load プロファイル名

# ローカル設定に適用
python git_config_changer.py load プロファイル名 --local
```

### プロファイルを削除

```
python git_config_changer.py delete プロファイル名
```

## 設定ファイル

プロファイル情報は `~/.git_profiles/profiles.json` に保存されます。

## 注意事項

このスクリプトはグローバルGit設定（`--global`）とローカル設定の両方を変更できます。

- グローバル設定：すべてのGitリポジトリに適用される設定です
- ローカル設定：現在のリポジトリにのみ適用される設定です

ローカル設定を変更する場合は、Gitリポジトリ内で実行する必要があります。
