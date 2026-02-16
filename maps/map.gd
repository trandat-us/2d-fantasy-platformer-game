extends Node2D
class_name Map

@onready var level_bounds: LevelBounds = $LevelBounds
@onready var spawn_point: Node2D = $SpawnPoint

var player: Player

func init_scene(scene_data: Variant) -> void:
	pass

func cleanup_scene() -> void:
	pass

func move_spawn_point(new_position: Vector2):
	spawn_point.position = new_position

func add_player(player_scene: Player):
	player = player_scene
	player.position = Vector2.ZERO
	spawn_point.add_child(player)
	
	level_bounds.set_camera_limits()

func setup_player() -> void:
	pass

func get_handoff_data() -> MapHandoffData:
	var handoff_data: MapHandoffData
	handoff_data = MapHandoffData.new()
	handoff_data.player = player
	handoff_data.map_name = name
	
	return handoff_data

func _handle_map_handoff_data(data: MapHandoffData) -> void:
	pass

func _handle_map_save_point_data(data: MapSavePointData) -> void:
	pass
