extends RefCounted
## Checks every source file under game/ against the module graph (rules: docs/specs/M00-foundation.md, M00-T3).
##
## Known limit: only res:// paths and class names are seen. A reference written as uid://… or built
## from pieces at runtime is not caught.

const ModuleGraph := preload("res://tools/boundaries/module_graph.gd")
const Violation := preload("res://tools/boundaries/violation.gd")

const SCANNED_EXTENSIONS: PackedStringArray = ["gd", "tscn", "tres", "gdshader"]
## The only module allowed to read Input (CLAUDE.md §3.2).
const INPUT_MODULE := "controls"

## Number of files scanned by the last run().
var files_scanned: int = 0

var _graph: ModuleGraph
var _root: String
var _classes: Dictionary[String, String] = {}  # class_name -> file that declares it, relative to the root
var _path_re := RegEx.create_from_string("res://game/[A-Za-z0-9_./-]*")
var _identifier_re := RegEx.create_from_string("[A-Za-z_][A-Za-z0-9_]*")
var _class_name_re := RegEx.create_from_string("(?:^|\\s)class_name\\s+([A-Za-z_][A-Za-z0-9_]*)")
var _input_re := RegEx.create_from_string("(?<![$%.])\\bInput\\s*\\.")  # not $Input. / %Input. / obj.Input.
var _shader_comment_re := RegEx.create_from_string("(?<!:)//.*$")  # (?<!:) keeps res:// paths
var _resource_comment_re := RegEx.create_from_string("^\\s*;.*$")  # .tscn/.tres only have whole-line comments


## Checks the project whose res:// folder is `root` (an absolute path) against `graph_path`.
## Returns every violation, graph rules first, then files in path order.
func run(root: String, graph_path: String) -> Array[Violation]:
	_root = root.trim_suffix("/")
	_graph = ModuleGraph.new()
	var out: Array[Violation] = []
	var graph_label := graph_path.trim_prefix(_root + "/")
	var err := _graph.load_file(graph_path, graph_label)
	if err != OK:
		out.append(Violation.new(graph_label, 0, "graph-unreadable", "cannot read the module graph (%s)" % error_string(err)))
		return out
	out.append_array(_graph.validate())

	var files := _list_files("game")
	files_scanned = files.size()
	for file: String in files:
		if file.ends_with(".gd"):
			_collect_class_name(file)
	var seen: Dictionary[String, bool] = {}
	for file: String in files:
		_check_file(file, out, seen)
	return out


func _check_file(file: String, out: Array[Violation], seen: Dictionary[String, bool]) -> void:
	var owner := _graph.owner_of(file)
	if owner == "":
		_add(Violation.new(file, 1, "unowned-file", "not inside any module folder listed in the module graph"), out, seen)
		return
	var lines := _code_lines(file)
	var code: PackedStringArray = lines[0]  # comments removed
	var bare: PackedStringArray = lines[1]  # comments removed and string contents blanked
	var is_gdscript := file.ends_with(".gd")
	for i: int in code.size():
		var line := i + 1
		for m: RegExMatch in _path_re.search_all(code[i]):
			_check_path(file, line, owner, m.get_string(), out, seen)
		# .tscn/.tres name classes inside quotes (script_class="…"), so scan their strings too.
		var identifier_source := bare[i] if is_gdscript else code[i]
		for m: RegExMatch in _identifier_re.search_all(identifier_source):
			if _classes.has(m.get_string()):
				_check_class(file, line, owner, m.get_string(), out, seen)
		if is_gdscript and owner != INPUT_MODULE and _input_re.search(bare[i]) != null:
			_add(Violation.new(file, line, "input-outside-controls",
					"only '%s' may read Input; other modules receive Orders" % INPUT_MODULE), out, seen)


func _check_path(file: String, line: int, owner: String, res_path: String,
		out: Array[Violation], seen: Dictionary[String, bool]) -> void:
	var target_file := res_path.trim_prefix("res://").trim_suffix("/")
	var target := _graph.owner_of(target_file)
	if target != "" and target != owner:
		_check_access(file, line, owner, target, target_file, res_path, out, seen)


