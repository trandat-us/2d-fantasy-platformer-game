extends Node

const SAVES_DIR_PATH = "user://saves"

const SAVE = "user://save.tres"

var saves_dir: DirAccess

func _ready() -> void:
	if not FileAccess.file_exists(SAVE):
		var save_data = SaveData.new()
		
		save_data.map_scene = "uid://dt7mtt5j61v01"
		
		save_data.player.position = Vector2(-163.0, 539.0)
		save_data.player.direction = 1.0
		save_data.player.inv_data.inv_items.clear()
		save_data.player.inv_data.coins = 0
		
		ResourceSaver.save(save_data, SAVE)

func save_game():
	var save_data = SaveData.new()
	
	var current_map = get_tree().get_first_node_in_group("map") as Map
	var player = get_tree().get_first_node_in_group("player") as Player
	
	save_data.map_scene = ResourceUID.path_to_uid(current_map.scene_file_path)
	save_data.player.position = player.global_position
	save_data.player.direction = player.direction
	
	save_data.player.inv_data.inv_items.clear()
	for inv_item in player.inventory.get_all_items():
		if inv_item == null or inv_item.is_empty():
			continue
		
		var inv_item_data = InvItemData.new()
		inv_item_data.id = inv_item.item.id
		inv_item_data.amount = inv_item.amount
		
		save_data.player.inv_data.inv_items.append(inv_item_data)
	save_data.player.inv_data.coins = player.inventory.coins
	
	ResourceSaver.save(save_data, SAVE)

func get_save_data() -> SaveData:
	if not FileAccess.file_exists(SAVE):
		return null
	
	return load(SAVE) as SaveData

func load_game():
	pass
