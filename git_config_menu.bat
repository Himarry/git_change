@echo off
setlocal enabledelayedexpansion
chcp 932 > nul
title Git�ݒ�ύX�c�[��

:: Python�X�N���v�g�̃p�X��ݒ�
set SCRIPT_PATH=%~dp0git_config_changer.py

:menu
cls
echo ======================================
echo       Git�ݒ�ύX�c�[�� ���j���[
echo ======================================
echo.
echo  1. ���݂�Git�ݒ��\��
echo  2. Git�ݒ��ύX
echo  3. �ݒ�v���t�@�C����ۑ�
echo  4. �v���t�@�C���ꗗ��\��
echo  5. �v���t�@�C����ǂݍ���œK�p
echo  6. �v���t�@�C�����폜
echo  0. �I��
echo.
echo ======================================
echo.

set /p choice=�I�����Ă������� (0-6): 

if "%choice%"=="0" goto :exit
if "%choice%"=="1" goto :show_current
if "%choice%"=="2" goto :change_config
if "%choice%"=="3" goto :save_profile
if "%choice%"=="4" goto :list_profiles
if "%choice%"=="5" goto :load_profile
if "%choice%"=="6" goto :delete_profile

echo �����ȑI���ł��B������x�I�����Ă��������B
timeout /t 2 > nul
goto :menu

:show_current
cls
echo ======================================
echo       ���݂�Git�ݒ�
echo ======================================
echo.
echo �ǂ̐ݒ��\�����܂����H
echo  1. �O���[�o���ݒ� (�S���|�W�g������)
echo  2. ���[�J���ݒ� (���݂̃��|�W�g���̂�)
echo  3. �����̐ݒ��\��
echo.
set /p scope_choice=�I�����Ă������� (1-3): 

echo.
if "%scope_choice%"=="1" (
    python "%SCRIPT_PATH%" current
) else if "%scope_choice%"=="2" (
    python "%SCRIPT_PATH%" current --local
) else if "%scope_choice%"=="3" (
    echo �O���[�o���ݒ�:
    echo ----------------
    python "%SCRIPT_PATH%" current
    echo.
    echo ���[�J���ݒ�:
    echo ----------------
    python "%SCRIPT_PATH%" current --local
) else (
    echo �����ȑI���ł��B�O���[�o���ݒ��\�����܂��B
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
echo       Git�ݒ�ύX
echo ======================================
echo.
echo �ǂ̐ݒ��ύX���܂����H
echo  1. �O���[�o���ݒ� (�S���|�W�g������)
echo  2. ���[�J���ݒ� (���݂̃��|�W�g���̂�)
echo  3. �����ꊇ�ύX
echo.
set /p scope_choice=�I�����Ă������� (1-3): 

echo.
echo �ݒ��ύX���܂��B�󔒂̏ꍇ�͕ύX���܂���B
echo.
set /p new_name=�V�������[�U�[���i�󔒂̏ꍇ�͕ύX�Ȃ��j: 
set /p new_email=�V�������[���A�h���X�i�󔒂̏ꍇ�͕ύX�Ȃ��j: 

if "%scope_choice%"=="3" (
    echo.
    echo �O���[�o���ݒ�ƃ��[�J���ݒ�̗�����ύX���܂�...
    
    set cmd_global=python "%SCRIPT_PATH%" set
    if not "!new_name!"=="" set cmd_global=!cmd_global! --name "!new_name!"
    if not "!new_email!"=="" set cmd_global=!cmd_global! --email "!new_email!"
    
    echo.
    echo �O���[�o���ݒ�̕ύX:
    !cmd_global!
    
    set cmd_local=python "%SCRIPT_PATH%" set
    if not "!new_name!"=="" set cmd_local=!cmd_local! --name "!new_name!"
    if not "!new_email!"=="" set cmd_local=!cmd_local! --email "!new_email!"
    set cmd_local=!cmd_local! --local
    
    echo.
    echo ���[�J���ݒ�̕ύX:
    !cmd_local!
) else (
    set cmd=python "%SCRIPT_PATH%" set
    if not "!new_name!"=="" set cmd=!cmd! --name "!new_name!"
    if not "!new_email!"=="" set cmd=!cmd! --email "!new_email!"
    if "%scope_choice%"=="2" set cmd=!cmd! --local
    
    echo.
    echo ���s:
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
echo       �v���t�@�C���ۑ�
echo ======================================
echo.
set /p profile_name=�v���t�@�C����: 
echo.
echo ���݂̐ݒ���g�p���邩�A�V�����ݒ���w��ł��܂��B
echo �󔒂̏ꍇ�͌��݂̐ݒ肪�g�p����܂��B
echo.
set /p use_current=���݂̐ݒ���g�p���܂����H (Y/N): 

if /i "!use_current!"=="Y" (
    python "%SCRIPT_PATH%" save "!profile_name!"
) else (
    set /p new_name=�V�������[�U�[��: 
    set /p new_email=�V�������[���A�h���X: 
    
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
echo       �v���t�@�C���ꗗ
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
echo       �v���t�@�C���ǂݍ���
echo ======================================
echo.
echo ���p�\�ȃv���t�@�C��:
echo --------------------------
python "%SCRIPT_PATH%" list
echo --------------------------
echo.
set /p profile_name=�ǂݍ��ރv���t�@�C����: 
echo.
echo �ǂ̐ݒ�ɓK�p���܂����H
echo  1. �O���[�o���ݒ� (�S���|�W�g������)
echo  2. ���[�J���ݒ� (���݂̃��|�W�g���̂�)
echo  3. �����Ɉꊇ�K�p
echo.
set /p scope_choice=�I�����Ă������� (1-3): 

echo.
if "%scope_choice%"=="1" (
    python "%SCRIPT_PATH%" load "!profile_name!"
) else if "%scope_choice%"=="2" (
    python "%SCRIPT_PATH%" load "!profile_name!" --local
) else if "%scope_choice%"=="3" (
    echo �O���[�o���ݒ�ƃ��[�J���ݒ�̗����Ƀv���t�@�C����K�p���܂�...
    
    echo.
    echo �O���[�o���ݒ�ɓK�p:
    python "%SCRIPT_PATH%" load "!profile_name!"
    
    echo.
    echo ���[�J���ݒ�ɓK�p:
    python "%SCRIPT_PATH%" load "!profile_name!" --local
) else (
    echo �����ȑI���ł��B�O���[�o���ݒ�ɓK�p���܂��B
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
echo       �v���t�@�C���폜
echo ======================================
echo.
echo ���p�\�ȃv���t�@�C��:
echo --------------------------
python "%SCRIPT_PATH%" list
echo --------------------------
echo.
set /p profile_name=�폜����v���t�@�C����: 
echo.
set /p confirm=�{���ɍ폜���܂����H (Y/N): 
if /i "!confirm!"=="Y" (
    python "%SCRIPT_PATH%" delete "!profile_name!"
) else (
    echo �폜���L�����Z�����܂����B
)
echo.
echo ======================================
echo.
pause
goto :menu

:exit
cls
echo Git�ݒ�ύX�c�[�����I�����܂��B
timeout /t 2 > nul
exit /b 0
