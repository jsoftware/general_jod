echo off
setlocal
color f2
title Reset JOD

rem these paths may require editing
set JPATH="c:\Program Files\j602\
set JCONSOLE=%JPATH%bin\jconsole.exe"

rem resets JOD using jconsole.exe
if not exist %JCONSOLE% goto errconsole
%JCONSOLE% ~addons\general\jod\resetjod.ijs
goto theend

:errconsole
color 4f
echo JOD reset error - JOD not reset.
echo -------------------------------------------------
echo (jconsole.exe) is not at: %JCONSOLE%
echo Adjust JPATH in this *.bat and try again.
echo -------------------------------------------------

:theend
endlocal
pause