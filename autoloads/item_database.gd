extends Node

const ITEM_DIR = "res://data/item/"

var item_database: Dictionary

func _ready() -> void:
	_load_all_item_recursive(ITEM_DIR, item_database)

func _load_all_item_recursive(path: String, result: Dictionary) -> void:
	var dir := DirAccess.open(path)
	
	if dir == null:
		push_error("Cannot open folder: " + path)
		return
	
	dir.list_dir_begin()
	var content = dir.get_next()
	
	while content != "":
		var full_path = path + "/" + content
		if dir.current_is_dir():
			if not content.begins_with("."):
				_load_all_item_recursive(full_path, result)
		else:
			if content.ends_with(".tres"):
				var res = load(full_path)
				if res and res is Item:
					result[res.id] = res
		
		content = dir.get_next()
	
	dir.list_dir_end()

func get_item(id: String) -> Item:
	var item = item_database.get(id)
	if item:
		return item.duplicate()
	return null
