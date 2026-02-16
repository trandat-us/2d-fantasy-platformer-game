extends Map

@onready var darkwoods_entry: MapTransitionArea = $DarkwoodsEntry

func init_scene(scene_data: Variant) -> void:
	if scene_data is MapHandoffData:
		_handle_map_handoff_data(scene_data)
	elif scene_data is MapSavePointData:
		_handle_map_save_point_data(scene_data)

func cleanup_scene() -> void:
	spawn_point.remove_child(player)

func setup_player() -> void:
	player.disable_camera_smoothing()
	await get_tree().physics_frame
	player.enable_camera_smoothing()

func _handle_map_handoff_data(data: MapHandoffData) -> void:
	if data.map_name == "Darkwoods":
		move_spawn_point(darkwoods_entry.global_position + Vector2(100.0, 0))
	
	add_player(data.player)
	setup_player()

func _handle_map_save_point_data(data: MapSavePointData) -> void:
	move_spawn_point(data.save_point_position)
	add_player(data.player)
	setup_player()
	player.revive()
	player.direction = data.player_direction
