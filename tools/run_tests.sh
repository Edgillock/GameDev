#!/usr/bin/env bash
# Runs every gdUnit4 test under res://game headless and exits non-zero on any failure.
# Used by Claude (Git Bash on Windows, bash in cloud sessions); the owner double-clicks run_tests.cmd.
# Reads the Godot executable from tools/local.cfg. Reports and the full log go to reports/.
set -u
cd "$(dirname "$0")/.." || exit 2

cfg=tools/local.cfg
if [ ! -f "$cfg" ]; then
	echo "tools/local.cfg is missing: copy tools/local.cfg.example to tools/local.cfg and set your Godot path." >&2
	exit 2
fi
# tr: the owner may save local.cfg with Windows line endings.
godot=$(tr -d '\r' < "$cfg" | awk -F'"' '/^\[/ { section = $0 } section == "[godot]" && /^[ \t]*path[ \t]*=/ { print $2; exit }')
if [ -z "$godot" ]; then
	echo "No [godot] path=\"...\" entry in tools/local.cfg." >&2
	exit 2
fi
# On Windows the plain .exe detaches from the terminal; its _console twin keeps output and exit code.
case "$godot" in
	*.exe) [ -f "${godot%.exe}_console.exe" ] && godot="${godot%.exe}_console.exe" ;;
esac
if [ ! -f "$godot" ]; then
	echo "Godot not found at '$godot' (from tools/local.cfg)." >&2
	exit 2
fi

mkdir -p reports
# Keeps Godot from importing the HTML report's images as game assets.
: > reports/.gdignore
log=reports/last_run.log

# A fresh checkout has no class cache yet, and new class_names only register on import.
echo "Importing project..."
if ! "$godot" --headless --path . --import > reports/last_import.log 2>&1; then
	cat reports/last_import.log
	echo "FAILED: Godot could not import the project (log: reports/last_import.log)." >&2
	exit 1
fi

# No -d / --remote-debug (unlike gdUnit4's runtest.sh): results and exit codes are identical
# without them on Godot 4.7.2, and they print misleading ERROR lines about port 0.
"$godot" --headless --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd \
	-a res://game -rd res://reports --ignoreHeadlessMode 2>&1 | tee "$log"
code=${PIPESTATUS[0]}

# gdUnit4 exit codes: see GdUnitTestSessionRunner.gd.
case $code in
	0) result="PASSED: all tests passed." ;;
	100) result="FAILED: a test failed or raised an error (see above)." ;;
	101) result="FAILED: tests passed but left orphan nodes, i.e. leaked memory (see the orphan report above)." ;;
	104) result="FAILED: this gdUnit4 version does not support this Godot version." ;;
	105) result="FAILED: script errors while loading the tests (see SCRIPT ERROR above)." ;;
	*) result="FAILED: the test runner stopped with exit code $code." ;;
esac

echo
echo "================ Test summary ================"
sed 's/\x1b\[[0-9;]*[A-Za-z]//g' "$log" | grep -m 1 '^Overall Summary:' | sed 's/^Overall Summary: //'
echo "$result"
echo "Full log: $log   HTML report: reports/"
exit "$code"
