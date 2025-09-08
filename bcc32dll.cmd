@echo off
setlocal enabledelayedexpansion

set DIR=%~dp0

set args=
set dll=
set lib=
set def=
set count=0
for %%f in (%*) do (
    set /a count+=1
    set "f=%%f"
    if !count! EQU 1 set dll=!f!
    if !count! EQU 2 set lib=!f!

    if !count! GTR 2 (
        set "ext=!f:~-4!"
        if /i "!ext!"==".def" (
            set def=!f!
        ) else (
            set args=!args! "!f!"
        )
    )
)

if "!def!"=="" goto skip_hack
set PATH=%DIR%linkhack;%PATH%
set DEFFILE=%def%
:skip_hack

if exist bcc32-failed del bcc32-failed
("%DIR%bin\bcc32" "-e%dll%" %args% || echo 1 > bcc32-failed) ^
    | grep -v "Borland C++ 4.52 for Win32 Copyright (c) 1993, 1994 Borland International" ^
    | grep -v "Turbo Link  Version 1.50 for Win32 Copyright (c) 1993,1994 Borland International"
if exist bcc32-failed (
    del bcc32-failed
    exit /B 1
    )

if exist implib-failed del implib-failed
("%DIR%bin\implib" -c -w "%lib%" "%dll%" || echo 1 > implib-failed) ^
    | grep -v "Turbo Implib Version 2.0 Copyright (c) 1991, 1994 Borland International" ^
    | grep -v -E "^$"
if exist implib-failed (
    del implib-failed
    exit /B 1
    )
