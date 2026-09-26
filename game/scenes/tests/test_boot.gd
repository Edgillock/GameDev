extends GdUnitTestSuite
## Guards the composition root: pressing Play must reach a usable test ground (M00-T4).

const BOOT_SCENE := "res://game/scenes/boot.tscn"


func test_boot_is_the_main_scene() -> void:
	var main_scene: String = ProjectSettings.get_setting("application/run/main_scene")
	# The editor may rewrite the setting as a uid:// reference when it saves project.godot.
	if main_scene.begins_with("uid://"):
		main_scene = ResourceUID.get_id_path(ResourceUID.text_to_id(main_scene))
	assert_str(main_scene).is_equal(BOOT_SCENE)


func test_boot_loads_a_1_km_ground_whose_top_is_y_0() -> void:
	var runner := scene_runner(BOOT_SCENE)
	var ground := runner.find_child("Ground") as StaticBody3D
	assert_object(ground).is_not_null()
	var box := (ground.get_node("CollisionShape3D") as CollisionShape3D).shape as BoxShape3D
	assert_vector(box.size).is_equal(Vector3(1000, 1, 1000))
	assert_float(ground.global_position.y + box.size.y / 2.0).is_equal_approx(0.0, 0.001)


func test_boot_loads_light_sky_and_a_camera_on_the_origin() -> void:
	var runner := scene_runner(BOOT_SCENE)
	assert_object(runner.find_child("Sun") as DirectionalLight3D).is_not_null()
	var world_env := runner.find_child("WorldEnvironment") as WorldEnvironment
	assert_int(world_env.environment.background_mode).is_equal(Environment.BG_SKY)
	assert_object(world_env.environment.sky).is_not_null()
	var camera := runner.find_child("Camera") as Camera3D
	var to_origin := (Vector3.ZERO - camera.global_position).normalized()
	assert_float((-camera.global_basis.z).dot(to_origin)).is_equal_approx(1.0, 0.0001)
