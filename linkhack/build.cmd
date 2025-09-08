@echo off
set PATH=%~dp0..\bin;%PATH%
if exist tlink32.exe del tlink32.exe
bcc32 -I%~dp0..\include -L%~dp0..\lib "%~dp0tlink32.c" || exit /B 1
if exist tlink32.obj del tlink32.obj
