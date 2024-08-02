@echo off
title CMD
goto :menu
:menu
set /p cmd="%__CD__%> "
if /i "%cmd%"=="ls" goto :ls
%cmd%
goto :menu

:ls
powershell ls
goto :menu
