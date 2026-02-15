extends Resource
class_name Equipment

@export var equipped_items: Dictionary[EquipmentItem.Slot, EquipmentItem]

var equipper: Node
var stats: BaseStats

func equip(item: EquipmentItem) -> bool:
	if not equipper or not stats:
		return false
	
	if equipped_items.has(item.slot):
		unequip(item.slot)
	
	equipped_items[item.slot] = item
	item.on_equip(equipper)
	item.is_equipped = true
	return true

func unequip(slot: EquipmentItem.Slot) -> bool:
	if not equipper or not stats:
		return false
	
	if equipped_items.has(slot):
		var item = equipped_items[slot]
		item.on_unequip()
		item.is_equipped = false
		equipped_items.erase(slot)
		return true
	return false