func _check_class(file: String, line: int, owner: String, class_name_used: String,
		out: Array[Violation], seen: Dictionary[String, bool]) -> void:
	var target_file := _classes[class_name_used]
	var target := _graph.owner_of(target_file)
	if target != "" and target != owner:
		_check_access(file, line, owner, target, target_file,
				"%s (declared in %s)" % [class_name_used, target_file], out, seen)


## Shared by path and class references. `target_file` is where the reference points; `what` is how to name it.
func _check_access(file: String, line: int, owner: String, target: String, target_file: String,
		what: String, out: Array[Violation], seen: Dictionary[String, bool]) -> void:
	if _graph.is_core(owner):
		_add(Violation.new(file, line, "core-to-module",
				"core must not reference any module ('%s'): %s" % [target, what]), out, seen)
	elif not _graph.may_use(owner, target):
		_add(Violation.new(file, line, "not-in-uses",
				"'%s' does not list '%s' in its uses: %s" % [owner, target, what]), out, seen)
	elif _graph.is_app(owner):
		if _graph.is_internal(target, target_file):
			_add(Violation.new(file, line, "not-public",
					"the app may use any module except its internal/: %s" % what), out, seen)
	elif not _graph.is_public(target, target_file):
		_add(Violation.new(file, line, "not-public",
				"not in the API or public/ of '%s': %s" % [target, what]), out, seen)


func _add(v: Violation, out: Array[Violation], seen: Dictionary[String, bool]) -> void:
	var text := v.to_text()
	if not seen.has(text):
		seen[text] = true
		out.append(v)


func _collect_class_name(file: String) -> void:
	var bare: PackedStringArray = _code_lines(file)[1]
	for text: String in bare:
		var m := _class_name_re.search(text)
		if m != null:
			if not _classes.has(m.get_string(1)):
				_classes[m.get_string(1)] = file
			return


## Files under `rel_dir` with a scanned extension, sorted, relative to the root.
func _list_files(rel_dir: String) -> PackedStringArray:
	var found := PackedStringArray()
	var dir := DirAccess.open(_root + "/" + rel_dir)
	if dir == null:
		return found
	for name: String in dir.get_files():
		if SCANNED_EXTENSIONS.has(name.get_extension()):
			found.append(rel_dir + "/" + name)
	for sub: String in dir.get_directories():
		found.append_array(_list_files(rel_dir + "/" + sub))
	found.sort()
	return found


## Per line: [0] the text without comments, [1] the same with string contents blanked.
func _code_lines(file: String) -> Array[PackedStringArray]:
	var text := FileAccess.get_file_as_string(_root + "/" + file)
	match file.get_extension():
		"gd":
			return _split_gdscript(text)
		"gdshader":
			return _strip_comments(text, _shader_comment_re)
		_:
			return _strip_comments(text, _resource_comment_re)


## Line-based comment removal for shaders and resource files; their strings need no blanking.
static func _strip_comments(text: String, comment_re: RegEx) -> Array[PackedStringArray]:
	var code := PackedStringArray()
	for line: String in text.split("\n"):
		code.append(comment_re.sub(line, ""))
	return [code, code]


## Tracks quotes across lines so comments and multi-line strings are recognized correctly.
static func _split_gdscript(text: String) -> Array[PackedStringArray]:
	var code := PackedStringArray()
	var bare := PackedStringArray()
	var quote := ""  # the open string's delimiter: "", ', ", ''' or """
	for line: String in text.split("\n"):
		var kept := ""
		var blanked := ""
		var i := 0
		while i < line.length():
			var ch := line[i]
			if quote == "":
				if ch == "#":
					break
				if ch == "\"" or ch == "'":
					quote = ch.repeat(3) if line.substr(i, 3) == ch.repeat(3) else ch
					kept += quote
					blanked += quote
					i += quote.length()
					continue
				kept += ch
				blanked += ch
			elif ch == "\\":
				kept += line.substr(i, 2)
				blanked += "  "
				i += 2
				continue
			elif line.substr(i, quote.length()) == quote:
				kept += quote
				blanked += quote
				i += quote.length()
				quote = ""
				continue
			else:
				kept += ch
				blanked += " "
			i += 1
		if quote.length() == 1:
			quote = ""  # single-quoted strings end at the line break
		code.append(kept)
		bare.append(blanked)
	return [code, bare]
