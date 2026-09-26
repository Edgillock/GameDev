extends RefCounted
## One boundary violation, printed as `file:line: rule — detail`.

var file: String
var line: int
var rule: String
var detail: String


func _init(p_file: String, p_line: int, p_rule: String, p_detail: String) -> void:
	file = p_file
	line = p_line
	rule = p_rule
	detail = p_detail


## The full report line.
func to_text() -> String:
	return "%s:%d: %s — %s" % [file, line, rule, detail]


## `file:line: rule` only: what the fixture tests compare, so wording changes don't break them.
func key() -> String:
	return "%s:%d: %s" % [file, line, rule]
