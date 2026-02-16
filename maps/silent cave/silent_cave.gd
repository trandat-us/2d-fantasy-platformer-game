extends Map

@onready var darkwoods_entry: MapTransitionArea = $DarkwoodsEntry
@onready var player_direction_detector: Area2D = $PlayerDirectionDetector
@onready var enemies: Node2D = $Enemies

func _ready() -> void:
	player_direction_detector.player_go_to_right.connect(_on_player_head_to_darkwoods_entry)
	player_direction_detector.player_go_to_left.connect(_on_player_away_from_darkwoods_entry)

func init_scene(scene_data: Variant) -> void:
	if scene_data is MapHandoffData:
		_handle_map_handoff_data(scene_data)
	
	for enemy in enemies.get_children():
		if enemy is Enemy and enemy.has_method("enable_point_light"):
			enemy.enable_point_light()

func setup_player() -> void:
	player.enable_light_point()
	player.disable_camera_smoothing()
	player.position = Vector2.ZERO
	
	await get_tree().physics_frame
	player.enable_camera_smoothing()

func cleanup_scene() -> void:
	player.disable_light_point()
	spawn_point.remove_child(player)

func _handle_map_handoff_data(data: MapHandoffData) -> void:
	if data.map_name == "Darkwoods":
		move_spawn_point(darkwoods_entry.global_position - Vector2(100.0, 0))
		_on_player_head_to_darkwoods_entry()
	
	add_player(data.player)
	setup_player()

func _on_player_head_to_darkwoods_entry():
	level_bounds.width = 4480
	level_bounds.set_camera_limits()

func _on_player_away_from_darkwoods_entry():
	level_bounds.width = 7000
	level_bounds.set_camera_limits()
