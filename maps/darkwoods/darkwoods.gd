extends Map

@onready var village_entry: MapTransitionArea = $VillageEntry
@onready var cave_entry: MapTransitionArea = $CaveEntry

@onready var enemies: Node2D = $Enemies

func init_scene(scene_data: Variant) -> void:
	if scene_data is MapHandoffData:
		_handle_map_handoff_data(scene_data)
	elif scene_data is MapSavePointData:
		_handle_map_save_point_data(scene_data)
	
	for enemy in enemies.get_children():
		if enemy is Enemy:
			enemy.enable_point_light()

func cleanup_scene() -> void:
	player.disable_light_point()
	spawn_point.remove_child(player)

func setup_player() -> void:
	player.enable_light_point()
	
	player.disable_camera_smoothing()
	player.global_position = spawn_point.global_position
	await get_tree().physics_frame
	player.enable_camera_smoothing()

func _handle_map_handoff_data(data: MapHandoffData) -> void:
	if data.map_name == "AshwickVillage":
		move_spawn_point(village_entry.global_position - Vector2(100.0, 0))
	elif data.map_name == "SilentCave":
		_on_player_head_to_cave()
		move_spawn_point(cave_entry.global_position + Vector2(100.0, 0))
	
	add_player(data.player)
	setup_player()

func _handle_map_save_point_data(data: MapSavePointData) -> void:
	move_spawn_point(data.save_point_position)
	add_player(data.player)
	setup_player()
	player.revive()
	player.direction = data.player_direction

func _on_player_head_to_cave() -> void:
	level_bounds.width = 3014
	level_bounds.position.x = -1272
	level_bounds.set_camera_limits()

func _on_player_away_from_cave() -> void:
	level_bounds.width = 3830
	level_bounds.position.x = -2088
	level_bounds.set_camera_limits()

func _on_cave_enter_detector_exited(body: Node2D) -> void:
	var _exit_direction = sign(body.global_position.x - $CaveEnterDetector.global_position.x)
	if _exit_direction == 1:
		_on_player_away_from_cave()
	elif _exit_direction == -1:
		_on_player_head_to_cave()
