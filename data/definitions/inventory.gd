extends Resource
class_name Inventory

const MAX_SLOTS_PER_INVENTORY = 36

const REDUCED_ITEM_FAILED = 0
const REDUCED_ITEM_REMAINING = 1
const REDUCED_ITEM_EMPTY = 2

enum ReducedItemResult {
	REDUCED_ITEM_FAILED,
	REDUCED_ITEM_REMAINING,
	REDUCED_ITEM_EMPTY
}

@export var general: Array[InventoryItem]
@export var food: Array[InventoryItem]
@export var loot: Array[InventoryItem]
@export var equipment: Array[InventoryItem]
@export var chest: Array[InventoryItem]

@export_range(0, 1_000_000, 1, "hide_control", "or_greater") var coins: int = 0

var inventories = {
	Item.ItemType.GENERAL: general,
	Item.ItemType.FOOD: food,
	Item.ItemType.LOOT: loot,
	Item.ItemType.EQUIPMENT: equipment,
	Item.ItemType.CHEST: chest
}

func _init() -> void:
	_init_memory.call_deferred()

func _init_memory():
	general.resize(MAX_SLOTS_PER_INVENTORY)
	food.resize(MAX_SLOTS_PER_INVENTORY)
	loot.resize(MAX_SLOTS_PER_INVENTORY)
	equipment.resize(MAX_SLOTS_PER_INVENTORY)
	chest.resize(MAX_SLOTS_PER_INVENTORY)
	
	for i in range(MAX_SLOTS_PER_INVENTORY):
		general[i] = InventoryItem.new()
		food[i] = InventoryItem.new()
		loot[i] = InventoryItem.new()
		equipment[i] = InventoryItem.new()
		chest[i] = InventoryItem.new()

func _get_empty_slot(inv: Array[InventoryItem]) -> InventoryItem:
	for i in range(inv.size()):
		if inv[i].is_empty():
			return inv[i]
	
	return null

func _sort_inventory(inv: Array[InventoryItem]) -> void:
	var filled_list: Array[InventoryItem] = []
	
	for slot in inv:
		if not slot.is_empty():
			filled_list.append(slot.duplicate())
	
	filled_list.sort_custom(
		func(a : InventoryItem, b: InventoryItem): 
			return a.item.id.naturalcasecmp_to(b.item.id) < 0
	)
	
	var index := 0
	for slot in filled_list:
		inv[index].item = slot.item
		inv[index].amount = slot.amount
		index += 1
	
	for i in range(index, inv.size()):
		inv[i].clear()

func add_item(item: Item, amount: int = 1) -> bool:
	if amount < 1 or item == null:
		return false
		
	if item.id == "item_coin":
		add_coins(amount)
		return true
	
	var target_inventory: Array[InventoryItem] = inventories.get(item.type)
	if target_inventory == null:
		return false
	
	if item.can_stack:
		for slot in target_inventory:
			if not slot.is_empty() and slot.item.id == item.id:
				slot.amount += amount
				_sort_inventory(target_inventory)
				return true
		
		var empty_slot = _get_empty_slot(target_inventory)
		if empty_slot == null:
			return false
		else:
			empty_slot.item = item.duplicate(true)
			empty_slot.amount = amount
			_sort_inventory(target_inventory)
			return true
	else:
		for __ in range(amount):
			var empty_slot = _get_empty_slot(target_inventory)
			if empty_slot == null:
				_sort_inventory(target_inventory)
				return false
			else:
				empty_slot.item = item.duplicate(true)
				empty_slot.amount = 1
		_sort_inventory(target_inventory)
		return true

func add_item_by_id(id: String, amount: int = 1) -> bool:
	var item = ItemDatabase.get_item(id)
	if item == null or amount < 1:
		return false
	
	return add_item(item, amount)

func add_coins(amount: int = 1) -> void:
	if amount < 1:
		return
	
	coins += amount

func reduce_item(inv_item: InventoryItem, amount: int = 1) -> ReducedItemResult:
	if amount < 1 or inv_item.is_empty():
		return REDUCED_ITEM_FAILED as ReducedItemResult
	
	if inv_item.item.id == "item_coin":
		reduce_coins(amount)
		if coins == 0:
			return REDUCED_ITEM_EMPTY as ReducedItemResult
		else:
			return REDUCED_ITEM_REMAINING as ReducedItemResult
	
	var target_inventory: Array[InventoryItem] = inventories.get(inv_item.item.type)
	if target_inventory == null:
		return REDUCED_ITEM_FAILED as ReducedItemResult
	
	for slot in target_inventory:
		if not slot.is_empty() and slot == inv_item:
			slot.amount -= amount
			if slot.amount <= 0:
				slot.clear()
				_sort_inventory(target_inventory)
				return REDUCED_ITEM_EMPTY as ReducedItemResult
			else:
				_sort_inventory(target_inventory)
				return REDUCED_ITEM_REMAINING as ReducedItemResult
	
	return REDUCED_ITEM_FAILED as ReducedItemResult

func reduce_coins(amount: int = 1) -> void:
	if amount < 1:
		return
	coins = max(0, coins - amount)

func get_all_items() -> Array[InventoryItem]:
	var items: Array[InventoryItem] = []
	
	for item in general:
		items.append(item)
	for item in food:
		items.append(item)
	for item in loot:
		items.append(item)
	for item in equipment:
		items.append(item)
	for item in chest:
		items.append(item)
	
	return items
