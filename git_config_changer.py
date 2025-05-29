#!/usr/bin/env python
# -*- coding: utf-8 -*-

import subprocess
import os
import sys
import json
import argparse
from pathlib import Path


def get_current_git_config(is_global=True):
    """現在のGit設定を取得する"""
    try:
        # グローバルかローカルかのオプション設定
        global_option = ["--global"] if is_global else []
        
        # ユーザー名を取得
        name_result = subprocess.run(
            ["git", "config"] + global_option + ["user.name"],
            capture_output=True, text=True, check=False
        )
        
        # メールアドレスを取得
        email_result = subprocess.run(
            ["git", "config"] + global_option + ["user.email"],
            capture_output=True, text=True, check=False
        )
        
        current_name = name_result.stdout.strip() if name_result.returncode == 0 else ""
        current_email = email_result.stdout.strip() if email_result.returncode == 0 else ""
        
        return current_name, current_email
        
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        return "", ""


def set_git_config(name, email, is_global=True):
    """Git設定を変更する"""
    try:
        # グローバルかローカルかのオプション設定
        global_option = ["--global"] if is_global else []
        scope_text = "グローバル" if is_global else "ローカル"
        
        # ユーザー名を設定
        if name:
            subprocess.run(
                ["git", "config"] + global_option + ["user.name", name],
                check=True
            )
            print(f"{scope_text} Git ユーザー名を '{name}' に設定しました")
        
        # メールアドレスを設定
        if email:
            subprocess.run(
                ["git", "config"] + global_option + ["user.email", email],
                check=True
            )
            print(f"{scope_text} Git メールアドレスを '{email}' に設定しました")
            
        return True
    
    except subprocess.CalledProcessError as e:
        print(f"Git設定の更新に失敗しました: {e}")
        return False
    except Exception as e:
        print(f"エラーが発生しました: {e}")
        return False


def save_profile(profile_name, name, email, profiles_file):
    """プロファイルを保存する"""
    profiles = {}
    
    # 既存のプロファイルがあれば読み込む
    if os.path.exists(profiles_file):
        try:
            with open(profiles_file, 'r', encoding='utf-8') as f:
                profiles = json.load(f)
        except Exception as e:
            print(f"プロファイル読み込みエラー: {e}")
    
    # プロファイルを更新または追加
    profiles[profile_name] = {
        "name": name,
        "email": email
    }
    
    # プロファイルを保存
    try:
        os.makedirs(os.path.dirname(profiles_file), exist_ok=True)
        with open(profiles_file, 'w', encoding='utf-8') as f:
            json.dump(profiles, f, indent=4, ensure_ascii=False)
        print(f"プロファイル '{profile_name}' を保存しました")
        return True
    except Exception as e:
        print(f"プロファイル保存エラー: {e}")
        return False


def list_profiles(profiles_file):
    """すべてのプロファイルを表示する"""
    if not os.path.exists(profiles_file):
        print("保存されたプロファイルはありません")
        return []
    
    try:
        with open(profiles_file, 'r', encoding='utf-8') as f:
            profiles = json.load(f)
            
        if not profiles:
            print("保存されたプロファイルはありません")
            return []
        
        print("保存されたプロファイル:")
        print("-" * 50)
        for profile_name, profile_data in profiles.items():
            print(f"プロファイル名: {profile_name}")
            print(f"  ユーザー名: {profile_data.get('name', '')}")
            print(f"  メールアドレス: {profile_data.get('email', '')}")
            print("-" * 50)
        
        return list(profiles.keys())
            
    except Exception as e:
        print(f"プロファイル読み込みエラー: {e}")
        return []


def load_profile(profile_name, profiles_file, is_global=True):
    """プロファイルを読み込み設定を適用する"""
    if not os.path.exists(profiles_file):
        print("プロファイルファイルが存在しません")
        return False
    
    try:
        with open(profiles_file, 'r', encoding='utf-8') as f:
            profiles = json.load(f)
        
        if profile_name not in profiles:
            print(f"プロファイル '{profile_name}' が見つかりません")
            return False
        
        profile = profiles[profile_name]
        name = profile.get("name", "")
        email = profile.get("email", "")
        
        if set_git_config(name, email, is_global):
            scope_text = "グローバル" if is_global else "ローカル"
            print(f"{scope_text}設定にプロファイル '{profile_name}' を適用しました")
            return True
        
        return False
        
    except Exception as e:
        print(f"プロファイル読み込みエラー: {e}")
        return False


