extends Node

const SAVES_DIR_PATH = "user://saves"

const TEST_SAVE = "user://test_save.tres"

var saves_dir: DirAccess

func _ready() -> void:
	#if not DirAccess.dir_exists_absolute(SAVES_DIR_PATH):
		#DirAccess.make_dir_absolute(SAVES_DIR_PATH)
	#
	#saves_dir = DirAccess.open(SAVES_DIR_PATH)
	if not FileAccess.file_exists(TEST_SAVE):
		var save_data = SaveData.new()
		
		save_data.map_scene = "uid://cpjfhh0pawy5q"
		
		save_data.player.position = Vector2(1390.0, 460.0)
		save_data.player.direction = 1.0
		
		ResourceSaver.save(save_data, TEST_SAVE)

#func _unhandled_key_input(event: InputEvent) -> void:
	#if event is InputEventKey and event.is_pressed():
		#if event.keycode == KEY_R:
			#save_game()
		#elif event.keycode == KEY_L:
			#load_game()

func save_game():
	var save_data = SaveData.new()
	
	var current_map = get_tree().get_first_node_in_group("map") as Map
	var player = get_tree().get_first_node_in_group("player") as Player
	
	save_data.map_scene = ResourceUID.path_to_uid(current_map.scene_file_path)
	save_data.player.position = player.global_position
	save_data.player.direction = player.direction
	
	ResourceSaver.save(save_data, TEST_SAVE)

func get_save_data() -> SaveData:
	if not FileAccess.file_exists(TEST_SAVE):
		return null
	
	return load(TEST_SAVE) as SaveData

func load_game():
	pass
