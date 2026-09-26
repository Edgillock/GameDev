@echo off
rem Runs every gdUnit4 test under res://game headless and exits non-zero on any failure.
rem Double-click it, or run it from a terminal. Claude uses run_tests.sh; both read tools\local.cfg.
setlocal EnableExtensions
cd /d "%~dp0.."
set "CODE=0"

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
if not exist "%GODOT%" (
	echo Godot not found at "%GODOT%" ^(from tools\local.cfg^).
	set "CODE=2"
	goto :end
)

if not exist "reports" mkdir "reports"
rem Keeps Godot from importing the HTML report's images as game assets.
type nul > "reports\.gdignore"

rem A fresh checkout has no class cache yet, and new class_names only register on import.
echo Importing project...
"%GODOT%" --headless --path . --import > "reports\last_import.log" 2>&1
if errorlevel 1 (
	type "reports\last_import.log"
	echo FAILED: Godot could not import the project ^(log: reports\last_import.log^).
	set "CODE=1"
	goto :end
)

"%GODOT%" --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd -a res://game -rd res://reports --ignoreHeadlessMode
set "CODE=%ERRORLEVEL%"

:end
echo.
echo ================ Test summary ================
if "%CODE%"=="0" (
	echo PASSED: all tests passed.
) else if "%CODE%"=="100" (
	echo FAILED: a test failed or raised an error ^(see above^).
) else if "%CODE%"=="101" (
	echo FAILED: tests passed but left orphan nodes, i.e. leaked memory ^(see the orphan report above^).
) else if "%CODE%"=="105" (
	echo FAILED: script errors while loading the tests ^(see SCRIPT ERROR above^).
) else (
	echo FAILED: exit code %CODE%.
)
rem Keep the window open when double-clicked, so the result can be read.
echo %cmdcmdline% | findstr /i /c:"%~nx0" >nul && pause
exit /b %CODE%
