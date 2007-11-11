echo off
color f2
title Reset JOD

rem resets JOD using jconsole.exe
if not exist c:\j602\bin\jconsole.exe goto errconsole
c:\j602\bin\jconsole.exe ~addons\general\jod\resetjod.ijs
goto theend

:errconsole
color 4f
echo JOD reset error - JOD not reset.
echo jconsole.exe is not at: c:\j602\bin\jconsole.exe
echo Adjust paths in this *.bat and try again.

:theend
pause