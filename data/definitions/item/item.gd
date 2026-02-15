extends Resource
class_name Item

enum ItemType {
	GENERAL,
	FOOD,
	LOOT,
	EQUIPMENT,
	CHEST
}

@export var id: String
@export var name: String
@export_multiline() var description: String
@export var texture: Texture2D
@export var type: ItemType
@export var can_stack: bool = true

func use(context: Variant) -> bool:
	return false
