echo off
color f2
title Install JOD

rem test for current install and do nothing if found
if exist c:\j602\addons\general\jod\install.ed goto errjodhere

rem installs JOD using jconsole.exe
if not exist c:\j602\bin\jconsole.exe goto errconsole
c:\j602\bin\jconsole.exe ~addons\general\jod\installjod.ijs
goto theend

:errconsole
color 4f
echo JOD install error - JOD not installed.
echo jconsole.exe is not at: c:\j602\bin\jconsole.exe
echo Adjust paths in this *.bat and try again.
goto theend

:errjodhere
echo JOD is already installed - nothing to do.

:theend
pause

