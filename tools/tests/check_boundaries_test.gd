extends SceneTree
## Proves every boundary rule fires on its fixture and stays quiet on the allowed references (M00-T3).
## Run it with: tools/check_boundaries.sh --self-test
##
## Each folder in fixtures/ is a tiny project: a module_graph.cfg, a game/ tree, and expected.txt
## listing exactly the `file:line: rule` violations the checker must report there. Anything missing
## means a rule did not fire; anything extra means an allowed reference was flagged.

const BoundaryChecker := preload("res://tools/boundaries/boundary_checker.gd")
const FIXTURES := "res://tools/tests/fixtures"


func _init() -> void:
	var failed := 0
	var names := DirAccess.get_directories_at(FIXTURES)
	for name: String in names:
		if not _fixture_passes(name):
			failed += 1
	print("")
	if names.is_empty():
		print("Self-test FAILED: no fixtures found in %s." % FIXTURES)
		failed = 1
	elif failed == 0:
		print("Self-test passed: %d fixtures." % names.size())
	else:
		print("Self-test FAILED: %d of %d fixtures." % [failed, names.size()])
	quit(0 if failed == 0 else 1)


func _fixture_passes(name: String) -> bool:
	var root := ProjectSettings.globalize_path(FIXTURES + "/" + name)
	var actual := PackedStringArray()
	for v: BoundaryChecker.Violation in BoundaryChecker.new().run(root, root + "/module_graph.cfg"):
		actual.append(v.key())
	actual.sort()
	var expected := _read_expected(root + "/expected.txt")

	if expected.is_empty():
		print("FAIL %s: expected.txt lists no violation, so no rule is proven to fire" % name)
		return false
	if actual == expected:
		print("PASS %s (%d violation(s) as expected)" % [name, expected.size()])
		return true
	print("FAIL %s" % name)
	for line: String in expected:
		if not actual.has(line):
			print("  missing:    %s" % line)
	for line: String in actual:
		if not expected.has(line):
			print("  unexpected: %s" % line)
	return false


## Non-empty lines of expected.txt that are not # comments, sorted.
static func _read_expected(path: String) -> PackedStringArray:
	var lines := PackedStringArray()
	for line: String in FileAccess.get_file_as_string(path).split("\n"):
		var text := line.strip_edges()
		if text != "" and not text.begins_with("#"):
			lines.append(text)
	lines.sort()
	return lines
