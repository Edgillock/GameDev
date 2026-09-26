@echo off
rem Fails on forbidden cross-module references in game/ (rules: docs/specs/M00-foundation.md, M00-T3).
rem Double-click it, or run it from a terminal; add --self-test to prove every rule fires on the fixtures.
rem Claude uses check_boundaries.sh; both read the Godot path from tools\local.cfg.
setlocal EnableExtensions
cd /d "%~dp0.."
set "CODE=0"

rem A fresh checkout never has tools\local.cfg (git ignores it); the example carries the owner's path.
if not exist "tools\local.cfg" copy /y "tools\local.cfg.example" "tools\local.cfg" >nul 2>&1 && echo Created tools\local.cfg from tools\local.cfg.example.
if not exist "tools\local.cfg" (
	echo tools\local.cfg is missing: copy tools\local.cfg.example to tools\local.cfg and set your Godot path.
	set "CODE=2"
	goto :end
)
set "GODOT="
for /f "usebackq tokens=1,* delims==" %%a in ("tools\local.cfg") do (
	if /i "%%a"=="path" set "GODOT=%%~b"
)
if not defined GODOT (
	echo No [godot] path="..." entry in tools\local.cfg.
	set "CODE=2"
	goto :end
)
set "GODOT=%GODOT:/=\%"
rem The plain .exe detaches from the terminal; its _console twin keeps output and exit code.
if exist "%GODOT:.exe=_console.exe%" set "GODOT=%GODOT:.exe=_console.exe%"
rem Windows "Extract All" makes a folder named like the .exe; a trailing \ tests for a folder.
if exist "%GODOT%\" (
	echo "%GODOT%" is a folder. Edit path= in tools\local.cfg to point at the Godot .exe inside it.
	set "CODE=2"
	goto :end
)
if not exist "%GODOT%" (
	echo Godot not found at "%GODOT%". Edit path= in tools\local.cfg to point at your Godot executable.
	set "CODE=2"
	goto :end
)

set "SCRIPT=res://tools/check_boundaries.gd"
if /i "%~1"=="--self-test" set "SCRIPT=res://tools/tests/check_boundaries_test.gd"
"%GODOT%" --headless --path . --script %SCRIPT%
set "CODE=%ERRORLEVEL%"

:end
if "%CODE%"=="2" echo FAILED: setup problem, see the message above ^(tools\local.cfg or the Godot path^).
rem Keep the window open when double-clicked, so the result can be read.
echo %cmdcmdline% | findstr /i /c:"%~nx0" >nul && pause
exit /b %CODE%
