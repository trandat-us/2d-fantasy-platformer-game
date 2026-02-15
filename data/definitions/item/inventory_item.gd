extends Resource
class_name InventoryItem

@export var item: Item
@export var amount: int = 0

func is_empty():
	return item == null

func clear():
	item = null
	amount = 0
