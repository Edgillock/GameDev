extends RefCounted
## The module dependency graph from a module_graph.cfg file, and the graph-level rules of M00-T3.

const Violation := preload("res://tools/boundaries/violation.gd")

const KIND_APP := "app"
const KIND_CORE := "core"
const KIND_PRESENTATION := "presentation"
const USES_ANY := "*"
## M01 puts the Services autoload in game/autoload/. The graph lists no path for it, so it counts as core.
const AUTOLOAD_DIR := "game/autoload"

## How violations name the graph file, e.g. "tools/module_graph.cfg".
var label: String

var _paths: Dictionary[String, String] = {}  # module key -> folder relative to the root, e.g. "game/modules/power"
var _kinds: Dictionary[String, String] = {}
var _uses: Dictionary[String, PackedStringArray] = {}
var _lines: Dictionary[String, int] = {}  # module key -> line of its [section] header


## Reads the graph. `p_label` is only used in violation messages.
func load_file(path: String, p_label: String) -> Error:
	label = p_label
	var cfg := ConfigFile.new()
	var err := cfg.load(path)
	if err != OK:
		return err
	for key: String in cfg.get_sections():
		_paths[key] = str(cfg.get_value(key, "path", "")).trim_prefix("res://").trim_suffix("/")
		_kinds[key] = str(cfg.get_value(key, "kind", ""))
		var uses := PackedStringArray()
		for used: Variant in cfg.get_value(key, "uses", []) as Array:
			uses.append(str(used))
		_uses[key] = uses
	var header := RegEx.create_from_string("^\\[([^\\]]+)\\]")
	var lines := FileAccess.get_file_as_string(path).split("\n")
	for i: int in lines.size():
		var m := header.search(lines[i])
		if m != null:
			_lines[m.get_string(1)] = i + 1
	return OK


## Unknown modules in `uses`, non-presentation modules using presentation ones, and cycles.
func validate() -> Array[Violation]:
	var out: Array[Violation] = []
	for key: String in _uses:
		for used: String in _uses[key]:
			if used == USES_ANY:
				continue
			if not _uses.has(used):
				out.append(Violation.new(label, _lines[key], "graph-unknown-module",
						"'%s' uses '%s', which is not a module in this file" % [key, used]))
			elif _kinds[used] == KIND_PRESENTATION and _kinds[key] != KIND_PRESENTATION and _kinds[key] != KIND_APP:
				out.append(Violation.new(label, _lines[key], "graph-uses-presentation",
						"'%s' (%s) uses presentation module '%s'; game rules must not depend on UI" % [key, _kinds[key], used]))
	out.append_array(_find_cycles())
	return out


## The module whose folder contains `rel_path` (deepest match), or "" if none does.
func owner_of(rel_path: String) -> String:
	var best := ""
	var best_length := 0
	for key: String in _paths:
		var folder := _paths[key]
		if folder != "" and _is_inside(rel_path, folder) and folder.length() > best_length:
			best = key
			best_length = folder.length()
	if best == "" and _is_inside(rel_path, AUTOLOAD_DIR):
		best = core_key()
	return best


func core_key() -> String:
	for key: String in _kinds:
		if _kinds[key] == KIND_CORE:
			return key
	return ""


func is_core(key: String) -> bool:
	return _kinds.get(key, "") == KIND_CORE


func is_app(key: String) -> bool:
	return _kinds.get(key, "") == KIND_APP


## True if `owner` may reference module `target` at all (its API and public types).
func may_use(owner: String, target: String) -> bool:
	if owner == target or is_core(target):
		return true
	var uses: PackedStringArray = _uses.get(owner, PackedStringArray())
	return uses.has(target) or uses.has(USES_ANY)


## True if `rel_path` is part of `key`'s public surface: its <key>_api.gd, its public/, or anything in core.
func is_public(key: String, rel_path: String) -> bool:
	if is_core(key):
		return true
	var sub := _sub_path(key, rel_path)
	return sub == key + "_api.gd" or _is_inside(sub, "public")


## True if `rel_path` lies in `key`'s internal/ folder.
func is_internal(key: String, rel_path: String) -> bool:
	return _is_inside(_sub_path(key, rel_path), "internal")


func _sub_path(key: String, rel_path: String) -> String:
	var folder: String = _paths.get(key, "")
	return rel_path.trim_prefix(folder + "/")


static func _is_inside(path: String, folder: String) -> bool:
	return path == folder or path.begins_with(folder + "/")


## Modules `key` depends on, with "*" expanded to every other module; unknown names are skipped.
func _edges(key: String) -> PackedStringArray:
	var edges := PackedStringArray()
	for used: String in _uses[key]:
		if used == USES_ANY:
			for other: String in _uses:
				if other != key:
					edges.append(other)
		elif _uses.has(used):
			edges.append(used)
	return edges


func _find_cycles() -> Array[Violation]:
	var out: Array[Violation] = []
	var state: Dictionary[String, int] = {}  # absent = unvisited, 1 = on the current path, 2 = done
	var reported: Dictionary[String, bool] = {}
	for key: String in _uses:
		if not state.has(key):
			_visit(key, state, [], reported, out)
	return out


func _visit(key: String, state: Dictionary[String, int], path: Array[String],
		reported: Dictionary[String, bool], out: Array[Violation]) -> void:
	state[key] = 1
	path.append(key)
	for used: String in _edges(key):
		if state.get(used, 0) == 1:
			var cycle: Array[String] = path.slice(path.find(used))
			var members := PackedStringArray(cycle)
			members.sort()
			var id := ",".join(members)
			if not reported.has(id):
				reported[id] = true
				cycle.append(used)
				out.append(Violation.new(label, _lines[cycle[0]], "graph-cycle",
						"dependency cycle: %s" % " -> ".join(PackedStringArray(cycle))))
		elif not state.has(used):
			_visit(used, state, path, reported, out)
	path.pop_back()
	state[key] = 2
