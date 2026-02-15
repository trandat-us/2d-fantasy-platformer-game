extends Item
class_name EquipmentItem

enum Slot {
	WEAPON,
	HELMET,
	CHEST,
	LEGGINGS,
	BOOTS
}

@export var slot: Slot
@export var effects: Array[Effect]

var is_equipped: bool = false

func use(context: Variant) -> bool:
	if not context is Player:
		return false
	
	if is_equipped:
		if context.unequip(slot):
			return true
	else:
		if context.equip(self):
			return true
	return false

func on_equip(equipper: Variant) -> void:
	for e in effects:
		e.apply(equipper)

func on_unequip() -> void:
	for e in effects:
		e.reverse()
