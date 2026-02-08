extends CanvasLayer
class_name TravelBook

@onready var inventory_section: VBoxContainer = %InventorySection

var inventory: Inventory

func _ready() -> void:
	if inventory:
		inventory_section.init_inventory(inventory)

func refresh_inventory():
	inventory_section.refresh()
