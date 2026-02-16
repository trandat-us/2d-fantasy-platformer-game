extends Map

@onready var village_entry: MapTransitionArea = $VillageEntry
@onready var cave_entry: MapTransitionArea = $CaveEntry

@onready var enemies: Node2D = $Enemies

func init_scene(scene_data: Variant) -> void:
	if scene_data is MapHandoffData:
		_handle_map_handoff_data(scene_data)
	
	for enemy in enemies.get_children():
		if enemy is Enemy and enemy.has_method("enable_light_point"):
			enemy.enable_light_point()

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
		move_spawn_point(cave_entry.global_position + Vector2(150.0, 0))
	
	add_player(data.player)
	setup_player()
