class_name ControlsApi
extends RefCounted
# Allowed: controls is the one module that reads Input.
static func throttle() -> float:
	return Input.get_axis(&"drive_throttle_down", &"drive_throttle_up")
