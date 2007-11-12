echo off
setlocal
color f2
title Install JOD

rem these paths may require editing
set JPATH=c:\j602\
set JCONSOLE=%JPATH%bin\jconsole.exe
set JODINSTALL=%JPATH%addons\general\jod\install.ed

rem test for current install and do nothing if found
if exist %JODINSTALL% goto errjodhere

rem installs JOD using jconsole.exe
if not exist %JCONSOLE% goto errconsole
%JCONSOLE% ~addons\general\jod\installjod.ijs
goto theend

:errconsole
color 4f
echo JOD install error - JOD not installed.
echo jconsole.exe is not at: %JCONSOLE%
echo Adjust paths in this *.bat and try again.
goto theend

:errjodhere
echo JOD is already installed - nothing to do.

:theend
endlocal
pause

