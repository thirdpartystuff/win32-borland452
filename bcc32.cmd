@echo off
setlocal disabledelayedexpansion
if exist bcc32-failed del bcc32-failed
("%~dp0bin\bcc32" %* || echo 1 > bcc32-failed) ^
    | grep -v "Borland C++ 4.52 for Win32 Copyright (c) 1993, 1994 Borland International" ^
    | grep -v "Turbo Link  Version 1.50 for Win32 Copyright (c) 1993,1994 Borland International" ^
    | grep -v -E "[^.]*.c(c|pp)?:$"
if exist bcc32-failed (
    del bcc32-failed
    exit /B 1
    )
