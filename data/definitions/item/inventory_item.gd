extends Resource
class_name InventoryItem

@export var item: Item
@export var amount: int = 1

func is_empty():
	return item == null
