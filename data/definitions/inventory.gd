extends Resource
class_name Inventory

const MAX_SLOTS_PER_INVENTORY = 36

@export var general: Array[InventoryItem]
@export var food: Array[InventoryItem]
@export var key: Array[InventoryItem]
@export var weapon: Array[InventoryItem]
@export var chest: Array[InventoryItem]

var inventories = {
	Item.ItemType.GENERAL: general,
	Item.ItemType.FOOD: food,
	Item.ItemType.KEY: key,
	Item.ItemType.WEAPON: weapon,
	Item.ItemType.CHEST: chest
}

func _init() -> void:
	_init_memory.call_deferred()

func _init_memory():
	general.resize(MAX_SLOTS_PER_INVENTORY)
	food.resize(MAX_SLOTS_PER_INVENTORY)
	key.resize(MAX_SLOTS_PER_INVENTORY)
	weapon.resize(MAX_SLOTS_PER_INVENTORY)
	chest.resize(MAX_SLOTS_PER_INVENTORY)
	
	for i in range(MAX_SLOTS_PER_INVENTORY):
		general[i] = InventoryItem.new()
		food[i] = InventoryItem.new()
		key[i] = InventoryItem.new()
		weapon[i] = InventoryItem.new()
		chest[i] = InventoryItem.new()

func _get_empty_slot(inv: Array[InventoryItem]) -> InventoryItem:
	for i in range(inv.size()):
		if inv[i].is_empty():
			return inv[i]
	
	return null

func add_item(item: Item, amount: int = 1) -> bool:
	if amount < 1 or item == null:
		return false

	var target_inventory: Array[InventoryItem] = inventories.get(item.type)
	if target_inventory == null:
		return false
	
	if item.can_stack:
		for slot in target_inventory:
			if not slot.is_empty() and slot.item.id == item.id:
				slot.amount += amount
				return true
		
		var empty_slot = _get_empty_slot(target_inventory)
		if empty_slot == null:
			return false
		else:
			empty_slot.item = item
			empty_slot.amount = amount
			return true
	else:
		var empty_slot = _get_empty_slot(target_inventory)
		if empty_slot == null:
			return false
		else:
			empty_slot.item = item
			return true
