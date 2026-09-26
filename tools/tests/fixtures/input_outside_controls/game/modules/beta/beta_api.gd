class_name BetaApi
extends Node
# Allowed: InputEvent is not Input, and Input.x in comments or strings is not a use.
func _unhandled_input(event: InputEvent) -> void:
	var hint := "press Input.is_action_pressed"
	var doc := """
	Input.get_vector() inside a multi-line string
	"""
	print(event, hint, doc, $Input.visible, %Input.visible)  # child nodes named Input are not Input
# Forbidden: reading Input outside controls.
func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed(&"drive_brake"):
		pass
