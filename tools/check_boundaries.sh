#!/usr/bin/env bash
# Fails on forbidden cross-module references in game/ (rules: docs/specs/M00-foundation.md, M00-T3).
#   tools/check_boundaries.sh              check the project against tools/module_graph.cfg
#   tools/check_boundaries.sh --self-test  prove every rule fires on the fixtures in tools/tests/fixtures/
# Reads the Godot executable from tools/local.cfg. Exit code 0 = clean, 1 = violations, 2 = setup problem.
set -u
cd "$(dirname "$0")/.." || exit 2

cfg=tools/local.cfg
if [ ! -f "$cfg" ]; then
	# A fresh checkout never has it (git ignores it); the example carries the owner's path.
	if ! cp tools/local.cfg.example "$cfg" 2>/dev/null; then
		echo "tools/local.cfg is missing: copy tools/local.cfg.example to tools/local.cfg and set your Godot path." >&2
		exit 2
	fi
	echo "Created tools/local.cfg from tools/local.cfg.example."
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
if [ -d "$godot" ]; then
	echo "'$godot' is a folder. Edit path= in tools/local.cfg to point at the Godot executable inside it." >&2
	exit 2
fi
if [ ! -f "$godot" ]; then
	echo "Godot not found at '$godot'. Edit path= in tools/local.cfg to point at your Godot executable." >&2
	exit 2
fi

script=res://tools/check_boundaries.gd
if [ "${1:-}" = "--self-test" ]; then
	script=res://tools/tests/check_boundaries_test.gd
fi
"$godot" --headless --path . --script "$script"
