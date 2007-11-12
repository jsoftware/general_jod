echo off
setlocal
color f2
title Reset JOD

rem these paths may require editing
set JPATH=c:\j602\
set JCONSOLE=%JPATH%bin\jconsole.exe

rem resets JOD using jconsole.exe
if not exist %JCONSOLE% goto errconsole
%JCONSOLE% ~addons\general\jod\resetjod.ijs
goto theend

:errconsole
color 4f
echo JOD reset error - JOD not reset.
echo jconsole.exe is not at: %JCONSOLE%
echo Adjust paths in this *.bat and try again.

:theend
endlocal
pause