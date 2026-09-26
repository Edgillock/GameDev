extends Node
## The main scene: the composition root that wires modules together, then loads the world (M00-T4).
## Module registration calls (e.g. MobilityApi.register()) go at the top of _ready(), before the world loads.

const TEST_GROUND := preload("res://game/scenes/test_ground.tscn")


func _ready() -> void:
	add_child(TEST_GROUND.instantiate())
