extends SceneTree
## Fails on forbidden cross-module references (M00-T3). Run it through tools/check_boundaries.sh or .cmd.
##
## godot --headless --path . --script res://tools/check_boundaries.gd [-- --root <dir> --graph <file>]
## Checks this project against tools/module_graph.cfg; --root and --graph point it at another tree.
## Exit code: 0 no violations, 1 violations found.

const BoundaryChecker := preload("res://tools/boundaries/boundary_checker.gd")


func _init() -> void:
	var root := ProjectSettings.globalize_path("res://").trim_suffix("/")
	var graph := root + "/tools/module_graph.cfg"
	var args := OS.get_cmdline_user_args()
	for i: int in range(0, args.size() - 1):
		if args[i] == "--root":
			root = args[i + 1].trim_suffix("/")
		elif args[i] == "--graph":
			graph = args[i + 1]

	var checker := BoundaryChecker.new()
	var violations := checker.run(root, graph)
	for v: BoundaryChecker.Violation in violations:
		print(v.to_text())
	print("")
	if violations.is_empty():
		print("Boundary check passed: %d files, no violations." % checker.files_scanned)
	else:
		print("Boundary check FAILED: %d violation(s) in %d files." % [violations.size(), checker.files_scanned])
	quit(0 if violations.is_empty() else 1)