def delete_profile(profile_name, profiles_file):
    """プロファイルを削除する"""
    if not os.path.exists(profiles_file):
        print("プロファイルファイルが存在しません")
        return False
    
    try:
        with open(profiles_file, 'r', encoding='utf-8') as f:
            profiles = json.load(f)
        
        if profile_name not in profiles:
            print(f"プロファイル '{profile_name}' が見つかりません")
            return False
        
        # プロファイルを削除
        del profiles[profile_name]
        
        # 更新したプロファイルを保存
        with open(profiles_file, 'w', encoding='utf-8') as f:
            json.dump(profiles, f, indent=4, ensure_ascii=False)
        
        print(f"プロファイル '{profile_name}' を削除しました")
        return True
        
    except Exception as e:
        print(f"プロファイル削除エラー: {e}")
        return False


def main():
    # プロファイル保存先ディレクトリの設定
    config_dir = os.path.join(Path.home(), ".git_profiles")
    profiles_file = os.path.join(config_dir, "profiles.json")
      # コマンドライン引数のパーサー作成
    parser = argparse.ArgumentParser(description='Gitのユーザー名とメールアドレスを管理するツール')
    
    # サブコマンドパーサー作成
    subparsers = parser.add_subparsers(dest='command', help='使用するコマンド')
    
    # 現在の設定を表示するコマンド
    current_parser = subparsers.add_parser('current', help='現在のGit設定を表示')
    current_parser.add_argument('--local', action='store_true', help='ローカル設定を表示する')
    
    # 設定変更コマンド
    set_parser = subparsers.add_parser('set', help='Git設定を変更')
    set_parser.add_argument('--name', help='設定するGitユーザー名')
    set_parser.add_argument('--email', help='設定するGitメールアドレス')
    set_parser.add_argument('--local', action='store_true', help='ローカル設定を変更する')
    
    # プロファイル保存コマンド
    save_parser = subparsers.add_parser('save', help='現在の設定をプロファイルとして保存')
    save_parser.add_argument('profile_name', help='プロファイル名')
    save_parser.add_argument('--name', help='設定するGitユーザー名')
    save_parser.add_argument('--email', help='設定するGitメールアドレス')
    
    # プロファイル一覧表示コマンド
    list_parser = subparsers.add_parser('list', help='保存されたプロファイル一覧を表示')
      # プロファイル読み込みコマンド
    load_parser = subparsers.add_parser('load', help='プロファイルを読み込み設定を適用')
    load_parser.add_argument('profile_name', help='プロファイル名')
    load_parser.add_argument('--local', action='store_true', help='ローカル設定に適用する')
    
    # プロファイル削除コマンド
    delete_parser = subparsers.add_parser('delete', help='保存されたプロファイルを削除')
    delete_parser.add_argument('profile_name', help='プロファイル名')
    
    # 引数解析
    args = parser.parse_args()
    
    # コマンドが指定されていない場合はヘルプを表示
    if not args.command:
        parser.print_help()
        sys.exit(1)
      # 現在の設定を表示
    if args.command == 'current':
        is_global = not args.local
        scope_text = "グローバル" if is_global else "ローカル"
        name, email = get_current_git_config(is_global)
        print(f"現在の{scope_text} Git設定:")
        print(f"ユーザー名: {name}")
        print(f"メールアドレス: {email}")
    
    # 設定変更
    elif args.command == 'set':
        if not args.name and not args.email:
            print("エラー: ユーザー名かメールアドレス、またはその両方を指定してください")
            sys.exit(1)
        
        is_global = not args.local
        set_git_config(args.name, args.email, is_global)
    
    # プロファイル保存
    elif args.command == 'save':
        # 引数で指定された値を優先する
        if args.name or args.email:
            name = args.name
            email = args.email
        else:
            # 引数がなければ現在の設定を取得
            name, email = get_current_git_config()
            
        if not name and not email:
            print("エラー: ユーザー名とメールアドレスが設定されていません")
            sys.exit(1)
            
        save_profile(args.profile_name, name, email, profiles_file)
    
    # プロファイル一覧表示
    elif args.command == 'list':
        list_profiles(profiles_file)
      # プロファイル読み込み適用
    elif args.command == 'load':
        is_global = not args.local
        load_profile(args.profile_name, profiles_file, is_global)
    
    # プロファイル削除
    elif args.command == 'delete':
        delete_profile(args.profile_name, profiles_file)


if __name__ == "__main__":
    main()
