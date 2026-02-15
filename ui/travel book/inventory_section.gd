extends VBoxContainer
class_name InventorySection

@onready var button_types_h_box: HBoxContainer = $ButtonTypesHBox
@onready var inventory_types_container: Control = $InventoryTypesContainer
@onready var general_inventory: InventoryContainer = $InventoryTypesContainer/GeneralInventory
@onready var food_inventory: InventoryContainer = $InventoryTypesContainer/FoodInventory
@onready var loot_inventory: InventoryContainer = $InventoryTypesContainer/KeyInventory
@onready var weapon_inventory: InventoryContainer = $InventoryTypesContainer/WeaponInventory
@onready var chest_inventory: InventoryContainer = $InventoryTypesContainer/ChestInventory
@onready var item_detail_container: ItemDetailContainer = %ItemDetailContainer

var initial_inventory: int = 0

func _ready() -> void:
	for button in button_types_h_box.get_children():
		var idx = button.get_index()
		button.pressed.connect(_set_inventory_visibility.bind(idx))
	
	item_detail_container.inventory_item_updated.connect(refresh)
	
	_set_inventory_visibility(initial_inventory)
	item_detail_container.inv_item = null

func _set_inventory_visibility(idx: int):
	for inventory in inventory_types_container.get_children():
		inventory.visible = inventory.get_index() == idx

func display():
	visible = true
	refresh()
	item_detail_container.display()

func conceal():
	visible = false
	item_detail_container.conceal()

func init_inventory(opener: Node2D):
	if opener is Player:
		var inv = opener.inventory
		general_inventory.init_inventory(inv.general)
		food_inventory.init_inventory(inv.food)
		loot_inventory.init_inventory(inv.loot)
		weapon_inventory.init_inventory(inv.equipment)
		chest_inventory.init_inventory(inv.chest)
		
		item_detail_container.opener = opener

func refresh():
	for child in inventory_types_container.get_children():
		if child is InventoryContainer:
			child.refresh()

func _on_item_focused(inv_item: InventoryItem):
	item_detail_container.inv_item = inv_item
