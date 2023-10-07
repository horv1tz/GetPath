@echo off
reg query "HKEY_CLASSES_ROOT\*\shell\Get-file-path" >nul 2>&1
if %errorlevel% equ 0 (echo True) else (echo False)
