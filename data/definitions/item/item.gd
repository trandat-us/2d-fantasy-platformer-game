extends Resource
class_name Item

enum ItemType {
	GENERAL,
	FOOD,
	KEY,
	WEAPON,
	CHEST
}

@export var id: String
@export var name: String
@export_multiline() var description: String
@export var texture: Texture2D
@export var type: ItemType
@export var can_stack: bool = true
