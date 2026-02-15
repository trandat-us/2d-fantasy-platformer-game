@tool
extends Resource
class_name LootItem

@export var item: Item
@export_range(0, 100, 0.01, "hide_control", "suffix:%") var possibility: float = 0
@export_range(1, 1000000, 1, "or_greater", "hide_control") var min_amount: int = 1:
	set(value):
		min_amount = value
		if min_amount > max_amount:
			max_amount = min_amount
		notify_property_list_changed()
@export_range(1, 1000000, 1, "or_greater", "hide_control") var max_amount: int = 1:
	set(value):
		if value < min_amount:
			max_amount = min_amount
		else:
			max_amount = value
		notify_property_list_changed()

func is_empty() -> bool:
	return item == null

func get_drop_amount() -> int:
	if randf_range(0, 100) >= possibility:
		return 0
	return randi_range(min_amount, max_amount)
