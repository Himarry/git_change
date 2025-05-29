@echo off

setlocal enabledelayedexpansion

chcp 932 > nul

title Git設定変更ツール


:: Pythonスクリプトのパスを設定
set SCRIPT_PATH=%~dp0git_config_changer.py


:menu

cls

echo ======================================
echo       Git設定変更ツール メニュー
echo ======================================
echo.
echo  1. 現在のGit設定を表示
echo  2. Git設定を変更
echo  3. 設定プロファイルを保存
echo  4. プロファイル一覧を表示
echo  5. プロファイルを読み込んで適用
echo  6. プロファイルを削除
echo  0. 終了
echo.
echo ======================================
echo.

set /p choice=選択してください (0-6): 

if "%choice%"=="0" goto :exit
if "%choice%"=="1" goto :show_current
if "%choice%"=="2" goto :change_config
if "%choice%"=="3" goto :save_profile
if "%choice%"=="4" goto :list_profiles
if "%choice%"=="5" goto :load_profile
if "%choice%"=="6" goto :delete_profile

echo 無効な選択です。もう一度選択してください。
timeout /t 2 > nul
goto :menu


:show_current
cls

echo ======================================
echo       現在のGit設定
echo ======================================
echo.
echo どの設定を表示しますか？
echo  1. グローバル設定 (全リポジトリ共通)
echo  2. ローカル設定 (現在のリポジトリのみ)
echo  3. 両方の設定を表示
echo.
set /p scope_choice=選択してください (1-3): 

echo.
if "%scope_choice%"=="1" (
    REM グローバル設定のみ表示
    python "%SCRIPT_PATH%" current
) else if "%scope_choice%"=="2" (
    REM ローカル設定のみ表示
    python "%SCRIPT_PATH%" current --local
) else if "%scope_choice%"=="3" (
    REM 両方の設定を表示
    echo グローバル設定:
    echo ----------------
    python "%SCRIPT_PATH%" current
    echo.
    echo ローカル設定:
    echo ----------------
    python "%SCRIPT_PATH%" current --local
) else (
    REM 無効な選択の場合
    echo 無効な選択です。グローバル設定を表示します。
    python "%SCRIPT_PATH%" current
)

echo.
echo ======================================
echo.
pause
goto :menu


:change_config
cls

echo ======================================
echo       Git設定変更
echo ======================================
echo.
echo どの設定を変更しますか？
echo  1. グローバル設定 (全リポジトリ共通)
echo  2. ローカル設定 (現在のリポジトリのみ)
echo  3. 両方一括変更
echo.
set /p scope_choice=選択してください (1-3): 

echo.
echo 設定を変更します。空白の場合は変更しません。
echo.
set /p new_name=新しいユーザー名（空白の場合は変更なし）: 
set /p new_email=新しいメールアドレス（空白の場合は変更なし）: 

if "%scope_choice%"=="3" (
    REM 両方一括変更の場合
    echo.
    echo グローバル設定とローカル設定の両方を変更します...
    
    REM グローバル設定変更
    set cmd_global=python "%SCRIPT_PATH%" set
    if not "!new_name!"=="" set cmd_global=!cmd_global! --name "!new_name!"
    if not "!new_email!"=="" set cmd_global=!cmd_global! --email "!new_email!"
    
    echo.
    echo グローバル設定の変更: !cmd_global!
    echo.
    !cmd_global!
    
    REM ローカル設定変更
    set cmd_local=python "%SCRIPT_PATH%" set
    if not "!new_name!"=="" set cmd_local=!cmd_local! --name "!new_name!"
    if not "!new_email!"=="" set cmd_local=!cmd_local! --email "!new_email!"
    set cmd_local=!cmd_local! --local
    
    echo.
    echo ローカル設定の変更: !cmd_local!
    echo.
    !cmd_local!
) else (
    REM 個別設定変更の場合
    set cmd=python "%SCRIPT_PATH%" set
    if not "!new_name!"=="" set cmd=!cmd! --name "!new_name!"
    if not "!new_email!"=="" set cmd=!cmd! --email "!new_email!"
    if "%scope_choice%"=="2" set cmd=!cmd! --local
    
    echo.
    echo 実行: !cmd!
    echo.
    !cmd!
)
echo.
echo ======================================
echo.
pause
goto :menu


:save_profile
cls

echo ======================================
echo       プロファイル保存
echo ======================================
echo.
set /p profile_name=プロファイル名: 
echo.
echo 現在の設定を使用するか、新しい設定を指定できます。
echo 空白の場合は現在の設定が使用されます。
echo.
set /p use_current=現在の設定を使用しますか？ (Y/N): 

if /i "!use_current!"=="Y" (
    python "%SCRIPT_PATH%" save "!profile_name!"
) else (
    set /p new_name=新しいユーザー名: 
    set /p new_email=新しいメールアドレス: 
    
    set cmd=python "%SCRIPT_PATH%" save "!profile_name!"
    if not "!new_name!"=="" set cmd=!cmd! --name "!new_name!"
    if not "!new_email!"=="" set cmd=!cmd! --email "!new_email!"
    
    !cmd!
)
echo.
echo ======================================
echo.
pause
goto :menu


:list_profiles
cls

echo ======================================
echo       プロファイル一覧
echo ======================================
echo.
python "%SCRIPT_PATH%" list
echo.
echo ======================================
echo.
pause
goto :menu


:load_profile
cls

echo ======================================
echo       プロファイル読み込み
echo ======================================
echo.
echo 利用可能なプロファイル:
echo --------------------------
python "%SCRIPT_PATH%" list
echo --------------------------
echo.
set /p profile_name=読み込むプロファイル名: 
echo.
echo どの設定に適用しますか？
echo  1. グローバル設定 (全リポジトリ共通)
echo  2. ローカル設定 (現在のリポジトリのみ)
echo  3. 両方に一括適用
echo.
set /p scope_choice=選択してください (1-3): 

echo.
if "%scope_choice%"=="1" (
    REM グローバル設定のみ適用
    python "%SCRIPT_PATH%" load "!profile_name!"
) else if "%scope_choice%"=="2" (
    REM ローカル設定のみ適用
    python "%SCRIPT_PATH%" load "!profile_name!" --local
) else if "%scope_choice%"=="3" (
    REM 両方に一括適用
    echo グローバル設定とローカル設定の両方にプロファイルを適用します...
    
    REM グローバル設定に適用
    echo.
    echo グローバル設定に適用:
    python "%SCRIPT_PATH%" load "!profile_name!"
    
    REM ローカル設定に適用
    echo.
    echo ローカル設定に適用:
    python "%SCRIPT_PATH%" load "!profile_name!" --local
) else (
    REM 無効な選択の場合
    echo 無効な選択です。グローバル設定に適用します。
    python "%SCRIPT_PATH%" load "!profile_name!"
)

echo.
echo ======================================
echo.
pause
goto :menu


:delete_profile
cls

echo ======================================
echo       プロファイル削除
echo ======================================
echo.
echo 利用可能なプロファイル:
echo --------------------------
python "%SCRIPT_PATH%" list
echo --------------------------
echo.
set /p profile_name=削除するプロファイル名: 
echo.
set /p confirm=本当に削除しますか？ (Y/N): 
if /i "!confirm!"=="Y" (
    python "%SCRIPT_PATH%" delete "!profile_name!"
) else (
    echo 削除をキャンセルしました。
)
echo.
echo ======================================
echo.
pause
goto :menu


:exit
cls
echo Git設定変更ツールを終了します。
timeout /t 2 > nul
exit /b 0