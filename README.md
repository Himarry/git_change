# Git設定管理ツール

このスクリプトは、Gitのユーザー名とメールアドレスを簡単に変更・管理するためのツールです。複数のプロファイルを保存し、必要に応じて切り替えることができます。

## 機能

- 現在のGit設定（ユーザー名とメールアドレス）の表示
- Git設定の変更
- 設定プロファイルの保存
- 保存されたプロファイル一覧の表示
- プロファイルの読み込みと適用
- プロファイルの削除

## インストール

特別なインストールは必要ありません。Pythonがインストールされていれば実行できます。

## 使い方

### 現在の設定を表示

```
python git_config_changer.py current
```

### Git設定を変更

```
python git_config_changer.py set --name "新しい名前" --email "新しいメール@example.com"
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
python git_config_changer.py load プロファイル名
```

### プロファイルを削除

```
python git_config_changer.py delete プロファイル名
```

## 設定ファイル

プロファイル情報は `~/.git_profiles/profiles.json` に保存されます。

## 注意事項

このスクリプトはグローバルGit設定（`--global`）を変更します。特定のリポジトリのみの設定を変更したい場合は、スクリプトを修正する必要があります。
